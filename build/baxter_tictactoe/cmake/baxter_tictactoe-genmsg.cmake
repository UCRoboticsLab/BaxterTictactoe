# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "baxter_tictactoe: 3 messages, 0 services")

set(MSG_I_FLAGS "-Ibaxter_tictactoe:/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg;-Ibaxter_core_msgs:/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg;-Igeometry_msgs:/opt/ros/indigo/share/geometry_msgs/cmake/../msg;-Istd_msgs:/opt/ros/indigo/share/std_msgs/cmake/../msg;-Isensor_msgs:/opt/ros/indigo/share/sensor_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(genlisp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(baxter_tictactoe_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/TTTBrainState.msg" NAME_WE)
add_custom_target(_baxter_tictactoe_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "baxter_tictactoe" "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/TTTBrainState.msg" ""
)

get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgBoard.msg" NAME_WE)
add_custom_target(_baxter_tictactoe_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "baxter_tictactoe" "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgBoard.msg" "baxter_tictactoe/MsgCell:std_msgs/Header"
)

get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgCell.msg" NAME_WE)
add_custom_target(_baxter_tictactoe_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "baxter_tictactoe" "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgCell.msg" ""
)

#
#  langs = gencpp;genlisp;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(baxter_tictactoe
  "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/TTTBrainState.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/baxter_tictactoe
)
_generate_msg_cpp(baxter_tictactoe
  "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgBoard.msg"
  "${MSG_I_FLAGS}"
  "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgCell.msg;/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/baxter_tictactoe
)
_generate_msg_cpp(baxter_tictactoe
  "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgCell.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/baxter_tictactoe
)

### Generating Services

### Generating Module File
_generate_module_cpp(baxter_tictactoe
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/baxter_tictactoe
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(baxter_tictactoe_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(baxter_tictactoe_generate_messages baxter_tictactoe_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/TTTBrainState.msg" NAME_WE)
add_dependencies(baxter_tictactoe_generate_messages_cpp _baxter_tictactoe_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgBoard.msg" NAME_WE)
add_dependencies(baxter_tictactoe_generate_messages_cpp _baxter_tictactoe_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgCell.msg" NAME_WE)
add_dependencies(baxter_tictactoe_generate_messages_cpp _baxter_tictactoe_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(baxter_tictactoe_gencpp)
add_dependencies(baxter_tictactoe_gencpp baxter_tictactoe_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS baxter_tictactoe_generate_messages_cpp)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(baxter_tictactoe
  "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/TTTBrainState.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/baxter_tictactoe
)
_generate_msg_lisp(baxter_tictactoe
  "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgBoard.msg"
  "${MSG_I_FLAGS}"
  "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgCell.msg;/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/baxter_tictactoe
)
_generate_msg_lisp(baxter_tictactoe
  "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgCell.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/baxter_tictactoe
)

### Generating Services

### Generating Module File
_generate_module_lisp(baxter_tictactoe
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/baxter_tictactoe
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(baxter_tictactoe_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(baxter_tictactoe_generate_messages baxter_tictactoe_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/TTTBrainState.msg" NAME_WE)
add_dependencies(baxter_tictactoe_generate_messages_lisp _baxter_tictactoe_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgBoard.msg" NAME_WE)
add_dependencies(baxter_tictactoe_generate_messages_lisp _baxter_tictactoe_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgCell.msg" NAME_WE)
add_dependencies(baxter_tictactoe_generate_messages_lisp _baxter_tictactoe_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(baxter_tictactoe_genlisp)
add_dependencies(baxter_tictactoe_genlisp baxter_tictactoe_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS baxter_tictactoe_generate_messages_lisp)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(baxter_tictactoe
  "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/TTTBrainState.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/baxter_tictactoe
)
_generate_msg_py(baxter_tictactoe
  "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgBoard.msg"
  "${MSG_I_FLAGS}"
  "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgCell.msg;/opt/ros/indigo/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/baxter_tictactoe
)
_generate_msg_py(baxter_tictactoe
  "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgCell.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/baxter_tictactoe
)

### Generating Services

### Generating Module File
_generate_module_py(baxter_tictactoe
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/baxter_tictactoe
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(baxter_tictactoe_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(baxter_tictactoe_generate_messages baxter_tictactoe_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/TTTBrainState.msg" NAME_WE)
add_dependencies(baxter_tictactoe_generate_messages_py _baxter_tictactoe_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgBoard.msg" NAME_WE)
add_dependencies(baxter_tictactoe_generate_messages_py _baxter_tictactoe_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/baxter_tictactoe/msg/MsgCell.msg" NAME_WE)
add_dependencies(baxter_tictactoe_generate_messages_py _baxter_tictactoe_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(baxter_tictactoe_genpy)
add_dependencies(baxter_tictactoe_genpy baxter_tictactoe_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS baxter_tictactoe_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/baxter_tictactoe)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/baxter_tictactoe
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET baxter_core_msgs_generate_messages_cpp)
  add_dependencies(baxter_tictactoe_generate_messages_cpp baxter_core_msgs_generate_messages_cpp)
endif()
if(TARGET geometry_msgs_generate_messages_cpp)
  add_dependencies(baxter_tictactoe_generate_messages_cpp geometry_msgs_generate_messages_cpp)
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(baxter_tictactoe_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/baxter_tictactoe)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/baxter_tictactoe
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET baxter_core_msgs_generate_messages_lisp)
  add_dependencies(baxter_tictactoe_generate_messages_lisp baxter_core_msgs_generate_messages_lisp)
endif()
if(TARGET geometry_msgs_generate_messages_lisp)
  add_dependencies(baxter_tictactoe_generate_messages_lisp geometry_msgs_generate_messages_lisp)
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(baxter_tictactoe_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/baxter_tictactoe)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/baxter_tictactoe\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/baxter_tictactoe
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET baxter_core_msgs_generate_messages_py)
  add_dependencies(baxter_tictactoe_generate_messages_py baxter_core_msgs_generate_messages_py)
endif()
if(TARGET geometry_msgs_generate_messages_py)
  add_dependencies(baxter_tictactoe_generate_messages_py geometry_msgs_generate_messages_py)
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(baxter_tictactoe_generate_messages_py std_msgs_generate_messages_py)
endif()
