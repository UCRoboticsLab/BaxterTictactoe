
(cl:in-package :asdf)

(defsystem "baxter_collaboration_msgs-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "DoAction" :depends-on ("_package_DoAction"))
    (:file "_package_DoAction" :depends-on ("_package"))
    (:file "AskFeedback" :depends-on ("_package_AskFeedback"))
    (:file "_package_AskFeedback" :depends-on ("_package"))
  ))