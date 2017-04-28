
(cl:in-package :asdf)

(defsystem "baxter_tictactoe-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :std_msgs-msg
)
  :components ((:file "_package")
    (:file "MsgBoard" :depends-on ("_package_MsgBoard"))
    (:file "_package_MsgBoard" :depends-on ("_package"))
    (:file "TTTBrainState" :depends-on ("_package_TTTBrainState"))
    (:file "_package_TTTBrainState" :depends-on ("_package"))
    (:file "MsgCell" :depends-on ("_package_MsgCell"))
    (:file "_package_MsgCell" :depends-on ("_package"))
  ))