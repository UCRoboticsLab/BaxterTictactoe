# Install script for directory: /home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs

# Set the install prefix
IF(NOT DEFINED CMAKE_INSTALL_PREFIX)
  SET(CMAKE_INSTALL_PREFIX "/home/baxterdev/scazLab2_ws/install")
ENDIF(NOT DEFINED CMAKE_INSTALL_PREFIX)
STRING(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
IF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  IF(BUILD_TYPE)
    STRING(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  ELSE(BUILD_TYPE)
    SET(CMAKE_INSTALL_CONFIG_NAME "")
  ENDIF(BUILD_TYPE)
  MESSAGE(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
ENDIF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)

# Set the component getting installed.
IF(NOT CMAKE_INSTALL_COMPONENT)
  IF(COMPONENT)
    MESSAGE(STATUS "Install component: \"${COMPONENT}\"")
    SET(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  ELSE(COMPONENT)
    SET(CMAKE_INSTALL_COMPONENT)
  ENDIF(COMPONENT)
ENDIF(NOT CMAKE_INSTALL_COMPONENT)

# Install shared libraries without execute permission?
IF(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  SET(CMAKE_INSTALL_SO_NO_EXE "1")
ENDIF(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/baxter_core_msgs/msg" TYPE FILE FILES
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/AnalogIOState.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/AnalogIOStates.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/AnalogOutputCommand.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/AssemblyState.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/AssemblyStates.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/CameraControl.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/CameraSettings.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/CollisionAvoidanceState.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/CollisionDetectionState.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/DigitalIOState.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/DigitalIOStates.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/DigitalOutputCommand.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/EndEffectorCommand.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/EndEffectorProperties.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/EndEffectorState.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/EndpointState.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/EndpointStates.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/HeadPanCommand.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/HeadState.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/ITBState.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/ITBStates.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/JointCommand.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/NavigatorState.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/NavigatorStates.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/RobustControllerStatus.msg"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/msg/SEAJointState.msg"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/baxter_core_msgs/srv" TYPE FILE FILES
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/srv/CloseCamera.srv"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/srv/ListCameras.srv"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/srv/OpenCamera.srv"
    "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/srv/SolvePositionIK.srv"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/baxter_core_msgs/cmake" TYPE FILE FILES "/home/baxterdev/scazLab2_ws/build/baxter_common/baxter_core_msgs/catkin_generated/installspace/baxter_core_msgs-msg-paths.cmake")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES "/home/baxterdev/scazLab2_ws/devel/include/baxter_core_msgs")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/common-lisp/ros" TYPE DIRECTORY FILES "/home/baxterdev/scazLab2_ws/devel/share/common-lisp/ros/baxter_core_msgs")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  execute_process(COMMAND "/usr/bin/python" -m compileall "/home/baxterdev/scazLab2_ws/devel/lib/python2.7/dist-packages/baxter_core_msgs")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python2.7/dist-packages" TYPE DIRECTORY FILES "/home/baxterdev/scazLab2_ws/devel/lib/python2.7/dist-packages/baxter_core_msgs")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/baxterdev/scazLab2_ws/build/baxter_common/baxter_core_msgs/catkin_generated/installspace/baxter_core_msgs.pc")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/baxter_core_msgs/cmake" TYPE FILE FILES "/home/baxterdev/scazLab2_ws/build/baxter_common/baxter_core_msgs/catkin_generated/installspace/baxter_core_msgs-msg-extras.cmake")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/baxter_core_msgs/cmake" TYPE FILE FILES
    "/home/baxterdev/scazLab2_ws/build/baxter_common/baxter_core_msgs/catkin_generated/installspace/baxter_core_msgsConfig.cmake"
    "/home/baxterdev/scazLab2_ws/build/baxter_common/baxter_core_msgs/catkin_generated/installspace/baxter_core_msgsConfig-version.cmake"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/baxter_core_msgs" TYPE FILE FILES "/home/baxterdev/scazLab2_ws/src/baxter_common/baxter_core_msgs/package.xml")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

