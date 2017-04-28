; Auto-generated. Do not edit!


(cl:in-package svox_tts-srv)


;//! \htmlinclude Speech-request.msg.html

(cl:defclass <Speech-request> (roslisp-msg-protocol:ros-message)
  ((mode
    :reader mode
    :initarg :mode
    :type cl:integer
    :initform 0)
   (string
    :reader string
    :initarg :string
    :type cl:string
    :initform "")
   (value
    :reader value
    :initarg :value
    :type cl:integer
    :initform 0))
)

(cl:defclass Speech-request (<Speech-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Speech-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Speech-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name svox_tts-srv:<Speech-request> is deprecated: use svox_tts-srv:Speech-request instead.")))

(cl:ensure-generic-function 'mode-val :lambda-list '(m))
(cl:defmethod mode-val ((m <Speech-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader svox_tts-srv:mode-val is deprecated.  Use svox_tts-srv:mode instead.")
  (mode m))

(cl:ensure-generic-function 'string-val :lambda-list '(m))
(cl:defmethod string-val ((m <Speech-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader svox_tts-srv:string-val is deprecated.  Use svox_tts-srv:string instead.")
  (string m))

(cl:ensure-generic-function 'value-val :lambda-list '(m))
(cl:defmethod value-val ((m <Speech-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader svox_tts-srv:value-val is deprecated.  Use svox_tts-srv:value instead.")
  (value m))
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql '<Speech-request>)))
    "Constants for message type '<Speech-request>"
  '((:SET_LANGUAGE . 1)
    (:GET_LANGUAGE . 11)
    (:SET_SPEED . 2)
    (:GET_SPEED . 22)
    (:SET_PITCH . 3)
    (:GET_PITCH . 33)
    (:GET_SUPPORTED_LANG . 4)
    (:SAY . 5)
    (:RESET . 6))
)
(cl:defmethod roslisp-msg-protocol:symbol-codes ((msg-type (cl:eql 'Speech-request)))
    "Constants for message type 'Speech-request"
  '((:SET_LANGUAGE . 1)
    (:GET_LANGUAGE . 11)
    (:SET_SPEED . 2)
    (:GET_SPEED . 22)
    (:SET_PITCH . 3)
    (:GET_PITCH . 33)
    (:GET_SUPPORTED_LANG . 4)
    (:SAY . 5)
    (:RESET . 6))
)
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Speech-request>) ostream)
  "Serializes a message object of type '<Speech-request>"
  (cl:let* ((signed (cl:slot-value msg 'mode)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'string))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'string))
  (cl:let* ((signed (cl:slot-value msg 'value)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Speech-request>) istream)
  "Deserializes a message object of type '<Speech-request>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'mode) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'string) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'string) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'value) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Speech-request>)))
  "Returns string type for a service object of type '<Speech-request>"
  "svox_tts/SpeechRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Speech-request)))
  "Returns string type for a service object of type 'Speech-request"
  "svox_tts/SpeechRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Speech-request>)))
  "Returns md5sum for a message object of type '<Speech-request>"
  "9c3f446da6b1955451e6967a08f80cbd")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Speech-request)))
  "Returns md5sum for a message object of type 'Speech-request"
  "9c3f446da6b1955451e6967a08f80cbd")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Speech-request>)))
  "Returns full string definition for message of type '<Speech-request>"
  (cl:format cl:nil "int32   mode~%string  string~%int32   value~%~%int32 SET_LANGUAGE=1~%int32 GET_LANGUAGE=11~%int32 SET_SPEED=2~%int32 GET_SPEED=22~%int32 SET_PITCH=3~%int32 GET_PITCH=33~%int32 GET_SUPPORTED_LANG=4~%int32 SAY=5~%int32 RESET=6~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Speech-request)))
  "Returns full string definition for message of type 'Speech-request"
  (cl:format cl:nil "int32   mode~%string  string~%int32   value~%~%int32 SET_LANGUAGE=1~%int32 GET_LANGUAGE=11~%int32 SET_SPEED=2~%int32 GET_SPEED=22~%int32 SET_PITCH=3~%int32 GET_PITCH=33~%int32 GET_SUPPORTED_LANG=4~%int32 SAY=5~%int32 RESET=6~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Speech-request>))
  (cl:+ 0
     4
     4 (cl:length (cl:slot-value msg 'string))
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Speech-request>))
  "Converts a ROS message object to a list"
  (cl:list 'Speech-request
    (cl:cons ':mode (mode msg))
    (cl:cons ':string (string msg))
    (cl:cons ':value (value msg))
))
;//! \htmlinclude Speech-response.msg.html

(cl:defclass <Speech-response> (roslisp-msg-protocol:ros-message)
  ((success
    :reader success
    :initarg :success
    :type cl:boolean
    :initform cl:nil)
   (response
    :reader response
    :initarg :response
    :type cl:string
    :initform "")
   (value
    :reader value
    :initarg :value
    :type cl:integer
    :initform 0))
)

(cl:defclass Speech-response (<Speech-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Speech-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Speech-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name svox_tts-srv:<Speech-response> is deprecated: use svox_tts-srv:Speech-response instead.")))

(cl:ensure-generic-function 'success-val :lambda-list '(m))
(cl:defmethod success-val ((m <Speech-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader svox_tts-srv:success-val is deprecated.  Use svox_tts-srv:success instead.")
  (success m))

(cl:ensure-generic-function 'response-val :lambda-list '(m))
(cl:defmethod response-val ((m <Speech-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader svox_tts-srv:response-val is deprecated.  Use svox_tts-srv:response instead.")
  (response m))

(cl:ensure-generic-function 'value-val :lambda-list '(m))
(cl:defmethod value-val ((m <Speech-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader svox_tts-srv:value-val is deprecated.  Use svox_tts-srv:value instead.")
  (value m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Speech-response>) ostream)
  "Serializes a message object of type '<Speech-response>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'success) 1 0)) ostream)
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'response))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'response))
  (cl:let* ((signed (cl:slot-value msg 'value)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Speech-response>) istream)
  "Deserializes a message object of type '<Speech-response>"
    (cl:setf (cl:slot-value msg 'success) (cl:not (cl:zerop (cl:read-byte istream))))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'response) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'response) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'value) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Speech-response>)))
  "Returns string type for a service object of type '<Speech-response>"
  "svox_tts/SpeechResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Speech-response)))
  "Returns string type for a service object of type 'Speech-response"
  "svox_tts/SpeechResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Speech-response>)))
  "Returns md5sum for a message object of type '<Speech-response>"
  "9c3f446da6b1955451e6967a08f80cbd")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Speech-response)))
  "Returns md5sum for a message object of type 'Speech-response"
  "9c3f446da6b1955451e6967a08f80cbd")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Speech-response>)))
  "Returns full string definition for message of type '<Speech-response>"
  (cl:format cl:nil "bool   success~%string response~%int32  value~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Speech-response)))
  "Returns full string definition for message of type 'Speech-response"
  (cl:format cl:nil "bool   success~%string response~%int32  value~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Speech-response>))
  (cl:+ 0
     1
     4 (cl:length (cl:slot-value msg 'response))
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Speech-response>))
  "Converts a ROS message object to a list"
  (cl:list 'Speech-response
    (cl:cons ':success (success msg))
    (cl:cons ':response (response msg))
    (cl:cons ':value (value msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'Speech)))
  'Speech-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'Speech)))
  'Speech-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Speech)))
  "Returns string type for a service object of type '<Speech>"
  "svox_tts/Speech")