
(cl:in-package :asdf)

(defsystem "svox_tts-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "Speech" :depends-on ("_package_Speech"))
    (:file "_package_Speech" :depends-on ("_package"))
  ))