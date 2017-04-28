# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "baxter_collaboration_msgs: 4 messages, 2 services")

set(MSG_I_FLAGS "-Ibaxter_collaboration_msgs:/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg;-Igeometry_msgs:/opt/ros/indigo/share/geometry_msgs/cmake/../msg;-Istd_msgs:/opt/ros/indigo/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(genlisp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(baxter_collaboration_msgs_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/srv/AskFeedback.srv" NAME_WE)
add_custom_target(_baxter_collaboration_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "baxter_collaboration_msgs" "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/srv/AskFeedback.srv" ""
)

get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/ArmState.msg" NAME_WE)
add_custom_target(_baxter_collaboration_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "baxter_collaboration_msgs" "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/ArmState.msg" ""
)

get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/Object.msg" NAME_WE)
add_custom_target(_baxter_collaboration_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "baxter_collaboration_msgs" "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/Object.msg" "geometry_msgs/Quaternion:geometry_msgs/Point:geometry_msgs/Pose"
)

get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/ObjectsArray.msg" NAME_WE)
add_custom_target(_baxter_collaboration_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "baxter_collaboration_msgs" "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/ObjectsArray.msg" "geometry_msgs/Point:baxter_collaboration_msgs/Object:geometry_msgs/Quaternion:std_msgs/Header:geometry_msgs/Pose"
)

get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/GoToPose.msg" NAME_WE)
add_custom_target(_baxter_collaboration_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "baxter_collaboration_msgs" "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/GoToPose.msg" "geometry_msgs/Point:geometry_msgs/Quaternion"
)

get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/srv/DoAction.srv" NAME_WE)
add_custom_target(_baxter_collaboration_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "baxter_collaboration_msgs" "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/srv/DoAction.srv" ""
)

#
#  langs = gencpp;genlisp;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/Object.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Pose.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/baxter_collaboration_msgs
)
_generate_msg_cpp(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/ObjectsArray.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Point.msg;/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/Object.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Pose.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/baxter_collaboration_msgs
)
_generate_msg_cpp(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/GoToPose.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Quaternion.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/baxter_collaboration_msgs
)
_generate_msg_cpp(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/ArmState.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/baxter_collaboration_msgs
)

### Generating Services
_generate_srv_cpp(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/srv/AskFeedback.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/baxter_collaboration_msgs
)
_generate_srv_cpp(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/srv/DoAction.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/baxter_collaboration_msgs
)

### Generating Module File
_generate_module_cpp(baxter_collaboration_msgs
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/baxter_collaboration_msgs
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(baxter_collaboration_msgs_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(baxter_collaboration_msgs_generate_messages baxter_collaboration_msgs_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/srv/AskFeedback.srv" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_cpp _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/ArmState.msg" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_cpp _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/Object.msg" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_cpp _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/ObjectsArray.msg" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_cpp _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/GoToPose.msg" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_cpp _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/srv/DoAction.srv" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_cpp _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(baxter_collaboration_msgs_gencpp)
add_dependencies(baxter_collaboration_msgs_gencpp baxter_collaboration_msgs_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS baxter_collaboration_msgs_generate_messages_cpp)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/Object.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Pose.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/baxter_collaboration_msgs
)
_generate_msg_lisp(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/ObjectsArray.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Point.msg;/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/Object.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Pose.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/baxter_collaboration_msgs
)
_generate_msg_lisp(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/GoToPose.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Quaternion.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/baxter_collaboration_msgs
)
_generate_msg_lisp(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/ArmState.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/baxter_collaboration_msgs
)

### Generating Services
_generate_srv_lisp(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/srv/AskFeedback.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/baxter_collaboration_msgs
)
_generate_srv_lisp(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/srv/DoAction.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/baxter_collaboration_msgs
)

### Generating Module File
_generate_module_lisp(baxter_collaboration_msgs
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/baxter_collaboration_msgs
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(baxter_collaboration_msgs_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(baxter_collaboration_msgs_generate_messages baxter_collaboration_msgs_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/srv/AskFeedback.srv" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_lisp _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/ArmState.msg" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_lisp _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/Object.msg" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_lisp _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/ObjectsArray.msg" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_lisp _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/GoToPose.msg" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_lisp _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/srv/DoAction.srv" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_lisp _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(baxter_collaboration_msgs_genlisp)
add_dependencies(baxter_collaboration_msgs_genlisp baxter_collaboration_msgs_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS baxter_collaboration_msgs_generate_messages_lisp)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/Object.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Pose.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/baxter_collaboration_msgs
)
_generate_msg_py(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/ObjectsArray.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Point.msg;/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/Object.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Pose.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/baxter_collaboration_msgs
)
_generate_msg_py(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/GoToPose.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Quaternion.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/baxter_collaboration_msgs
)
_generate_msg_py(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/ArmState.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/baxter_collaboration_msgs
)

### Generating Services
_generate_srv_py(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/srv/AskFeedback.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/baxter_collaboration_msgs
)
_generate_srv_py(baxter_collaboration_msgs
  "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/srv/DoAction.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/baxter_collaboration_msgs
)

### Generating Module File
_generate_module_py(baxter_collaboration_msgs
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/baxter_collaboration_msgs
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(baxter_collaboration_msgs_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(baxter_collaboration_msgs_generate_messages baxter_collaboration_msgs_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/srv/AskFeedback.srv" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_py _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/ArmState.msg" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_py _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/Object.msg" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_py _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/ObjectsArray.msg" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_py _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/msg/GoToPose.msg" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_py _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_collaboration/baxter_collaboration_msgs/srv/DoAction.srv" NAME_WE)
add_dependencies(baxter_collaboration_msgs_generate_messages_py _baxter_collaboration_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(baxter_collaboration_msgs_genpy)
add_dependencies(baxter_collaboration_msgs_genpy baxter_collaboration_msgs_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS baxter_collaboration_msgs_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/baxter_collaboration_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/baxter_collaboration_msgs
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET geometry_msgs_generate_messages_cpp)
  add_dependencies(baxter_collaboration_msgs_generate_messages_cpp geometry_msgs_generate_messages_cpp)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/baxter_collaboration_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/baxter_collaboration_msgs
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET geometry_msgs_generate_messages_lisp)
  add_dependencies(baxter_collaboration_msgs_generate_messages_lisp geometry_msgs_generate_messages_lisp)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/baxter_collaboration_msgs)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/baxter_collaboration_msgs\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/baxter_collaboration_msgs
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET geometry_msgs_generate_messages_py)
  add_dependencies(baxter_collaboration_msgs_generate_messages_py geometry_msgs_generate_messages_py)
endif()
