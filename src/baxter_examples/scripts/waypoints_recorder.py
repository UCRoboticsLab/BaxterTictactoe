#!/usr/bin/env python

import argparse
import rospy
import baxter_interface

from baxter_interface import CHECK_VERSION
from baxter_examples.recorder import JointRecorder


class FileRecorder(JointRecorder):
    def __init__(self, filename):
        super(FileRecorder, self).__init__(filename, 1)
        self.f = open(self._filename, 'w')
        # Create Navigator I/O
        self._navigator_io = baxter_interface.Navigator("right")
        self._poll_rate = rospy.Rate(50)

    def start(self):
        if self._filename:
            joints_left = self._limb_left.joint_names()
            joints_right = self._limb_right.joint_names()
            self.f.write('time,')
            self.f.write(','.join([j for j in joints_left]) + ',')
            self.f.write('left_gripper,')
            self.f.write(','.join([j for j in joints_right]) + ',')
            self.f.write('right_gripper\n')

            # Connect Navigator I/O signals
            # Navigator scroll wheel button press
            self._navigator_io.button0_changed.connect(self.record)

        # polling shutdown signal and control gripper 50 times per second
        while not rospy.is_shutdown():
            # Look for gripper button presses
            if self._io_left_lower.state:
                self._gripper_left.open()
            elif self._io_left_upper.state:
                self._gripper_left.close()
            if self._io_right_lower.state:
                self._gripper_right.open()
            elif self._io_right_upper.state:
                self._gripper_right.close()

            self._poll_rate.sleep()

    def stop(self):
        self.f.close()

        # We are now done with the shutdown signals, disconnecting button
        self._navigator_io.button0_changed.disconnect(self.record)

        super(FileRecorder, self).stop()

        print("\nDone.")

    def record(self):
        # get joint name list
        joints_left = self._limb_left.joint_names()
        joints_right = self._limb_right.joint_names()

        # get joint angle value list
        angles_left = [self._limb_left.joint_angle(j)
                       for j in joints_left]
        angles_right = [self._limb_right.joint_angle(j)
                        for j in joints_right]

        # write time, left, and right angle values followed by gripper state
        self.f.write("%f," % (self._time_stamp(),))

        self.f.write(','.join([str(x) for x in angles_left]) + ',')
        self.f.write(str(self._gripper_left.position()) + ',')

        self.f.write(','.join([str(x) for x in angles_right]) + ',')
        self.f.write(str(self._gripper_right.position()) + '\n')

        print("record added for both arms ")


def main():
    """ Record and write joint states to a text file when OK button is pressed """
    arg_fmt = argparse.RawDescriptionHelpFormatter
    parser = argparse.ArgumentParser(formatter_class=arg_fmt,
                                     description=main.__doc__)
    required = parser.add_argument_group('required arguments')
    required.add_argument(
        '-f', '--file', dest='filename', required=True,
        help='the file name to record to'
    )
    parser.add_argument(
        '-r', '--record-rate', type=int, default=100, metavar='RECORDRATE',
        help='rate at which to record (default: 100)'
    )
    args = parser.parse_args(rospy.myargv()[1:])

    print("Initializing node... ")
    rospy.init_node("waypoint_file_recorder")
    print("Getting robot state... ")
    rs = baxter_interface.RobotEnable(CHECK_VERSION)
    print("Enabling robot... ")
    rs.enable()

    print("Creating recorder...")
    rec = FileRecorder(args.filename)
    # Register clean shutdown
    rospy.on_shutdown(rec.stop)

    print("Press Navigator 'OK/Wheel' button on the right arm to record a new joint way point")
    print("Press Ctrl-C to stop recording.")
    rec.start()



if __name__ == '__main__':
    main()