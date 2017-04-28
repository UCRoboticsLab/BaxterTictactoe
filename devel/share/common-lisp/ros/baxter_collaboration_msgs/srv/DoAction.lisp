; Auto-generated. Do not edit!


(cl:in-package baxter_collaboration_msgs-srv)


;//! \htmlinclude DoAction-request.msg.html

(cl:defclass <DoAction-request> (roslisp-msg-protocol:ros-message)
  ((action
    :reader action
    :initarg :action
    :type cl:string
    :initform "")
   (objects
    :reader objects
    :initarg :objects
    :type (cl:vector cl:fixnum)
   :initform (cl:make-array 0 :element-type 'cl:fixnum :initial-element 0)))
)

(cl:defclass DoAction-request (<DoAction-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <DoAction-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'DoAction-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name baxter_collaboration_msgs-srv:<DoAction-request> is deprecated: use baxter_collaboration_msgs-srv:DoAction-request instead.")))

(cl:ensure-generic-function 'action-val :lambda-list '(m))
(cl:defmethod action-val ((m <DoAction-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader baxter_collaboration_msgs-srv:action-val is deprecated.  Use baxter_collaboration_msgs-srv:action instead.")
  (action m))

(cl:ensure-generic-function 'objects-val :lambda-list '(m))
(cl:defmethod objects-val ((m <DoAction-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader baxter_collaboration_msgs-srv:objects-val is deprecated.  Use baxter_collaboration_msgs-srv:objects instead.")
  (objects m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<DoAction-request>)))
    "Constants for message type '<DoAction-request>"
  '((:LIST_OBJECTS . list_objects)
    (:LIST_ACTIONS . list_actions)
    (:ACTION_HOME . home)
    (:ACTION_RELEASE . release))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'DoAction-request)))
    "Constants for message type 'DoAction-request"
  '((:LIST_OBJECTS . list_objects)
    (:LIST_ACTIONS . list_actions)
    (:ACTION_HOME . home)
    (:ACTION_RELEASE . release))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <DoAction-request>) ostream)
  "Serializes a message object of type '<DoAction-request>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'action))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'action))
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'objects))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let* ((signed ele) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 65536) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    ))
   (cl:slot-value msg 'objects))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <DoAction-request>) istream)
  "Deserializes a message object of type '<DoAction-request>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'action) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'action) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'objects) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'objects)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:aref vals i) (cl:if (cl:< unsigned 32768) unsigned (cl:- unsigned 65536)))))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<DoAction-request>)))
  "Returns string type for a service object of type '<DoAction-request>"
  "baxter_collaboration_msgs/DoActionRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'DoAction-request)))
  "Returns string type for a service object of type 'DoAction-request"
  "baxter_collaboration_msgs/DoActionRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<DoAction-request>)))
  "Returns md5sum for a message object of type '<DoAction-request>"
  "6201132af3b68a8b841f1803943e0d53")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'DoAction-request)))
  "Returns md5sum for a message object of type 'DoAction-request"
  "6201132af3b68a8b841f1803943e0d53")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<DoAction-request>)))
  "Returns full string definition for message of type '<DoAction-request>"
  (cl:format cl:nil "~%~%~%string LIST_OBJECTS     = list_objects~%string LIST_ACTIONS     = list_actions~%string ACTION_HOME      = home~%string ACTION_RELEASE   = release~%~%string action~%~%~%int16[] objects~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'DoAction-request)))
  "Returns full string definition for message of type 'DoAction-request"
  (cl:format cl:nil "~%~%~%string LIST_OBJECTS     = list_objects~%string LIST_ACTIONS     = list_actions~%string ACTION_HOME      = home~%string ACTION_RELEASE   = release~%~%string action~%~%~%int16[] objects~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <DoAction-request>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'action))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'objects) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 2)))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <DoAction-request>))
  "Converts a ROS message object to a list"
  (cl:list 'DoAction-request
    (cl:cons ':action (action msg))
    (cl:cons ':objects (objects msg))
))
;//! \htmlinclude DoAction-response.msg.html

(cl:defclass <DoAction-response> (roslisp-msg-protocol:ros-message)
  ((success
    :reader success
    :initarg :success
    :type cl:boolean
    :initform cl:nil)
   (response
    :reader response
    :initarg :response
    :type cl:string
    :initform ""))
)

(cl:defclass DoAction-response (<DoAction-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <DoAction-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'DoAction-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name baxter_collaboration_msgs-srv:<DoAction-response> is deprecated: use baxter_collaboration_msgs-srv:DoAction-response instead.")))

(cl:ensure-generic-function 'success-val :lambda-list '(m))
(cl:defmethod success-val ((m <DoAction-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader baxter_collaboration_msgs-srv:success-val is deprecated.  Use baxter_collaboration_msgs-srv:success instead.")
  (success m))

(cl:ensure-generic-function 'response-val :lambda-list '(m))
(cl:defmethod response-val ((m <DoAction-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader baxter_collaboration_msgs-srv:response-val is deprecated.  Use baxter_collaboration_msgs-srv:response instead.")
  (response m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<DoAction-response>)))
    "Constants for message type '<DoAction-response>"
  '((:NO_IR_SENSOR . No callback from the IR sensor)
    (:OBJ_NOT_IN_DB . Requested object not available in DB)
    (:NO_OBJ . No object detected)
    (:ACT_FAILED . Action failed from user input)
    (:ACT_NOT_IN_DB . Requested action not available in DB)
    (:ACT_NOT_IMPL . Action not implemented)
    (:INV_KIN_FAILED . Inverse Kinematics failed))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'DoAction-response)))
    "Constants for message type 'DoAction-response"
  '((:NO_IR_SENSOR . No callback from the IR sensor)
    (:OBJ_NOT_IN_DB . Requested object not available in DB)
    (:NO_OBJ . No object detected)
    (:ACT_FAILED . Action failed from user input)
    (:ACT_NOT_IN_DB . Requested action not available in DB)
    (:ACT_NOT_IMPL . Action not implemented)
    (:INV_KIN_FAILED . Inverse Kinematics failed))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <DoAction-response>) ostream)
  "Serializes a message object of type '<DoAction-response>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'success) 1 0)) ostream)
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'response))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'response))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <DoAction-response>) istream)
  "Deserializes a message object of type '<DoAction-response>"
    (cl:setf (cl:slot-value msg 'success) (cl:not (cl:zerop (cl:read-byte istream))))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'response) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'response) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<DoAction-response>)))
  "Returns string type for a service object of type '<DoAction-response>"
  "baxter_collaboration_msgs/DoActionResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'DoAction-response)))
  "Returns string type for a service object of type 'DoAction-response"
  "baxter_collaboration_msgs/DoActionResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<DoAction-response>)))
  "Returns md5sum for a message object of type '<DoAction-response>"
  "6201132af3b68a8b841f1803943e0d53")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'DoAction-response)))
  "Returns md5sum for a message object of type 'DoAction-response"
  "6201132af3b68a8b841f1803943e0d53")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<DoAction-response>)))
  "Returns full string definition for message of type '<DoAction-response>"
  (cl:format cl:nil "~%~%bool   success~%~%~%~%~%~%~%string NO_IR_SENSOR   = No callback from the IR sensor~%string OBJ_NOT_IN_DB  = Requested object not available in DB~%string NO_OBJ         = No object detected~%string ACT_FAILED     = Action failed from user input~%string ACT_NOT_IN_DB  = Requested action not available in DB~%string ACT_NOT_IMPL   = Action not implemented~%string INV_KIN_FAILED = Inverse Kinematics failed~%~%string response~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'DoAction-response)))
  "Returns full string definition for message of type 'DoAction-response"
  (cl:format cl:nil "~%~%bool   success~%~%~%~%~%~%~%string NO_IR_SENSOR   = No callback from the IR sensor~%string OBJ_NOT_IN_DB  = Requested object not available in DB~%string NO_OBJ         = No object detected~%string ACT_FAILED     = Action failed from user input~%string ACT_NOT_IN_DB  = Requested action not available in DB~%string ACT_NOT_IMPL   = Action not implemented~%string INV_KIN_FAILED = Inverse Kinematics failed~%~%string response~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <DoAction-response>))
  (cl:+ 0
     1
     4 (cl:length (cl:slot-value msg 'response))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <DoAction-response>))
  "Converts a ROS message object to a list"
  (cl:list 'DoAction-response
    (cl:cons ':success (success msg))
    (cl:cons ':response (response msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'DoAction)))
  'DoAction-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'DoAction)))
  'DoAction-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'DoAction)))
  "Returns string type for a service object of type '<DoAction>"
  "baxter_collaboration_msgs/DoAction")