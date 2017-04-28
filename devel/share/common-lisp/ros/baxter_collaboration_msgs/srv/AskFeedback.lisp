; Auto-generated. Do not edit!


(cl:in-package baxter_collaboration_msgs-srv)


;//! \htmlinclude AskFeedback-request.msg.html

(cl:defclass <AskFeedback-request> (roslisp-msg-protocol:ros-message)
  ((ask
    :reader ask
    :initarg :ask
    :type cl:string
    :initform ""))
)

(cl:defclass AskFeedback-request (<AskFeedback-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <AskFeedback-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'AskFeedback-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name baxter_collaboration_msgs-srv:<AskFeedback-request> is deprecated: use baxter_collaboration_msgs-srv:AskFeedback-request instead.")))

(cl:ensure-generic-function 'ask-val :lambda-list '(m))
(cl:defmethod ask-val ((m <AskFeedback-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader baxter_collaboration_msgs-srv:ask-val is deprecated.  Use baxter_collaboration_msgs-srv:ask instead.")
  (ask m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <AskFeedback-request>) ostream)
  "Serializes a message object of type '<AskFeedback-request>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'ask))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'ask))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <AskFeedback-request>) istream)
  "Deserializes a message object of type '<AskFeedback-request>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'ask) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'ask) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<AskFeedback-request>)))
  "Returns string type for a service object of type '<AskFeedback-request>"
  "baxter_collaboration_msgs/AskFeedbackRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'AskFeedback-request)))
  "Returns string type for a service object of type 'AskFeedback-request"
  "baxter_collaboration_msgs/AskFeedbackRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<AskFeedback-request>)))
  "Returns md5sum for a message object of type '<AskFeedback-request>"
  "6ace658886065f0a99b6138e3cbeeb85")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'AskFeedback-request)))
  "Returns md5sum for a message object of type 'AskFeedback-request"
  "6ace658886065f0a99b6138e3cbeeb85")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<AskFeedback-request>)))
  "Returns full string definition for message of type '<AskFeedback-request>"
  (cl:format cl:nil "string ask~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'AskFeedback-request)))
  "Returns full string definition for message of type 'AskFeedback-request"
  (cl:format cl:nil "string ask~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <AskFeedback-request>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'ask))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <AskFeedback-request>))
  "Converts a ROS message object to a list"
  (cl:list 'AskFeedback-request
    (cl:cons ':ask (ask msg))
))
;//! \htmlinclude AskFeedback-response.msg.html

(cl:defclass <AskFeedback-response> (roslisp-msg-protocol:ros-message)
  ((success
    :reader success
    :initarg :success
    :type cl:boolean
    :initform cl:nil)
   (reply
    :reader reply
    :initarg :reply
    :type cl:string
    :initform ""))
)

(cl:defclass AskFeedback-response (<AskFeedback-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <AskFeedback-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'AskFeedback-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name baxter_collaboration_msgs-srv:<AskFeedback-response> is deprecated: use baxter_collaboration_msgs-srv:AskFeedback-response instead.")))

(cl:ensure-generic-function 'success-val :lambda-list '(m))
(cl:defmethod success-val ((m <AskFeedback-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader baxter_collaboration_msgs-srv:success-val is deprecated.  Use baxter_collaboration_msgs-srv:success instead.")
  (success m))

(cl:ensure-generic-function 'reply-val :lambda-list '(m))
(cl:defmethod reply-val ((m <AskFeedback-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader baxter_collaboration_msgs-srv:reply-val is deprecated.  Use baxter_collaboration_msgs-srv:reply instead.")
  (reply m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <AskFeedback-response>) ostream)
  "Serializes a message object of type '<AskFeedback-response>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'success) 1 0)) ostream)
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'reply))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'reply))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <AskFeedback-response>) istream)
  "Deserializes a message object of type '<AskFeedback-response>"
    (cl:setf (cl:slot-value msg 'success) (cl:not (cl:zerop (cl:read-byte istream))))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'reply) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'reply) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<AskFeedback-response>)))
  "Returns string type for a service object of type '<AskFeedback-response>"
  "baxter_collaboration_msgs/AskFeedbackResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'AskFeedback-response)))
  "Returns string type for a service object of type 'AskFeedback-response"
  "baxter_collaboration_msgs/AskFeedbackResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<AskFeedback-response>)))
  "Returns md5sum for a message object of type '<AskFeedback-response>"
  "6ace658886065f0a99b6138e3cbeeb85")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'AskFeedback-response)))
  "Returns md5sum for a message object of type 'AskFeedback-response"
  "6ace658886065f0a99b6138e3cbeeb85")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<AskFeedback-response>)))
  "Returns full string definition for message of type '<AskFeedback-response>"
  (cl:format cl:nil "bool   success~%string reply~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'AskFeedback-response)))
  "Returns full string definition for message of type 'AskFeedback-response"
  (cl:format cl:nil "bool   success~%string reply~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <AskFeedback-response>))
  (cl:+ 0
     1
     4 (cl:length (cl:slot-value msg 'reply))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <AskFeedback-response>))
  "Converts a ROS message object to a list"
  (cl:list 'AskFeedback-response
    (cl:cons ':success (success msg))
    (cl:cons ':reply (reply msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'AskFeedback)))
  'AskFeedback-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'AskFeedback)))
  'AskFeedback-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'AskFeedback)))
  "Returns string type for a service object of type '<AskFeedback>"
  "baxter_collaboration_msgs/AskFeedback")