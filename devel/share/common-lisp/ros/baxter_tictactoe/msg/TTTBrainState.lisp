; Auto-generated. Do not edit!


(cl:in-package baxter_tictactoe-msg)


;//! \htmlinclude TTTBrainState.msg.html

(cl:defclass <TTTBrainState> (roslisp-msg-protocol:ros-message)
  ((state
    :reader state
    :initarg :state
    :type cl:fixnum
    :initform 0))
)

(cl:defclass TTTBrainState (<TTTBrainState>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <TTTBrainState>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'TTTBrainState)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name baxter_tictactoe-msg:<TTTBrainState> is deprecated: use baxter_tictactoe-msg:TTTBrainState instead.")))

(cl:ensure-generic-function 'state-val :lambda-list '(m))
(cl:defmethod state-val ((m <TTTBrainState>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader baxter_tictactoe-msg:state-val is deprecated.  Use baxter_tictactoe-msg:state instead.")
  (state m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<TTTBrainState>)))
    "Constants for message type '<TTTBrainState>"
  '((:INIT . 0)
    (:CALIB . 1)
    (:READY . 2)
    (:WAIT . 3)
    (:MATCH_STARTED . 4)
    (:GAME_STARTED . 5)
    (:GAME_RUNNING . 6)
    (:GAME_FINISHED . 7)
    (:MATCH_FINISHED . 8))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'TTTBrainState)))
    "Constants for message type 'TTTBrainState"
  '((:INIT . 0)
    (:CALIB . 1)
    (:READY . 2)
    (:WAIT . 3)
    (:MATCH_STARTED . 4)
    (:GAME_STARTED . 5)
    (:GAME_RUNNING . 6)
    (:GAME_FINISHED . 7)
    (:MATCH_FINISHED . 8))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <TTTBrainState>) ostream)
  "Serializes a message object of type '<TTTBrainState>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'state)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <TTTBrainState>) istream)
  "Deserializes a message object of type '<TTTBrainState>"
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'state)) (cl:read-byte istream))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<TTTBrainState>)))
  "Returns string type for a message object of type '<TTTBrainState>"
  "baxter_tictactoe/TTTBrainState")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'TTTBrainState)))
  "Returns string type for a message object of type 'TTTBrainState"
  "baxter_tictactoe/TTTBrainState")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<TTTBrainState>)))
  "Returns md5sum for a message object of type '<TTTBrainState>"
  "7b6cbd204bcff335fca2f7c7c16e4b71")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'TTTBrainState)))
  "Returns md5sum for a message object of type 'TTTBrainState"
  "7b6cbd204bcff335fca2f7c7c16e4b71")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<TTTBrainState>)))
  "Returns full string definition for message of type '<TTTBrainState>"
  (cl:format cl:nil "uint8 INIT=0~%uint8 CALIB=1~%uint8 READY=2~%uint8 WAIT=3~%uint8 MATCH_STARTED=4~%uint8 GAME_STARTED=5~%uint8 GAME_RUNNING=6~%uint8 GAME_FINISHED=7~%uint8 MATCH_FINISHED=8~%~%uint8 state~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'TTTBrainState)))
  "Returns full string definition for message of type 'TTTBrainState"
  (cl:format cl:nil "uint8 INIT=0~%uint8 CALIB=1~%uint8 READY=2~%uint8 WAIT=3~%uint8 MATCH_STARTED=4~%uint8 GAME_STARTED=5~%uint8 GAME_RUNNING=6~%uint8 GAME_FINISHED=7~%uint8 MATCH_FINISHED=8~%~%uint8 state~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <TTTBrainState>))
  (cl:+ 0
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <TTTBrainState>))
  "Converts a ROS message object to a list"
  (cl:list 'TTTBrainState
    (cl:cons ':state (state msg))
))
