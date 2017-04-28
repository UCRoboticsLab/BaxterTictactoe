# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "ros_speech2text: 1 messages, 0 services")

set(MSG_I_FLAGS "-Iros_speech2text:/home/baxterdev/scazLab2_ws/src/ros_speech2text/msg;-Istd_msgs:/opt/ros/indigo/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(genlisp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(ros_speech2text_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/ros_speech2text/msg/transcript.msg" NAME_WE)
add_custom_target(_ros_speech2text_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "ros_speech2text" "/home/baxterdev/scazLab2_ws/src/ros_speech2text/msg/transcript.msg" ""
)

#
#  langs = gencpp;genlisp;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(ros_speech2text
  "/home/baxterdev/scazLab2_ws/src/ros_speech2text/msg/transcript.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/ros_speech2text
)

### Generating Services

### Generating Module File
_generate_module_cpp(ros_speech2text
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/ros_speech2text
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(ros_speech2text_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(ros_speech2text_generate_messages ros_speech2text_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/ros_speech2text/msg/transcript.msg" NAME_WE)
add_dependencies(ros_speech2text_generate_messages_cpp _ros_speech2text_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(ros_speech2text_gencpp)
add_dependencies(ros_speech2text_gencpp ros_speech2text_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS ros_speech2text_generate_messages_cpp)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(ros_speech2text
  "/home/baxterdev/scazLab2_ws/src/ros_speech2text/msg/transcript.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/ros_speech2text
)

### Generating Services

### Generating Module File
_generate_module_lisp(ros_speech2text
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/ros_speech2text
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(ros_speech2text_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(ros_speech2text_generate_messages ros_speech2text_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/ros_speech2text/msg/transcript.msg" NAME_WE)
add_dependencies(ros_speech2text_generate_messages_lisp _ros_speech2text_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(ros_speech2text_genlisp)
add_dependencies(ros_speech2text_genlisp ros_speech2text_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS ros_speech2text_generate_messages_lisp)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(ros_speech2text
  "/home/baxterdev/scazLab2_ws/src/ros_speech2text/msg/transcript.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/ros_speech2text
)

### Generating Services

### Generating Module File
_generate_module_py(ros_speech2text
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/ros_speech2text
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(ros_speech2text_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(ros_speech2text_generate_messages ros_speech2text_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/ros_speech2text/msg/transcript.msg" NAME_WE)
add_dependencies(ros_speech2text_generate_messages_py _ros_speech2text_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(ros_speech2text_genpy)
add_dependencies(ros_speech2text_genpy ros_speech2text_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS ros_speech2text_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/ros_speech2text)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/ros_speech2text
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(ros_speech2text_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/ros_speech2text)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/ros_speech2text
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(ros_speech2text_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/ros_speech2text)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/ros_speech2text\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/ros_speech2text
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(ros_speech2text_generate_messages_py std_msgs_generate_messages_py)
endif()
