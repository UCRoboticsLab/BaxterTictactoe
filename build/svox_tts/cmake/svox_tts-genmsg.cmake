# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "svox_tts: 0 messages, 1 services")

set(MSG_I_FLAGS "")

# Find all generators
find_package(gencpp REQUIRED)
find_package(genlisp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(svox_tts_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/svox_tts/srv/Speech.srv" NAME_WE)
add_custom_target(_svox_tts_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "svox_tts" "/home/baxterdev/scazLab2_ws/src/svox_tts/srv/Speech.srv" ""
)

#
#  langs = gencpp;genlisp;genpy
#

### Section generating for lang: gencpp
### Generating Messages

### Generating Services
_generate_srv_cpp(svox_tts
  "/home/baxterdev/scazLab2_ws/src/svox_tts/srv/Speech.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/svox_tts
)

### Generating Module File
_generate_module_cpp(svox_tts
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/svox_tts
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(svox_tts_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(svox_tts_generate_messages svox_tts_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/svox_tts/srv/Speech.srv" NAME_WE)
add_dependencies(svox_tts_generate_messages_cpp _svox_tts_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(svox_tts_gencpp)
add_dependencies(svox_tts_gencpp svox_tts_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS svox_tts_generate_messages_cpp)

### Section generating for lang: genlisp
### Generating Messages

### Generating Services
_generate_srv_lisp(svox_tts
  "/home/baxterdev/scazLab2_ws/src/svox_tts/srv/Speech.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/svox_tts
)

### Generating Module File
_generate_module_lisp(svox_tts
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/svox_tts
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(svox_tts_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(svox_tts_generate_messages svox_tts_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/svox_tts/srv/Speech.srv" NAME_WE)
add_dependencies(svox_tts_generate_messages_lisp _svox_tts_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(svox_tts_genlisp)
add_dependencies(svox_tts_genlisp svox_tts_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS svox_tts_generate_messages_lisp)

### Section generating for lang: genpy
### Generating Messages

### Generating Services
_generate_srv_py(svox_tts
  "/home/baxterdev/scazLab2_ws/src/svox_tts/srv/Speech.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/svox_tts
)

### Generating Module File
_generate_module_py(svox_tts
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/svox_tts
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(svox_tts_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(svox_tts_generate_messages svox_tts_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/baxterdev/scazLab2_ws/src/svox_tts/srv/Speech.srv" NAME_WE)
add_dependencies(svox_tts_generate_messages_py _svox_tts_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(svox_tts_genpy)
add_dependencies(svox_tts_genpy svox_tts_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS svox_tts_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/svox_tts)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/svox_tts
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/svox_tts)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/svox_tts
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/svox_tts)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/svox_tts\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/svox_tts
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
