#ifndef __ROBOT_INTERFACE_H__
#define __ROBOT_INTERFACE_H__

#include <vector>

#include <image_transport/image_transport.h>
#include <cv_bridge/cv_bridge.h>
#include <sensor_msgs/image_encodings.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>

#include <baxter_core_msgs/DigitalIOState.h>
#include <baxter_core_msgs/EndpointState.h>
#include <baxter_core_msgs/CollisionAvoidanceState.h>
#include <baxter_core_msgs/CollisionDetectionState.h>
#include <baxter_core_msgs/JointCommand.h>
#include <baxter_core_msgs/SolvePositionIK.h>

#include <geometry_msgs/Point.h>
#include <sensor_msgs/Range.h>
#include <std_msgs/Empty.h>

#include "robot_utils/utils.h"
#include "robot_utils/ros_thread_obj.h"
#include "robot_utils/baxter_trac_ik.h"

#include <baxter_collaboration_msgs/GoToPose.h>

/**
 * @brief A ROS Thread class
 * @details This class initializes overhead ROS features: subscriber/publishers,
 *          services, callback functions etc.
 */
class RobotInterface
{
protected:
    ros::NodeHandle _n;

private:
    std::string    _name;
    std::string    _limb;       // Limb (either left or right)
    State         _state;       // State of the controller

    ros::AsyncSpinner spinner;  // AsyncSpinner to handle callbacks

    bool       _no_robot;       // Flag to know if we're going to use the robot or not
    bool     _use_forces;       // Flag to know if we're going to use the force feedback

    ros::Publisher  _joint_cmd_pub; // Publisher to control the robot in joint space
    ros::Publisher    _coll_av_pub; // Publisher to suppress collision avoidance behavior

    /**
     * IR Sensor
     */
    ros::Subscriber _ir_sub;
    bool              ir_ok;
    float       _curr_range;
    float   _curr_min_range;
    float   _curr_max_range;

    /**
     * Inverse Kinematics
     */
    // Default: TRAC IK
    baxterTracIK ik_solver;

    // Alternative IK: baxter-provided IK solver (for the TTT demo)
    bool             _use_trac_ik;
    ros::ServiceClient _ik_client;

    // Rate [Hz] of the control loop. Default 100Hz.
    double _ctrl_freq;

    /**
     * End-effector state
     */
    ros::Subscriber            _endpt_sub;
    std::vector<double>       _filt_force;
    double                    force_thres;
    std::vector<double>      _filt_change; // rate of change of filter
    ros::Time     _time_filt_last_updated; // time of last update to filter
    double                rel_force_thres; // relative threshold for force interaction
    double                  filt_variance; // variance threshold for force filter

    geometry_msgs::Point        _curr_pos;
    geometry_msgs::Quaternion   _curr_ori;
    geometry_msgs::Wrench    _curr_wrench;

    /**
     * Joint States
     */
    ros::Subscriber         _jntstate_sub;
    sensor_msgs::JointState    _curr_jnts;

    // Mutex to protect joint state variable
    pthread_mutex_t _mutex_jnts;

    /**
     * Collision avoidance State
     */
    ros::Subscriber _coll_av_sub;
    bool           is_coll_av_on;

    /**
     * Collision Detection State
     */
    ros::Subscriber _coll_det_sub;
    bool           is_coll_det_on;

    /**
     * Cuff buttons
     */
    ros::Subscriber _cuff_sub_lower; // circle button
    ros::Subscriber _cuff_sub_upper; // oval button

    /**
     * Control server
     */
    // Internal thread that implements the controller server
    ROSThreadObj _thread;

    // Flag to know if we're using the cartesian controller or not
    bool _use_cart_ctrl;

    // Control mode for the controller server. It can be either
    // baxter_collaboration_msgs::GoToPose::POSITION_MODE or
    // baxter_collaboration_msgs::GoToPose::VELOCITY_MODE , but for
    // now the latter is experimental
    int ctrl_mode;

    // Desired pose to move the arm to
    geometry_msgs::Pose pose_des;

    // Flag to know if the controller is running
    bool is_ctrl_running;

    // Subscriber that receives desired poses from other nodes
    ros::Subscriber _ctrl_sub;

    // Mutex to protect the control flag
    pthread_mutex_t _mutex_ctrl;

    // Time when the controller started
    ros::Time time_start;

    // Starting pose
    geometry_msgs::Pose pose_start;

    // Flag to know if the robot is running in experimental mode
    bool _is_experimental;

    /**
     * Initializes some control parameters when the controller starts.
     *
     * return       true/false if success/failure
     */
    bool initCtrlParams();

    /**
     * Sets the flag that handles if the controller is running or not.
     *
     * @param _flag true/false if the controller is running or not
     */
    void setCtrlRunning(bool _flag);

    /**
     * Callback for the controller server. It receives new poses
     * to move the arm to.
     *
     * @param msg the topic message
     */
    void ctrlMsgCb(const baxter_collaboration_msgs::GoToPose& msg);

    /**
     * Internal thread entry that gets called when the thread is started.
     * It is used to implement the control server to manage the Baxter's
     * arm from a separate thread.
     */
    static void* ThreadEntryFunc(void *obj);

    /**
     * Internal thread entry that gets called when the thread is started.
     * It is used to implement the control server to manage the Baxter's
     * arm from a separate thread.
     */
    void ThreadEntry();

    /**
     * Publishes the desired joint configuration in the proper topic, i.e.
     * /robot/limb/" + _limb + "/joint_command"
     *
     * @param _cmd The desired joint configuration
     */
    void publishJointCmd(baxter_core_msgs::JointCommand _cmd);

    /*
     * Callback function that sets the current pose to the pose received from
     * the endpoint state topic
     *
     * @param msg the topic message
     */
    void endpointCb(const baxter_core_msgs::EndpointState& msg);

    /**
     * Callback for the joint states. Used to seed the
     * inverse kinematics solver
     *
     * @param msg the topic message
     */
    void jointStatesCb(const sensor_msgs::JointState& msg);

    /**
     * Callback for the collision avoidance state. Used to detect
     * if the robot is currently pushed back by the collision avoidance
     * software which is embedded into the Baxter robot and we don't have
     * access to.
     *
     * @param msg the topic message
     */
    void collAvCb(const baxter_core_msgs::CollisionAvoidanceState& msg);

    /**
     * Callback for the collision detection state. Used to detect
     * if the robot is currently pushed back by the collision detection
     * software which is embedded into the Baxter robot and we don't have
     * access to.
     *
     * @param msg the topic message
     */
    void collDetCb(const baxter_core_msgs::CollisionDetectionState& msg);

    /*
     * Infrared sensor callback function that sets the current range to the range received
     * from the left hand range state topic
     *
     * @param      The message
     * @return     N/A
     */
    void IRCb(const sensor_msgs::RangeConstPtr& msg);

    /*
     * Starts thread that executes the control server. For now it is
     * just a wrapper for _thread.start(), but further functionality
     * may be added in the future.
     *
     * @return  true/false if success failure (NOT in the POSIX way)
     */
    bool startThread();

    /**
     * Closes the control server thread gracefully. For now it is
     * just a wrapper for _thread.close(), but further functionality
     * may be added in the future.
     *
     * @return  true/false if success failure (NOT in the POSIX way)
     */
    bool closeThread();

    /**
     * Kills the control server thread gracefully. For now it is
     * just a wrapper for _thread.kill(), but further functionality
     * may be added in the future.
     *
     * @return  true/false if success failure (NOT in the POSIX way)
     */
    bool killThread();


protected:
    /*
     * Checks for if the system is OK. To be called inside every thread execution,
     * in order to make it exit gracefully if there is any problem.
     * It also checks for the ROS state to be OK.
     * @return true if everything is okay, false otherwise
     */
    bool ok();

    /*
     * Callback function for the lower (circle) CUFF OK button.
     * By default, it sets the state of the controller to ERROR if the button
     * is pressed, but it can be specialized in any derived class.
     *
     * @param msg the topic message
     */
    virtual void cuffLowerCb(const baxter_core_msgs::DigitalIOState& msg);

    /*
     * Callback function for the upper (oval) CUFF OK button.
     * By default, it sets the state of the controller to ERROR if the button
     * is pressed, but it can be specialized in any derived class.
     *
     * @param msg the topic message
     */
    virtual void cuffUpperCb(const baxter_core_msgs::DigitalIOState& msg);

    /*
     * Checks if end effector has made contact with a token by checking if
     * the range of the infrared sensor has fallen below the threshold value
     *
     * @param     current range values of the IR sensor, and a string
     *            (strict/loose) indicating whether to use a high or low
     *            threshold value
     *
     * return     true if end effector has made contact; false otherwise
     */
    bool hasCollidedIR(std::string mode = "loose");

    /*
     * Checks if the collision detection topic broadcasts that a collision is
     * in place (and any robot movement will be stopped for two seconds)
     *
     * return     true if end effector motion has stopped; false otherwise
     */
    bool hasCollidedCD();

    /*
     * Checks if the arm has reached its intended pose by comparing
     * the requested and the current poses
     *
     * @param  p     requested Pose
     * @param  mode  (strict/loose) the desired level of precision
     * @return       true/false if success/failure
     */
    bool isPoseReached(geometry_msgs::Pose p, std::string mode = "loose");

    /*
     * Checks if the arm has reached its intended pose by comparing
     * the requested and the current poses
     *
     * @param  p     requested Position
     * @param  o     requested Orientation quaternion
     * @param  mode  (strict/loose) the desired level of precision
     * @return       true/false if success/failure
     */
    bool isPoseReached(geometry_msgs::Point p,
                       geometry_msgs::Quaternion o, std::string mode = "loose");

    /*
     * Checks if the arm has reached its intended pose by comparing
     * the requested and the current poses
     *
     * @param  px, py, pz     requested Position as set of doubles
     * @param  ox, oy, oz, ow requested Orientation quaternion as set of doubles
     * @param  mode           (strict/loose) the desired level of precision
     * @return                true/false if success/failure
     */
    bool isPoseReached(double px, double py, double pz,
                       double ox, double oy, double oz, double ow, std::string mode = "loose");

    /*
     * Checks if the arm has reached its intended position by comparing
     * the requested and the current positions
     *
     * @param  p     requested Position
     * @param  mode  (strict/loose) the desired level of precision
     * @return       true/false if success/failure
     */
    bool isPositionReached(geometry_msgs::Point p, std::string mode = "loose");

    /*
     * Checks if the arm has reached its intended position by comparing
     * the requested and the current positions
     *
     * @param  px, py, pz  requested Position as set of doubles
     * @param  mode        (strict/loose) the desired level of precision
     * @return             true/false if success/failure
     */
    bool isPositionReached(double px, double py, double pz, std::string mode = "loose");

    /*
     * Checks if the arm has reached its intended orientation by comparing
     * the requested and the current orientations
     *
     * @param  o     requested Orientation quaternion
     * @param  mode  (strict/loose) desired level of precision (currently not implemented)
     * @return       true/false if success/failure
     */
    bool isOrientationReached(geometry_msgs::Quaternion q, std::string mode = "loose");

    /*
     * Checks if the arm has reached its intended orientation by comparing
     * the requested and the current orientations
     *
     * @param  ox, oy, oz, ow requested Orientation quaternion as set of doubles
     * @param  mode           (strict/loose) desired level of precision (currently not implemented)
     * @return                true/false if success/failure
     */
    bool isOrientationReached(double ox, double oy, double oz, double ow, std::string mode = "loose");

    /*
     * Checks if the arm has reached its intended joint configuration by comparing
     * the requested and the current joint configurations
     *
     * @param  des_jnts     requested joint configuration as a set of doubles. It is
     *                      assumed to be populated as in the setJointCommands method, i.e.
     *                      in the order s0, s1, e0, e1, w0, w1, w2.
     * @param  mode         (strict/loose) the desired level of precision
     * @return              true/false if success/failure
     */
    bool isConfigurationReached(std::vector<double> des_jnts, std::string mode = "loose");

    /*
     * Checks if the arm has reached its intended joint configuration by comparing
     * the requested and the current joint configurations
     *
     * @param  des_jnts     requested joint configuration
     * @param  mode         (strict/loose) the desired level of precision
     * @return              true/false if success/failure
     */
    bool isConfigurationReached(baxter_core_msgs::JointCommand des_jnts, std::string mode = "loose");

    /*
     * Uses IK solver to find joint angles solution for desired pose
     *
     * @param    p requested Pose
     * @param    j array of joint angles solution
     * @return     true/false if success/failure
     */
    bool computeIK(geometry_msgs::Pose p, std::vector<double>& j);

    /*
     * Uses IK solver to find joint angles solution for desired pose
     *
     * @param    p requested Position
     * @param    o requested Orientation quaternion
     * @param    j array of joint angles solution
     * @return     true/false if success/failure
     */
    bool computeIK(geometry_msgs::Point p, geometry_msgs::Quaternion o, std::vector<double>& j);

    /*
     * Uses IK solver to find joint angles solution for desired pose
     *
     * @param    px, py, pz     requested Position as set of doubles
     * @param    ox, oy, oz, ow requested Orientation quaternion as set of doubles
     * @param    j              array of joint angles solution
     * @return                  true/false if success/failure
     */
    bool computeIK(double px, double py, double pz,
                   double ox, double oy, double oz, double ow,
                   std::vector<double>& j);

    /*
     * Uses IK solver to find joint angles solution for desired pose
     *
     * @param    p requested Pose
     * @return     true/false if success/failure
     */
    bool goToPoseNoCheck(geometry_msgs::Pose p);

    /*
     * Uses IK solver to find joint angles solution for desired pose
     *
     * @param    p requested Position
     * @param    o requested Orientation
     * @return     true/false if success/failure
     */
    bool goToPoseNoCheck(geometry_msgs::Point p, geometry_msgs::Quaternion o);

    /*
     * Moves arm to the requested pose. This differs from RobotInterface::goToPose because it
     * does not check if the final pose has been reached.
     *
     * @param    px, py, pz     requested Position as set of doubles
     * @param    ox, oy, oz, ow requested Orientation quaternion as set of doubles
     * @return                  true/false if success/failure
     */
    virtual bool goToPoseNoCheck(double px, double py, double pz,
                                 double ox, double oy, double oz, double ow);

    /*
     * Moves arm to the requested pose , and checks if the pose has been achieved
     *
     * @param  requested pose (3D position + 4D quaternion for the orientation)
     * @param  mode (either loose or strict, it checks for the final desired position)
     * @return true/false if success/failure
     */
    virtual bool goToPose(double px, double py, double pz,
                          double ox, double oy, double oz, double ow,
                          std::string mode="loose", bool disable_coll_av = false);

    /**
     * Moves arm to the requested joint configuration, without checking if the configuration
     * has been reached or not.
     *
     * @param  joint_values requested joint configuration
     * @return              true/false if success/failure
     */
    bool goToJointConfNoCheck(std::vector<double> joint_values);

    /*
     * Sets the joint names of a JointCommand
     *
     * @param    joint_cmd the joint command
     */
    void setJointNames(baxter_core_msgs::JointCommand& joint_cmd);

    /*
     * Sets the joint commands of a JointCommand
     *
     * @param        s0 First  shoulder joint
     * @param        s1 Second shoulder joint
     * @param        e0 First  elbow    joint
     * @param        e1 Second elbow    joint
     * @param        w0 First  wrist    joint
     * @param        w1 Second wrist    joint
     * @param        w2 Third  wrist    joint
     * @param joint_cmd the joint command
     */
    void setJointCommands(double s0, double s1, double e0, double e1,
                                     double w0, double w1, double w2,
                          baxter_core_msgs::JointCommand& joint_cmd);

    /*
     * Finds the relative difference of a to b (used in force filter calculations)
     * @param  a  first value
     * @param  b  value to which first value is compared relatively
     * @return value of the relative difference
     */
    double findRelativeDifference(double a, double b);

    /*
     * Detects if the force overcame a relative threshold in either one of its three axis
     *
     * @return true/false if the force overcame the threshold
     */
    bool detectForceInteraction();

    /*
     * Waits for a force interaction to occur.
     *
     * @return true when the force interaction occurred
     * @return false if no force interaction occurred after 20s
     */
    bool waitForForceInteraction(double _wait_time = 20.0, bool disable_coll_av = false);

    /*
     * Waits for _curr_jnts to be populated by jointStatesCb().
     *
     * @return true when _curr_jnts has values
     * @return false if _curr_jnts not initialized within 20 s
     */
    bool waitForJointAngles(double _wait_time = 20.0);

    /*
     * Filters the forces using a low pass filter and testing against predicted trends in filter values
     */
    void filterForces();

    /**
     * @brief Suppresses the collision avoidance for this arm
     * @details Suppresses the collision avoidance. It needs to be called with
     *          a rate of at least 5Hz
     *
     * @param _cmd An empty message to be sent
     */
    void suppressCollisionAv();

public:
    RobotInterface(std::string           name, std::string                   limb,
                   bool      no_robot = false, double     ctrl_freq = THREAD_FREQ,
                   bool    use_forces =  true, bool     use_trac_ik =        true,
                   bool use_cart_ctrl =  true, bool is_experimental =      false);

    ~RobotInterface();

    /*
     * Sets the internal state.
     */
    virtual void setState(int state);

    /**
     * Sets the usage of TracIK to true or false. It is one of the few flags
     * that can be switched at runtime.
     * @param  use_trac_ik if to use track ik or not
     */
    void setTracIK(bool use_trac_ik) { _use_trac_ik = use_trac_ik; };

    bool setIKLimits(KDL::JntArray  ll, KDL::JntArray  ul);
    bool getIKLimits(KDL::JntArray &ll, KDL::JntArray &ul);

    /*
     * Self-explaining "getters"
     */
    bool      isNoRobot() { return        _no_robot; };
    bool      useForces() { return      _use_forces; };
    bool      useTracIK() { return     _use_trac_ik; };
    bool    useCartCtrl() { return   _use_cart_ctrl; };
    bool isExperimental() { return _is_experimental; };

    std::string  getName() { return      _name; };
    std::string  getLimb() { return      _limb; };
    State       getState() { return     _state; };
    double   getCtrlFreq() { return _ctrl_freq; };

    geometry_msgs::Point        getPos()         { return    _curr_pos; };
    geometry_msgs::Quaternion   getOri()         { return    _curr_ori; };
    geometry_msgs::Wrench       getWrench()      { return _curr_wrench; };

    sensor_msgs::JointState     getJointStates();
    geometry_msgs::Pose                getPose();

    /**
     * Return the state of the controller (if it is running or not).
     *
     * @return      true/false if the controller is running or not
     */
    bool isCtrlRunning();

    /*
     * Check availability of the infrared data
    */
    bool    isIRok() { return ir_ok; };
};

#endif
