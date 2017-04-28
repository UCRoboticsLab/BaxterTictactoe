; Auto-generated. Do not edit!


(cl:in-package baxter_tictactoe-msg)


;//! \htmlinclude MsgBoard.msg.html

(cl:defclass <MsgBoard> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (cells
    :reader cells
    :initarg :cells
    :type (cl:vector baxter_tictactoe-msg:MsgCell)
   :initform (cl:make-array 9 :element-type 'baxter_tictactoe-msg:MsgCell :initial-element (cl:make-instance 'baxter_tictactoe-msg:MsgCell))))
)

(cl:defclass MsgBoard (<MsgBoard>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <MsgBoard>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'MsgBoard)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name baxter_tictactoe-msg:<MsgBoard> is deprecated: use baxter_tictactoe-msg:MsgBoard instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <MsgBoard>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader baxter_tictactoe-msg:header-val is deprecated.  Use baxter_tictactoe-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'cells-val :lambda-list '(m))
(cl:defmethod cells-val ((m <MsgBoard>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader baxter_tictactoe-msg:cells-val is deprecated.  Use baxter_tictactoe-msg:cells instead.")
  (cells m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <MsgBoard>) ostream)
  "Serializes a message object of type '<MsgBoard>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'cells))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <MsgBoard>) istream)
  "Deserializes a message object of type '<MsgBoard>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (cl:setf (cl:slot-value msg 'cells) (cl:make-array 9))
  (cl:let ((vals (cl:slot-value msg 'cells)))
    (cl:dotimes (i 9)
    (cl:setf (cl:aref vals i) (cl:make-instance 'baxter_tictactoe-msg:MsgCell))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<MsgBoard>)))
  "Returns string type for a message object of type '<MsgBoard>"
  "baxter_tictactoe/MsgBoard")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'MsgBoard)))
  "Returns string type for a message object of type 'MsgBoard"
  "baxter_tictactoe/MsgBoard")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<MsgBoard>)))
  "Returns md5sum for a message object of type '<MsgBoard>"
  "645f8ed617827125a30622a0a80414b8")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'MsgBoard)))
  "Returns md5sum for a message object of type 'MsgBoard"
  "645f8ed617827125a30622a0a80414b8")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<MsgBoard>)))
  "Returns full string definition for message of type '<MsgBoard>"
  (cl:format cl:nil "Header header~%baxter_tictactoe/MsgCell[9] cells~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: baxter_tictactoe/MsgCell~%# Information from each cell in the board~%# Index of each cell in the array:~%#            _ _ _ _ _ _~%#           |_0_|_1_|_2_|~%#           |_3_|_4_|_5_|~%#           |_6_|_7_|_8_|~%#~%# Possible values:~%#       0=empty cell~%#       1=blue token (X)~%#       2=red token (O)~%~%string EMPTY=empty~%string BLUE=blue~%string RED=red~%~%string state~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'MsgBoard)))
  "Returns full string definition for message of type 'MsgBoard"
  (cl:format cl:nil "Header header~%baxter_tictactoe/MsgCell[9] cells~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%# 0: no frame~%# 1: global frame~%string frame_id~%~%================================================================================~%MSG: baxter_tictactoe/MsgCell~%# Information from each cell in the board~%# Index of each cell in the array:~%#            _ _ _ _ _ _~%#           |_0_|_1_|_2_|~%#           |_3_|_4_|_5_|~%#           |_6_|_7_|_8_|~%#~%# Possible values:~%#       0=empty cell~%#       1=blue token (X)~%#       2=red token (O)~%~%string EMPTY=empty~%string BLUE=blue~%string RED=red~%~%string state~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <MsgBoard>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'cells) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <MsgBoard>))
  "Converts a ROS message object to a list"
  (cl:list 'MsgBoard
    (cl:cons ':header (header msg))
    (cl:cons ':cells (cells msg))
))
