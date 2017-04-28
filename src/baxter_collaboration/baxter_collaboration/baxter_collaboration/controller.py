import rospy

from .timer import Timer
from .service_request import ServiceRequest, finished_request
from .suscribers import CommunicationSuscriber, ButtonSuscriber
from baxter_collaboration_msgs.srv import DoAction, DoActionRequest
from svox_tts.srv import Speech, SpeechRequest


def fake_service_proxy(*args):
    return True


class BaseController(object):
    """Abstract interaction with robot's ROS nodes.

    Uses the following ressources:
    - service clients for left and right arm action providers,
    - service client for text to speech,
    - suscriber to communication topic,
    - suscriber to error topic.
    """

    NODE_NAME = "experiment_controller"

    COM_TOPIC = '/web_interface/pub'
    LISTEN_TOPIC = '/user_input'
    ERR_TOPIC = '/robot/digital_io/left_lower_button/state'
    LEFT_BUTTON = '/robot/digital_io/left_upper_button/state'
    RIGHT_BUTTON = '/robot/digital_io/right_upper_button/state'
    SPEECH_SERVICE = '/svox_tts/speech'
    ACTION_SERVICE_LEFT = '/action_provider/service_left'
    ACTION_SERVICE_RIGHT = '/action_provider/service_right'

    def __init__(self, timer_path=None, left=True, right=True, speech=True,
                 listen=True, recovery=False):
        self.finished = False
        # ROS stuff
        rospy.init_node(self.NODE_NAME, disable_signals=True)
        if left:  # Left arm action service client
            rospy.loginfo('Waiting for left service...')
            rospy.wait_for_service(self.ACTION_SERVICE_LEFT)
            self._action_left = rospy.ServiceProxy(self.ACTION_SERVICE_LEFT, DoAction)
        else:
            self._action_left = fake_service_proxy
        self._last_action_left_request = finished_request
        if right:  # Right arm action service client
            rospy.loginfo('Waiting for right service...')
            rospy.wait_for_service(self.ACTION_SERVICE_RIGHT)
            self._action_right = rospy.ServiceProxy(self.ACTION_SERVICE_RIGHT, DoAction)
        else:
            self._action_right = fake_service_proxy
        self._last_action_right_request = finished_request
        if speech:  # Text to speech client
            rospy.loginfo('Waiting for speech service...')
            rospy.wait_for_service(self.SPEECH_SERVICE)
            self.speech = rospy.ServiceProxy(self.SPEECH_SERVICE, Speech)
        self._last_say_req = finished_request
        # Suscriber to human answers
        if listen:
            self.answer_sub = CommunicationSuscriber(self.LISTEN_TOPIC, self._stop)
        else:
            self.answer_sub = CommunicationSuscriber(self.COM_TOPIC, self._stop)
        # Suscriber to errors
        self.error_sub = ButtonSuscriber(self.ERR_TOPIC, timeout=5)
        self.left_button_sub = ButtonSuscriber(self.LEFT_BUTTON, timeout=60)
        self.right_button_sub = ButtonSuscriber(self.RIGHT_BUTTON, timeout=60)
        # Set ROS parameter for recovery
        rospy.set_param('/action_provider/internal_recovery', recovery)
        # Timer to log events
        self.timer = Timer(path=timer_path)
        rospy.loginfo('Done.')
        self._home()  # Home position

    def _action(self, side, args, kwargs):
        wait = kwargs.pop('wait', True)
        if side == 0:
            self._last_action_left_request.wait_result()
            s = self._action_left
        else:
            self._last_action_right_request.wait_result()
            s = self._action_right
        r = ServiceRequest(s, *args)
        if side == 0:
            self._last_action_left_request = r
        else:
            self._last_action_right_request = r
        if wait:
            return r.wait_result()
        else:
            return r

    @staticmethod
    def wait_for_request_returns_or_button_pressed(req, button_sub):
        button_sub.start_listening()
        while (button_sub.listening and not req.finished):
            rospy.sleep(.1)
        if req.finished:
            return req.result
        else:
            return None

    def action_left(self, *args, **kwargs):
        return self._action(0, args, kwargs)

    def action_right(self, *args, **kwargs):
        return self._action(1, args, kwargs)

    def _home(self):
        rospy.loginfo('Going home before starting.')
        l = ServiceRequest(self.action_left, DoActionRequest.ACTION_HOME, [])
        r = ServiceRequest(self.action_right, DoActionRequest.ACTION_HOME, [])
        l.wait_result()
        r.wait_result()

    def say(self, sentence, sync=True):
        self._last_say_req.wait_result()
        self._last_say_req = ServiceRequest(
            self.speech, SpeechRequest.SAY, sentence, None)
        if sync:
            return self._last_say_req.wait_result()
        else:
            return self._last_say_req

    def _stop(self):
        if not self.finished:
            rospy.loginfo('Stopping policy controller')
            self.timer.log('Stop')
            rospy.loginfo(str(self.timer.data))
            self.timer.save()
        self._abort()

    def _abort(self):
        self.finished = True
        self._abort_waiting_suscribers()
        self._home()

    def _abort_waiting_suscribers(self):
        self.answer_sub.listening = False
        self.error_sub.listening = False

    def run(self):
        try:
            self._run()
        except (Exception, KeyboardInterrupt) as e:
            rospy.logerr(e)
            rospy.logerr('Exiting.')
            self._abort()
            raise

    def take_action(self, action):
        raise NotImplementedError

    def set_listen_context(self, context):
        rospy.get_param('/ros_speech2text/speech_context', context)

    def ask(self, question, context=None, timeout=None):
        if timeout is None:
            timeout = 15
        self.say(question, sync=False)
        if context is not None:
            self.set_listen_context(context)
        ans = self.answer_sub.wait_for_msg(timeout=timeout)
        rospy.loginfo("Got human answer: '%s'" % ans)
        return ans
