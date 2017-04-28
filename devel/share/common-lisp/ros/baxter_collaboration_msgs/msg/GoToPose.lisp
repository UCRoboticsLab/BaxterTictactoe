; Auto-generated. Do not edit!


(cl:in-package baxter_collaboration_msgs-msg)


;//! \htmlinclude GoToPose.msg.html

(cl:defclass <GoToPose> (roslisp-msg-protocol:ros-message)
  ((type
    :reader type
    :initarg :type
    :type cl:string
    :initform "")
   (ctrl_mode
    :reader ctrl_mode
    :initarg :ctrl_mode
    :type cl:integer
    :initform 0)
   (position
    :reader position
    :initarg :position
    :type geometry_msgs-msg:Point
    :initform (cl:make-instance 'geometry_msgs-msg:Point))
   (orientation
    :reader orientation
    :initarg :orientation
    :type geometry_msgs-msg:Quaternion
    :initform (cl:make-instance 'geometry_msgs-msg:Quaternion))
   (increment
    :reader increment
    :initarg :increment
    :type cl:float
    :initform 0.0))
)

(cl:defclass GoToPose (<GoToPose>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <GoToPose>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'GoToPose)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name baxter_collaboration_msgs-msg:<GoToPose> is deprecated: use baxter_collaboration_msgs-msg:GoToPose instead.")))

(cl:ensure-generic-function 'type-val :lambda-list '(m))
(cl:defmethod type-val ((m <GoToPose>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader baxter_collaboration_msgs-msg:type-val is deprecated.  Use baxter_collaboration_msgs-msg:type instead.")
  (type m))

(cl:ensure-generic-function 'ctrl_mode-val :lambda-list '(m))
(cl:defmethod ctrl_mode-val ((m <GoToPose>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader baxter_collaboration_msgs-msg:ctrl_mode-val is deprecated.  Use baxter_collaboration_msgs-msg:ctrl_mode instead.")
  (ctrl_mode m))

(cl:ensure-generic-function 'position-val :lambda-list '(m))
(cl:defmethod position-val ((m <GoToPose>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader baxter_collaboration_msgs-msg:position-val is deprecated.  Use baxter_collaboration_msgs-msg:position instead.")
  (position m))

(cl:ensure-generic-function 'orientation-val :lambda-list '(m))
(cl:defmethod orientation-val ((m <GoToPose>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader baxter_collaboration_msgs-msg:orientation-val is deprecated.  Use baxter_collaboration_msgs-msg:orientation instead.")
  (orientation m))

(cl:ensure-generic-function 'increment-val :lambda-list '(m))
(cl:defmethod increment-val ((m <GoToPose>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader baxter_collaboration_msgs-msg:increment-val is deprecated.  Use baxter_collaboration_msgs-msg:increment instead.")
  (increment m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<GoToPose>)))
    "Constants for message type '<GoToPose>"
  '((:POSITION_MODE . 1)
    (:VELOCITY_MODE . 2)
    (:RAW_POSITION_MODE . 4))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'GoToPose)))
    "Constants for message type 'GoToPose"
  '((:POSITION_MODE . 1)
    (:VELOCITY_MODE . 2)
    (:RAW_POSITION_MODE . 4))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <GoToPose>) ostream)
  "Serializes a message object of type '<GoToPose>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'type))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'type))
  (cl:let* ((signed (cl:slot-value msg 'ctrl_mode)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'position) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'orientation) ostream)
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'increment))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <GoToPose>) istream)
  "Deserializes a message object of type '<GoToPose>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'type) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'type) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'ctrl_mode) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'position) istream)
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'orientation) istream)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'increment) (roslisp-utils:decode-double-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<GoToPose>)))
  "Returns string type for a message object of type '<GoToPose>"
  "baxter_collaboration_msgs/GoToPose")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'GoToPose)))
  "Returns string type for a message object of type 'GoToPose"
  "baxter_collaboration_msgs/GoToPose")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<GoToPose>)))
  "Returns md5sum for a message object of type '<GoToPose>"
  "3ea4877a0729c590d3f811d62c09337d")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'GoToPose)))
  "Returns md5sum for a message object of type 'GoToPose"
  "3ea4877a0729c590d3f811d62c09337d")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<GoToPose>)))
  "Returns full string definition for message of type '<GoToPose>"
  (cl:format cl:nil "# Type of command to send. It can be one of the following:~%# pose        to request a 6D pose~%# position    to request a 3D position and keeping the current orientation~%# relative_x  to request an increment relative to the current pose in the x axis~%# relative_y  to request an increment relative to the current pose in the y axis~%# relative_z  to request an increment relative to the current pose in the z axis~%# stop        to stop the motion of the robot altogether (if it was moving)~%string type~%~%# Control mode to control the robot with. For now, only position mode is~%# allowed. In the near future, also velocity mode will be allowed, in order~%# to directly control the robot's joints in velocity.~%int32     POSITION_MODE = 1~%int32     VELOCITY_MODE = 2~%int32 RAW_POSITION_MODE = 4~%~%int32 ctrl_mode~%~%# \"POSE\" AND \"POSITION\" GOTOPOSE MESSAGE TYPE~%# Endpoint Pose to request Inverse-Kinematics joint solutions for.~%# If type is set to position, orientation is ignored and the end effector~%# will be moved to the desired position with the current orientation.~%geometry_msgs/Point      position~%geometry_msgs/Quaternion orientation~%~%# \"RELATIVE\" GOTOPOSE MESSAGE TYPE~%# increment is in meters, and will move the end effector in the desired~%# direction, specified by the type~%float64 increment~%~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'GoToPose)))
  "Returns full string definition for message of type 'GoToPose"
  (cl:format cl:nil "# Type of command to send. It can be one of the following:~%# pose        to request a 6D pose~%# position    to request a 3D position and keeping the current orientation~%# relative_x  to request an increment relative to the current pose in the x axis~%# relative_y  to request an increment relative to the current pose in the y axis~%# relative_z  to request an increment relative to the current pose in the z axis~%# stop        to stop the motion of the robot altogether (if it was moving)~%string type~%~%# Control mode to control the robot with. For now, only position mode is~%# allowed. In the near future, also velocity mode will be allowed, in order~%# to directly control the robot's joints in velocity.~%int32     POSITION_MODE = 1~%int32     VELOCITY_MODE = 2~%int32 RAW_POSITION_MODE = 4~%~%int32 ctrl_mode~%~%# \"POSE\" AND \"POSITION\" GOTOPOSE MESSAGE TYPE~%# Endpoint Pose to request Inverse-Kinematics joint solutions for.~%# If type is set to position, orientation is ignored and the end effector~%# will be moved to the desired position with the current orientation.~%geometry_msgs/Point      position~%geometry_msgs/Quaternion orientation~%~%# \"RELATIVE\" GOTOPOSE MESSAGE TYPE~%# increment is in meters, and will move the end effector in the desired~%# direction, specified by the type~%float64 increment~%~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <GoToPose>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'type))
     4
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'position))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'orientation))
     8
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <GoToPose>))
  "Converts a ROS message object to a list"
  (cl:list 'GoToPose
    (cl:cons ':type (type msg))
    (cl:cons ':ctrl_mode (ctrl_mode msg))
    (cl:cons ':position (position msg))
    (cl:cons ':orientation (orientation msg))
    (cl:cons ':increment (increment msg))
))
