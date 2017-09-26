#!/usr/bin/env python

"""
A GUI to help user take snapshot with hand camera

  
"""
import rospy
import struct
import Tkinter as tk
import tkFileDialog, tkMessageBox
import tkSimpleDialog
from baxter_interface.camera import CameraController 
from PIL import Image
from PIL import ImageTk, ImageDraw
import numpy as np
from PIL._imaging import outline
import glob
import os
from reportlab.platypus.flowables import ImageAndFlowables
import subprocess
import Queue
from sensor_msgs.msg import Image as ImageMsg
import threading
from cv_bridge import CvBridge, CvBridgeError
from Tkconstants import RIDGE
import copy

from geometry_msgs.msg import (
    PoseStamped,
    Pose,
    Point,
    Quaternion,
)

from baxter_core_msgs.srv import (
    SolvePositionIK,
    SolvePositionIKRequest,
)

from geometry_msgs.msg._PoseStamped import PoseStamped
from std_msgs.msg import Header

from baxter_interface import Limb



    
    


class StatusBar(tk.Frame):
    def __init__(self, master):
        tk.Frame.__init__(self, master)
        self.label = tk.Label(self, bd=1, relief=tk.SUNKEN, anchor=tk.W)
        self.label.pack(fill="x", anchor="w")
        self.prompt1 = " Saving snapshot files to: "
        self.prompt2 = "\n Saving snapeshot file as: " 
        self.update()
        
    def update(self):
        global path, prefix
        self.label.config(text=self.prompt1 + path + self.prompt2 + prefix + "_xx", justify="left")
        self.label.update_idletasks()

    def clear(self):
        self.label.config(text="")
        self.label.update_idletasks()
        
        
class MainWin(object):
    """
    represent the main window of the application
    """
    global path, prefix
    
    def __init__(self, parent):
        self.camera = Cam()
        self.bridge = CvBridge() # the open cv bridge
        self.animation_node = None # no animation server at beginning
        self.max_screen_res = (1024, 600)
        #============================== frames =========================================
        self.frameA = tk.Frame(parent, highlightbackground="green", highlightcolor="green", highlightthickness=2)
        self.frameA.pack(anchor=tk.W, padx = 10, pady = 10)
        
        self.frameB = tk.Frame(parent)
        self.frameB.pack(side=tk.BOTTOM, padx = 10, pady = 10)
        
        self.stbar =  StatusBar(parent)
        self.stbar.pack(side="bottom", fill='x')
        #============================= panels ==========================================
        self.res_mode = 2
        data = np.zeros((400, 640, 3), dtype=np.uint8) 
        #data = np.zeros(self.camera.cam_proxy.resolution + (3,), dtype=np.uint8) 
        self.imageA = Image.fromarray(data, 'RGB')
        self.imageATk = ImageTk.PhotoImage(self.imageA)
        self.panelA = tk.Label(self.frameA, image=self.imageATk, relief=RIDGE, borderwidth = 3)
        self.panelA.pack(side=tk.LEFT, padx = 10, pady = 10)
        
        
        self.imageB = Image.fromarray(data, 'RGB')
        self.draw_box()
        self.imageB_cv = np.array(self.imageB)
        self.imageBTk = ImageTk.PhotoImage(self.imageB)
        self.panelB = tk.Label(self.frameA, image=self.imageBTk, relief=RIDGE, borderwidth = 3)
        self.panelB.pack(side=tk.LEFT, padx = 10, pady = 10)
        
        #============================= Buttons =====================================
        
        path_btn = tk.Button(self.frameB, text="Select a path", command=self.select_path, width=20)
        path_btn.grid(row=0, column=0,padx=10, pady=10)
        
        prefix_btn = tk.Button(self.frameB, text="Select a prefix", command=self.select_prefix, width=20)
        prefix_btn.grid(row=1, column=0,padx=10, pady=10)
        
        moveArm_btn = tk.Button(self.frameB, text="Move arm to position", command=self.move_arm, width=20)
        moveArm_btn.grid(row=0, column=1,padx=10, pady=10)
        
        snapshot_btn = tk.Button(self.frameB, text="Snapshot", command=self.snapshot, width=20)
        snapshot_btn.grid(row=1, column=1,padx=10, pady=10)
        
        restart_btn = tk.Button(self.frameB, text="Restart anime", command=self.restart_node, width=20)
        restart_btn.grid(row=1, column=2,padx=10, pady=10)
        
        up_btn = tk.Button(self.frameB, text="up", command=self.snapshot, width=3)
        up_btn.grid(row=0, column=5,padx=10, pady=10)
        
        down_btn = tk.Button(self.frameB, text="down", command=self.snapshot, width=3)
        down_btn.grid(row=1, column=5,padx=10, pady=10)
        
    def draw_box(self):
        # calculate bounding box pixel size in window display
        rect_w, rect_h = tuple(n * pow(0.75, 2) for n in self.max_screen_res)
        ori_x = (640 - rect_w)//2 
        ori_y = (400 - rect_h)//2
        
        draw = ImageDraw.Draw(self.imageB)
        draw.rectangle( ((ori_x, ori_y), (ori_x + rect_w, ori_y + rect_h)), outline="red")
    
    def snapshot(self):
        '''
        take snapshot and save file
        '''
        #save to files
        self.save_file()
        
        #update panelA with captured image
        self.imageATk = ImageTk.PhotoImage(self.imageB)
        self.panelA.config(image=self.imageATk)
        
    def get_joint_position(self, limb, des_pose):
        '''
        return a list of joint rotation angles
        :param limb: left or right
        :param pose: a list containing the desired Cartesian coordinates + Quaternion
        '''
        ns = "ExternalTools/" + limb + "/PositionKinematicsNode/IKService"
        iksvc = rospy.ServiceProxy(ns, SolvePositionIK)
        ikreq = SolvePositionIKRequest()
        hdr = Header(stamp=rospy.Time.now(), frame_id='base')
        poseMsg = PoseStamped(
                header=hdr,
                pose=Pose(
                    position=Point(
                        x=des_pose[0],
                        y=des_pose[1],
                        z=des_pose[2],
                    ),
                    orientation=Quaternion(
                        x=des_pose[3],
                        y=des_pose[4],
                        z=des_pose[5],
                        w=des_pose[6],
                    ),
                )
            )
        
        ikreq.pose_stamp.append(poseMsg)
        try:
            rospy.wait_for_service(ns, 5.0)
            resp = iksvc(ikreq)
        except (rospy.ServiceException, rospy.ROSException), e:
            rospy.logerr("Service call failed: %s" % (e,))
            return None
    
        # Check if result valid, and type of seed ultimately used to get solution
        # convert rospy's string representation of uint8[]'s to int's
        resp_seeds = struct.unpack('<%dB' % len(resp.result_type),
                                   resp.result_type)
        if (resp_seeds[0] != resp.RESULT_INVALID):
            seed_str = {
                        ikreq.SEED_USER: 'User Provided Seed',
                        ikreq.SEED_CURRENT: 'Current Joint Angles',
                        ikreq.SEED_NS_MAP: 'Nullspace Setpoints',
                       }.get(resp_seeds[0], 'None')
            print("SUCCESS - Valid Joint Solution Found from Seed Type: %s" %
                  (seed_str,))
        else:
            print("INVALID POSE - No Valid Joint Solution Found.")
    
        return dict(zip(resp.joints[0].name, resp.joints[0].position))

    def move_arm(self):
        '''
        move baxter arm to position for snapshot
        '''
        global cam_pose, limb
        joint_angles = self.get_joint_position("left", cam_pose)
        if joint_angles is None:
            return 
        limb.move_to_joint_positions(joint_angles, timeout=5, threshold=0.0018)
        
        
    def select_path(self):
        global path, prefix
        path = tkFileDialog.askdirectory(parent=root, initialdir='.')
        print "get path" + str(path)
        self.stbar.update()
        
    def select_prefix(self):
        global path, prefix
        prefix = tkSimpleDialog.askstring(title="select a prefix", prompt="the saved file will look like " + prefix + "_xx")
        self.stbar.update()
    
    def save_file(self):
        '''
        save file to directory specified with prefix to file name. 
        The save file name would be like [prefix]_xx, where xx denotes serial number. 
        '''
        global path, prefix
        # find the pre-existing file with largest serial number
        last_sn = 0
        head = None
        tail = ".png" # save a .png file by default
        fullstr = path + '/' + prefix + '_[0-9]*.png'
        for fn in glob.glob(fullstr):
            full_name = os.path.split(fn)[1] 
            head, tail = os.path.splitext(full_name)
            sn = head.split('_')[1]
            if last_sn < int(sn): 
                last_sn = int(sn)
        
        new_fn = prefix + '_' + str(last_sn + 1).zfill(2) + tail
        new_full_fn = path + '/' + new_fn
        print "saved as" +  new_full_fn
        
        #crop and resize image for baxter head screen resolution 1024 x 600
        rect_w, rect_h = tuple(int(n * pow(0.75, self.res_mode)) for n in self.max_screen_res)
        ori_x = (self.camera.cam_proxy.resolution[0] - rect_w)//2
        ori_y = (self.camera.cam_proxy.resolution[1] - rect_h)//2 
        imageB_crop = self.imageB.crop((ori_x, ori_y, ori_x+rect_w, ori_y+rect_h)).resize(self.max_screen_res)
        #make a stamp
        draw = ImageDraw.Draw(imageB_crop)
        draw.text( (20, 20), new_fn, anchor='w')
        
        imageB_crop.save(new_full_fn)
        
    def restart_node(self):
        '''
        Update image path in animation node and restart
        This GUI uses the single express animation server
        '''
        global path
        if self.animation_node is not None:
            #kill the process 
            self.animation_node.kill()
        
        #create new animation node with current path
        self.animation_node = subprocess.Popen(["rosrun", "baxter_tictactoe", "animator_server.py", path], shell=False)
        
    def onClose(self):
        if tkMessageBox.askokcancel("Quit", "Do you really wish to quit? Animation server will be terminated"):
            
            if self.animation_node is not None and self.animation_node.poll() == None:
                # the process is still alive
                self.animation_node.terminate()
            
            # never close current camera
            root.destroy()

    def update_image(self):
        '''
        Check the image queue for incoming camera image.
        by default the camera runs at 25Hz, the GUI refreshing rate should be faster than that 
        '''
        global img_queue
        try: 
            msg = img_queue.get_nowait()
        except Queue.Empty:
            root.after(10, self.update_image)
            return
        
        try: 
            self.imageB_cv = self.bridge.imgmsg_to_cv2(msg, "rgb8")
        except CvBridgeError as e:
            print(e)
        
        self.imageB = Image.fromarray(self.imageB_cv)
        self.draw_box()
        self.imageBTk = ImageTk.PhotoImage(self.imageB)
        self.panelB.config(image=self.imageBTk)
        
        root.after(10, self.update_image)

class Cam(object):
    """
    represent the selected camera
    """
    def __init__(self):
        
        # close the unused camera to allow enough bandwidth
        # max 2 cameras allowed at any given time 
        # uncomment the following lines if can't find related camera service
        # CameraController("right_hand_camera").close()
        
        self.cam_proxy = CameraController("left_hand_camera")
        
        # default resolution is 640 x 400
        # MODES = [(1280, 800), (960, 600), (640, 400), (480, 300), (384, 240), (320, 200)]
        self.res_mode = 2
        self.cam_proxy.resolution=CameraController.MODES[self.res_mode]
        # open camera by default
        self.cam_proxy.open()
        
    def change_cam_to(self, id):
        if id == cam_proxy._id:
            # same camera, do nothing 
            return 
        if self.cam_proxy._open == True:
            # close camera in use
            self.cam_proxy.close()
        # create new camera controller
        self.com_proxy = CameraController(id)
        #open new camera
        self.com_proxy.open()
        
    def change_resolution(self, mode_id):
        if CameraController.MODES[mode_id] == self.cam_proxy.resolution:
            #nothing to do
            return 
        # update resolution and reopen camera
        self.cam_proxy.resolution(CameraController.MODES[mode_id])
    
    def close(self):
        self.cam_proxy.close()
    
    

def image_callback(data):
    global img_queue
    #feed in data to the FIFO queue
    img_queue.put_nowait(data)
    #print "image callback invoked"

def listening():
    '''
    The listener to the camera image topic. 
    '''
    #rospy.init_node('woz_listener', anonymous=True)
    sub = rospy.Subscriber("/cameras/left_hand_camera/image", ImageMsg, image_callback)
    rospy.spin()
    
path = os.path.dirname(os.path.abspath(__file__)) # the saving path for snapshots    
prefix = "img" # the prefix for saved files
img_queue = Queue.Queue() # the global queue used to pass on image to Tkinter

rospy.init_node('cam_gui', anonymous=True)
root = tk.Tk()
root.title("Camera GUI")
gui = MainWin(root)
root.protocol("WM_DELETE_WINDOW", gui.onClose)

#initlize limb interface
limb = Limb('left')
cam_pose = [0.548, 0.890, 0.095, 0, 1, 0, 0]

#start listener thread
lthread = threading.Thread(target=listening, args=[])
lthread.setDaemon(True)
lthread.start()

#schedule the frist update image event in mainloop
root.after(10, gui.update_image)

root.mainloop()











