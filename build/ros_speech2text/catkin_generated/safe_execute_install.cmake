execute_process(COMMAND "/home/baxterdev/scazLab2_ws/build/ros_speech2text/catkin_generated/python_distutils_install.sh" RESULT_VARIABLE res)

if(NOT res EQUAL 0)
  message(FATAL_ERROR "execute_process(/home/baxterdev/scazLab2_ws/build/ros_speech2text/catkin_generated/python_distutils_install.sh) returned error code ")
endif()
