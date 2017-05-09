#!/usr/bin/env python
from Tkinter import *
import os
import sys
from libxml2 import thrDefDefaultBufferSize

import rospy
import Queue
import threading
#from listener import getState
from baxter_collaboration_msgs.msg import WOZ

root = Tk()

states = [0,0,0,0]

dance = StringVar()
wave = StringVar()
giggle = StringVar()
cheat = StringVar()

def setMessage(i):
    scores = []
    scores.extend(states)
    scores[i] = not scores[i]
    try:
        talker(scores[0],scores[1],scores[2],scores[3])
    except rospy.ROSInterruptException: pass

def callback(data):
    global root
    rospy.loginfo("dance: %d \n wave: %d \n giggle: %d \n cheat: %d" % (data.dance, data.wave, data.giggle, data.cheat))

    q.put_nowait(data)

'''The GUI update function '''
def update_gui():
    try:
        msg = q.get_nowait()
    except Queue.Empty:
        root.after(100, update_gui)
        return

    #update internal states
    states[0] = msg.dance
    states[1] = msg.wave
    states[2] = msg.giggle
    states[3] = msg.cheat

    #update GUI text
    if(msg.dance == 1):
        dance.set("Dance: Enabled")
    else:
        dance.set("Dance: Disabled")

    if (msg.wave == 1):
        wave.set("Wave: Enabled")
    else:
        wave.set("Wave: Disabled")

    if (msg.giggle == 1):
        giggle.set("Giggle: Enabled")
    else:
        giggle.set("Giggle: Disabled")

    if (msg.cheat == 1):
        cheat.set("Cheat: Enabled")
    else:
        cheat.set("Cheat: Disabled")

    # schedule the next run in 100 ms
    root.after(100, update_gui)


def talker(newDance,newWave,newGiggle,newCheat):
    
    msg = WOZ()
    
    msg.dance = newDance
    msg.wave = newWave
    msg.giggle = newGiggle
    msg.cheat = newCheat
    
    #rospy.loginfo(msg)
    pub.publish(msg)

def listening():
    #rospy.init_node('woz_listener', anonymous=True)
    sub = rospy.Subscriber("woz_st", WOZ, callback)
    rospy.spin()


def on_close():
    pub.unregister()
    rospy .signal_shutdown("Closing thread to prevent process being kept open")
    root.destroy()
    

if __name__ == '__main__':
    pros = []
    pub = None
    sub = None
    q = Queue.Queue()

    # Create and pack the buttons
    txt = ["Dance", "Wave", "Giggle", "Cheat"]
    val = [0,1,2,3]

    rb0=Button(root,
        text=txt[0],
        width = 20,
        padx = 20,
        command=lambda : setMessage(0)).pack(anchor=W)

    rb1=Button(root,
        text=txt[1],
        width = 20,
        padx = 20,
        command=lambda : setMessage(1)).pack(anchor=W)

    rb2=Button(root,
        text=txt[2],
        width = 20,
        padx = 20,
        command=lambda : setMessage(2)).pack(anchor=W)

    rb3=Button(root,
        text=txt[3],
        width = 20,
        padx = 20,
        command=lambda : setMessage(3)).pack(anchor=W)

    # Create and pack the labels
    Label(root, textvariable = dance).pack(anchor=W)
    Label(root, textvariable = wave).pack(anchor=W)
    Label(root, textvariable = giggle).pack(anchor=W)
    Label(root, textvariable = cheat).pack(anchor=W)

    # default settings
    dance.set("Dance: Disabled")
    wave.set("Wave: Disabled")
    giggle.set("Giggle: Disabled")
    cheat.set("Cheat: Disabled")

    #initialize the node
    rospy.init_node('woz_gui', anonymous=False)
    #create publisher on main thread
    pub = rospy.Publisher('woz_cmd', WOZ, queue_size=1)

    #Added subscriber on worker thread
    sub_t = threading.Thread(target=listening, args=[])
    sub_t.setDaemon(True)
    sub_t.start()

    # schedule the first run of loop function
    root.after(100, update_gui)
    # schedule the exit handler.
    root.protocol("WM_DELETE_WINDOW", on_close)
    root.mainloop()




