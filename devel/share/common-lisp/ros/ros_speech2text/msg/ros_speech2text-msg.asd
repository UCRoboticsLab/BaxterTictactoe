
(cl:in-package :asdf)

(defsystem "ros_speech2text-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "transcript" :depends-on ("_package_transcript"))
    (:file "_package_transcript" :depends-on ("_package"))
  ))