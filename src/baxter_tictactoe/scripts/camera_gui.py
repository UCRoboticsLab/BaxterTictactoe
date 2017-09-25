#!/usr/bin/env python

"""
A GUI to help user take snapshot with hand camera

  
"""

import Tkinter as tk
import tkFileDialog
import tkSimpleDialog
from baxter_interface.camera import CameraController 
from PIL import Image
from PIL import ImageTk, ImageDraw
import numpy as np
from PIL._imaging import outline


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
        #self.camera = Cam()
        #============================== frames =========================================
        self.frameA = tk.Frame(parent, highlightbackground="green", highlightcolor="green", highlightthickness=2)
        self.frameA.pack(anchor=tk.W, padx = 10, pady = 10)
        
        self.frameB = tk.Frame(parent)
        self.frameB.pack(side=tk.BOTTOM, padx = 10, pady = 10)
        
        self.stbar =  StatusBar(parent)
        self.stbar.pack(side="bottom", fill='x')
        #============================= panels ==========================================
        data = np.zeros((400, 640, 3), dtype=np.uint8) 
        #data = np.zeros(self.camera.cam_proxy.resolution + (3,), dtype=np.uint8) 
        self.imageA = Image.fromarray(data, 'RGB')
        self.imageA = ImageTk.PhotoImage(self.imageA)
        self.panelA = tk.Label(self.frameA, image=self.imageA)
        self.panelA.pack(side=tk.LEFT, padx = 10, pady = 10)
        
        self.imageB = Image.fromarray(data, 'RGB')
        draw = ImageDraw.Draw(self.imageB)
        draw.rectangle( ((30, 20), (550, 350)), outline="red")
        self.imageB = ImageTk.PhotoImage(self.imageB)
        self.panelB = tk.Label(self.frameA, image=self.imageB)
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
        
        up_btn = tk.Button(self.frameB, text="up", command=self.snapshot, width=3)
        up_btn.grid(row=0, column=5,padx=10, pady=10)
        
        down_btn = tk.Button(self.frameB, text="down", command=self.snapshot, width=3)
        down_btn.grid(row=1, column=5,padx=10, pady=10)
        
    def snapshot(self):
        pass
    
    def move_arm(self):
        pass
        
    def select_path(self):
        global path, prefix
        path = tkFileDialog.askdirectory(parent=root, initialdir='.')
        print "get path" + str(path)
        self.stbar.update()
        
    def select_prefix(self):
        global path, prefix
        prefix = tkSimpleDialog.askstring(title="select a prefix", prompt="the saved file will look like " + prefix + "_xx")
        self.stbar.update()

class Cam(object):
    """
    represent the selected camera
    """
    def __init__(self):
        self.cam_proxy = CameraController("left_hand_camera")
        # default resolution is 640 x 400
        self.cam_proxy.resolution(CameraController.MODES[2])
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
    
    



path = './' # the saving path for snapshots    
prefix = "img_" # the prefix for saved files
root = tk.Tk()
root.title("Camera GUI")
gui = MainWin(root)

root.mainloop()
