#!/usr/bin/env python

from __future__ import print_function

import os
import re
import sys
import argparse

from task_models.task import (SequentialCombination, LeafCombination)
from task_models.supportive import (SupportivePOMDP, AssembleLeg, AssembleLegToTop,
                                    NHTMHorizon)
from task_models.lib.pomdp import AsyncPOMCPPolicyRunner, export_pomcp
from task_models.lib.belief import format_belief_array

import rospy
from baxter_collaboration_msgs.srv import DoActionResponse
from baxter_collaboration.controller import BaseController


# Arguments
parser = argparse.ArgumentParser(
    description="Script to run users for the Tower building experiment.")
parser.add_argument(
    'path',
    help='path used for experiment, must contain pomdp.json and policy.json')
parser.add_argument('user', help='user id, used for storing times')

args = parser.parse_args(sys.argv[1:])


# Algorithm parameters
N_WARMUP = 20
ITERATIONS = 800
EXPLORATION = 50
RELATIVE_EXPLO = False  # In this case use smaller exploration
BELIEF_VALUES = False
N_PARTICLES = 200
HORIZON = 3

EXPORT_DEST = os.path.join(args.path, 'pomcp-{}.json'.format(args.user))
EXPORT_BELIEF_QUOTIENT = True

OBJECTS_RENAME = {'top': 'table_top', 'screws': 'screws_box', 'joints': 'brackets_box'}


class UnexpectedActionFailure(RuntimeError):

    def __init__(self, arm, action, msg):
        super(UnexpectedActionFailure, self).__init__(
            'Unexpected failure for "{}" on {} arm: {}'.format(action, arm, msg))


class POMCPController(BaseController):

    OBJECTS_LEFT = "action_provider/objects_left"
    OBJECTS_RIGHT = "action_provider/objects_right"

    BRING = 'get_pass'
    CLEAR = 'cleanup'
    HOLD_LEG = 'hold_leg'
    HOLD_TOP = 'hold_top'
    HOLD = 'hold_leg'

    def __init__(self, policy, *args, **kargs):
        super(POMCPController, self).__init__(*args, **kargs)
        self.objects_left = self._parse_objects(rospy.get_param(self.OBJECTS_LEFT))
        self.objects_right = self._parse_objects(rospy.get_param(self.OBJECTS_RIGHT))
        print('Found {} on left and {} objects on right arm.'.format(
            list(self.objects_left), list(self.objects_right)))
        self.pol = policy
        self.model = self.pol.tree.model

    @staticmethod
    def _parse_objects(obj_dict):
        obj_parser = re.compile('(.*)_[0-9]+$')
        d = {}
        for o in obj_dict:
            m = obj_parser.match(o)
            if m is None:
                new_o = o
            else:
                new_o = m.group(1)
            if new_o not in d:
                d[new_o] = []
            d[new_o].append(obj_dict[o])
        return d

    def _run(self):
        self.timer.start()
        obs = None
        while not self.finished:
            b = self.pol.belief.array
            bq = self.model._int_to_state().belief_quotient(b)
            bp = self.model._int_to_state().belief_preferences(b)[0]
            # TODO: make this an action in the model
            if bq[-1] > .8:
                self.say("I believe we are done here.")
                rospy.loginfo("Assumes task is done: exiting....")
                self._stop()
            else:
                rospy.loginfo("Belief / HTM: {} and on preferences: "
                              "{:.2f}".format(format_belief_array(bq), bp))
                self.timer.log({
                  'history': self.pol.history,
                  'belief': list(b),
                  'belief quotient': list(bq),
                  'belief preference': list(bq),
                  })
                t = rospy.Time.now()
                a = self.pol.get_action()
                rospy.logdebug('Computed action during {}s'.format(
                    (rospy.Time.now() - t).to_sec()))
                rospy.loginfo("Action: %s", a)
                obs = self.take_action(a)
                rospy.loginfo("Observed: %s", obs)
                self.pol.step(obs)

    def _abort(self):
        self.pol.stop()
        super(POMCPController, self)._abort()

    def take_action(self, action):
        a = action.split()
        if a[0] == 'bring':
            return self.action_bring_or_clean(self.BRING, a[1])
        elif a[0] == 'clear':
            return self.action_bring_or_clean(self.CLEAR, a[1])
        elif a[0] == 'hold':
            return self.action_hold(a[1] if len(a) > 1 else '')
        elif a[0] == 'wait':
            return self.action_wait()
        elif a[0] == 'ask':
            return self.action_ask(a[1])
        else:
            raise ValueError('Unknown action: "{}".'.format(a))

    def action_bring_or_clean(self, a, obj):
        obj = OBJECTS_RENAME.get(obj, obj)  # Rename objects in the rename dict
        if obj in self.objects_left:
            # Note: always left if object reachable by both arms
            arm = self.action_left
            obj_ids = self.objects_left[obj]
            button_sub = self.left_button_sub
        elif obj in self.objects_right:
            arm = self.action_right
            obj_ids = self.objects_right[obj]
            button_sub = self.right_button_sub
        else:
            raise ValueError('Unknown object: %s' % obj)
        req = arm(a, obj_ids, wait=False)
        result = self.wait_for_request_returns_or_button_pressed(req, button_sub)
        if result is None or result.success:
            return self.model.observations[self.model.O_NONE]
        if result.success:
            return self.model.observations[self.model.O_NONE]  # This sounds stupid!
        elif result.response == DoActionResponse.NO_OBJ:
            return self.model.observations[self.model.O_NOT_FOUND]
        else:
            return self.model.observations[self.model.O_FAIL]

    def action_hold(self, mode=''):
        if mode.lower() == 'h':
            hold = self.HOLD_LEG
        elif mode.lower() == 'v':
            hold = self.HOLD_TOP
        else:
            hold = self.HOLD
        req = self.action_right(hold, [60, 180], wait=False)
        result = self.wait_for_request_returns_or_button_pressed(
            req, self.right_button_sub)
        if result is None: # We need to wait for two buttons
            rospy.logdebug('First button received')
            rospy.sleep(.5)
            result = self.wait_for_request_returns_or_button_pressed(
                req, self.right_button_sub)
        if result is None or result.success:
            return self.model.observations[self.model.O_NONE]
        else:
            return self.model.observations[self.model.O_FAIL]

    def action_wait(self):
        self.ask('Tell me when you are done.', context=['done', "I'm done", "finished"])
        togo = 8
        while togo > 0:
            ans = self.answer_sub.wait_for_msg() or ""
            if ans:
              rospy.loginfo("Got human message: '%s'", ans)
            if 'done' in ans or 'finish' in ans:
                togo = 0
                self.say('OK')
            togo -= 1
        return self.model.observations[self.model.O_NONE]

    def action_ask(self, topic):
        if topic != 'hold':
            raise ValueError("Don't know how to ask about '%s'." % topic)
        self.ask('Do you want me to hold?', context=['Yes', "No", "don't"])
        ans = self.answer_sub.wait_for_msg()
        ans = "" if ans is None else ans
        rospy.loginfo("Got human message: '%s'", ans)
        ans = ans.lower()
        if 'yes' in ans:
            return self.model.observations[self.model.O_YES]
        if 'no' in ans or "don't" in ans:
            return self.model.observations[self.model.O_NO]
        else:
            self.say("I didn't get what you meant.", sync=False)
            return self.model.observations[self.model.O_NONE]


# Problem definition
leg_i = 'leg-{}'.format
htm = SequentialCombination([
    SequentialCombination([
        LeafCombination(AssembleLeg(leg_i(i))),
        LeafCombination(AssembleLegToTop(leg_i(i), bring_top=(i == 0)))])
    for i in range(4)])

p = SupportivePOMDP(htm)
# TODO put as default
p.r_subtask = 0.
p.r_preference = 20.
p.cost_hold = 3.
p.cost_get = 20.
pol = AsyncPOMCPPolicyRunner(p, iterations=ITERATIONS,
                             horizon=NHTMHorizon.generator(p, n=HORIZON),
                             exploration=EXPLORATION,
                             relative_exploration=RELATIVE_EXPLO,
                             belief_values=BELIEF_VALUES,
                             belief='particle',
                             belief_params={'n_particles': N_PARTICLES})

# Warm up policy
best = None
maxl = 0
for i in range(N_WARMUP):
    s = 'Exploring... [{:2.0f}%] (current best: {} [{:.1f}])'.format(
        i * 100. / N_WARMUP, best, pol.tree.root.children[pol._last_action].value
        if pol._last_action is not None else 0.0)
    maxl = max(maxl, len(s))
    print(' ' * maxl, end='\r')
    print(s, end='\r')
    sys.stdout.flush()
    best = pol.get_action()  # Some exploration
print('Exploring... [done]')
if BELIEF_VALUES:
    print('Found {} distinct beliefs.'.format(len(pol.tree._obs_nodes)))

export_pomcp(pol, EXPORT_DEST, belief_as_quotient=EXPORT_BELIEF_QUOTIENT)
print('Saved: ' + EXPORT_DEST)

try:
    input("Press enter to start...")
except Exception:
    pass

timer_path = os.path.join(args.path, 'timer-{}.json'.format(args.user))
controller = POMCPController(pol, timer_path=timer_path, recovery=True)
controller.run()
pol.execute(export_pomcp, pol, EXPORT_DEST,
            belief_as_quotient=EXPORT_BELIEF_QUOTIENT)
