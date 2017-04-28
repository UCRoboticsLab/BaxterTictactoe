#include "robot_utils/baxter_trac_ik.h"

baxterTracIK::baxterTracIK(std::string limb, bool no_robot) : _limb(limb), _urdf_param("/robot_description"),
                                                              _timeout(0.005), _eps(1e-6), _num_steps(4)
{
    if (no_robot)
    {
        _tracik_solver = 0;
        _nominal       = 0;
        return;
    }

    // TRACK_IK::Speed: returns very quickly the first solution found
    // TRACK_IK::Distance: runs for the full timeout_in_secs, then returns the solution that minimizes SSE from the seed
    // TRACK_IK::Manip1: runs for full timeout, returns solution that maximizes sqrt(det(J*J^T))
    // TRACK_IK::Manip2: runs for full timeout, returns solution that minimizes cond(J) = |J|*|J^-1|);
    _tracik_solver = new TRAC_IK::TRAC_IK("base", limb + "_gripper", _urdf_param, _timeout, _eps, TRAC_IK::Distance);

    KDL::JntArray ll, ul; //lower joint limits, upper joint limits

    if(!(_tracik_solver->getKDLChain(_chain)))
    {
        ROS_ERROR("There was no valid KDL chain found");
        exit(EXIT_FAILURE);
    }

    if(!(getKDLLimits(ll,ul)))
    {
        ROS_ERROR("There were no valid KDL joint limits found");
        exit(EXIT_FAILURE);
    }

    if(!(_chain.getNrOfJoints() == ll.data.size()) ||
       !(_chain.getNrOfJoints() == ul.data.size()))
    {
        ROS_ERROR("Inconsistent joint limits found");
        exit(EXIT_FAILURE);
    }

    double s1l = -1.35;
    double s1u =  1.0;
    ROS_INFO("[%s] Setting custom joint limits for %s_s1: [%g %g]", _limb.c_str(), _limb.c_str(), s1l, s1u);
    ll.data[1] =  s1l;
    ul.data[1] =  s1u;

    setKDLLimits(ll,ul);

    // Create Nominal chain configuration midway between all joint limits
    _nominal = new KDL::JntArray(_chain.getNrOfJoints());

    for (int j=0; j < _nominal->data.size(); j++)
    {
      _nominal->operator()(j) = (ll(j)+ul(j))/2.0;
    }
}

bool baxterTracIK::getKDLLimits(KDL::JntArray &ll, KDL::JntArray &ul)
{
    return _tracik_solver->getKDLLimits(ll,ul);
}

bool baxterTracIK::setKDLLimits(KDL::JntArray ll, KDL::JntArray ul)
{
    _tracik_solver->setKDLLimits(ll,ul);
    return true;
}

baxterTracIK::~baxterTracIK()
{
    if (_tracik_solver)
    {
        delete _tracik_solver;
        _tracik_solver = 0;
    }

    if (_nominal)
    {
        delete _nominal;
        _nominal = 0;
    }
}

KDL::JntArray baxterTracIK::JointState2JntArray(const sensor_msgs::JointState &js)
{
    KDL::JntArray array(_chain.getNrOfJoints());
    for(size_t joint=0; joint<js.position.size(); ++joint)
    {
        array(joint) = js.position[joint];
    }
    return array;
}

bool baxterTracIK::perform_ik(baxter_core_msgs::SolvePositionIK &ik_srv)
{
    int rc;
    KDL::JntArray result;
    sensor_msgs::JointState joint_state;

    for(size_t i=0; i<_chain.getNrOfSegments(); ++i)
    {
        KDL::Joint joint = _chain.getSegment(i).getJoint();
        if(joint.getType()!=KDL::Joint::None)
        {
            joint_state.name.push_back(joint.getName());
        }
    }

    bool seeds_provided = ik_srv.request.seed_angles[0].name.size() == joint_state.name.size();

    joint_state.position.clear();
    KDL::Frame ee_pose(KDL::Rotation::Quaternion(ik_srv.request.pose_stamp[0].pose.orientation.x,
                                                 ik_srv.request.pose_stamp[0].pose.orientation.y,
                                                 ik_srv.request.pose_stamp[0].pose.orientation.z,
                                                 ik_srv.request.pose_stamp[0].pose.orientation.w),
                       KDL::Vector(ik_srv.request.pose_stamp[0].pose.position.x,
                                   ik_srv.request.pose_stamp[0].pose.position.y,
                                   ik_srv.request.pose_stamp[0].pose.position.z));

    KDL::JntArray seed(_chain.getNrOfJoints());

    if(seeds_provided)   seed = JointState2JntArray(ik_srv.request.seed_angles[0]);

    for(int num_attempts=0; num_attempts<_num_steps; ++num_attempts)
    {
        if (num_attempts>0)
        {
            ROS_DEBUG("Attempt num %i with tolerance %g", num_attempts, _eps);
        }

        rc = _tracik_solver->CartToJnt(seeds_provided? seed: *(_nominal), ee_pose, result);

        // computeFwdKin(result);
        if(rc>=0) break;
    }

    for(size_t j=0; j<_chain.getNrOfJoints(); ++j)
    {
        joint_state.position.push_back(result(j));
    }

    ik_srv.response.joints.push_back(joint_state);
    ik_srv.response.isValid.push_back(rc>=0);

    return true;
}

#include <iostream>
#include <kdl/chainfksolver.hpp>
#include <kdl/chainfksolverpos_recursive.hpp>
#include <kdl/frames_io.hpp>

void baxterTracIK::computeFwdKin(KDL::JntArray jointpositions)
{
    printf("joints:\t");
    for(size_t j=0; j<_chain.getNrOfJoints(); ++j)
    {
        printf("\t%g",jointpositions(j));
    }
    printf("\n");

    // Create solver based on kinematic chain
    KDL::ChainFkSolverPos_recursive fksolver = KDL::ChainFkSolverPos_recursive(_chain);

    // Create the frame that will contain the results
    KDL::Frame cartpos;

    // Calculate forward position kinematics
    bool kinematics_status;
    kinematics_status = fksolver.JntToCart(jointpositions,cartpos);
    if(kinematics_status>=0)
    {
        std::cout << cartpos <<std::endl;
    }
    else
    {
        printf("%s \n","Error: could not calculate forward kinematics.");
    }
}
