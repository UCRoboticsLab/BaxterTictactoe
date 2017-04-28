; Auto-generated. Do not edit!


(cl:in-package baxter_tictactoe-msg)


;//! \htmlinclude MsgCell.msg.html

(cl:defclass <MsgCell> (roslisp-msg-protocol:ros-message)
  ((state
    :reader state
    :initarg :state
    :type cl:string
    :initform ""))
)

(cl:defclass MsgCell (<MsgCell>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <MsgCell>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'MsgCell)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name baxter_tictactoe-msg:<MsgCell> is deprecated: use baxter_tictactoe-msg:MsgCell instead.")))

(cl:ensure-generic-function 'state-val :lambda-list '(m))
(cl:defmethod state-val ((m <MsgCell>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader baxter_tictactoe-msg:state-val is deprecated.  Use baxter_tictactoe-msg:state instead.")
  (state m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<MsgCell>)))
    "Constants for message type '<MsgCell>"
  '((:EMPTY . empty)
    (:BLUE . blue)
    (:RED . red))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'MsgCell)))
    "Constants for message type 'MsgCell"
  '((:EMPTY . empty)
    (:BLUE . blue)
    (:RED . red))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <MsgCell>) ostream)
  "Serializes a message object of type '<MsgCell>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'state))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'state))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <MsgCell>) istream)
  "Deserializes a message object of type '<MsgCell>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'state) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'state) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<MsgCell>)))
  "Returns string type for a message object of type '<MsgCell>"
  "baxter_tictactoe/MsgCell")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'MsgCell)))
  "Returns string type for a message object of type 'MsgCell"
  "baxter_tictactoe/MsgCell")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<MsgCell>)))
  "Returns md5sum for a message object of type '<MsgCell>"
  "16e2b4ba8c56c6e7a216c122160a0bb8")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'MsgCell)))
  "Returns md5sum for a message object of type 'MsgCell"
  "16e2b4ba8c56c6e7a216c122160a0bb8")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<MsgCell>)))
  "Returns full string definition for message of type '<MsgCell>"
  (cl:format cl:nil "# Information from each cell in the board~%# Index of each cell in the array:~%#            _ _ _ _ _ _~%#           |_0_|_1_|_2_|~%#           |_3_|_4_|_5_|~%#           |_6_|_7_|_8_|~%#~%# Possible values:~%#       0=empty cell~%#       1=blue token (X)~%#       2=red token (O)~%~%string EMPTY=empty~%string BLUE=blue~%string RED=red~%~%string state~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'MsgCell)))
  "Returns full string definition for message of type 'MsgCell"
  (cl:format cl:nil "# Information from each cell in the board~%# Index of each cell in the array:~%#            _ _ _ _ _ _~%#           |_0_|_1_|_2_|~%#           |_3_|_4_|_5_|~%#           |_6_|_7_|_8_|~%#~%# Possible values:~%#       0=empty cell~%#       1=blue token (X)~%#       2=red token (O)~%~%string EMPTY=empty~%string BLUE=blue~%string RED=red~%~%string state~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <MsgCell>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'state))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <MsgCell>))
  "Converts a ROS message object to a list"
  (cl:list 'MsgCell
    (cl:cons ':state (state msg))
))
