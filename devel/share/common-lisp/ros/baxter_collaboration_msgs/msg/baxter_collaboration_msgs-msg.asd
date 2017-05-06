
(cl:in-package :asdf)

(defsystem "baxter_collaboration_msgs-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :geometry_msgs-msg
               :std_msgs-msg
)
  :components ((:file "_package")
    (:file "Object" :depends-on ("_package_Object"))
    (:file "_package_Object" :depends-on ("_package"))
    (:file "WOZ" :depends-on ("_package_WOZ"))
    (:file "_package_WOZ" :depends-on ("_package"))
    (:file "GoToPose" :depends-on ("_package_GoToPose"))
    (:file "_package_GoToPose" :depends-on ("_package"))
    (:file "ObjectsArray" :depends-on ("_package_ObjectsArray"))
    (:file "_package_ObjectsArray" :depends-on ("_package"))
    (:file "ArmState" :depends-on ("_package_ArmState"))
    (:file "_package_ArmState" :depends-on ("_package"))
  ))