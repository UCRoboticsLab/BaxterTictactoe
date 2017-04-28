#include "robot_perception/cartesian_estimator.h"

using namespace std;

#define FONT_FACE     cv::FONT_HERSHEY_SIMPLEX

/************************************************************************************/
/*                                 SEGMENTED OBJECT                                 */
/************************************************************************************/
SegmentedObj::SegmentedObj(vector<double> _size) :
                           name(""), is_there(false), size(_size), area_threshold(AREA_THRES),
                           rect(cv::Point2f(0,0), cv::Size2f(0,0), 0.0)
{
    init();
}

SegmentedObj::SegmentedObj(string _name, vector<double> _size, int _area_thres) :
                           name(_name), is_there(false), size(_size), area_threshold(_area_thres),
                           rect(cv::Point2f(0,0), cv::Size2f(0,0), 0.0)
{
    init();
}

void SegmentedObj::init()
{
    Rvec.create(3,1,CV_32FC1);
    Tvec.create(3,1,CV_32FC1);

    for (int i=0;i<3;i++)
    {
        Tvec.at<float>(i,0)=Rvec.at<float>(i,0)=-999999;
    }
}

bool SegmentedObj::detectObject(const cv::Mat& _in, cv::Mat& _out)
{
    return false;
}

bool SegmentedObj::detectObject(const cv::Mat& _in, cv::Mat& _out, cv::Mat& _out_thres)
{
    return false;
}

bool SegmentedObj::drawBox(cv::Mat &_img)
{
    if (isThere())
    {
        cv::Scalar color = cv::Scalar::all(255);

        cv::Point2f rect_points[4];
        rect.points(rect_points);

        for( int j = 0; j < 4; j++ )
        {
            cv::line   (_img, rect_points[j], rect_points[(j+1)%4], color, 2, 8 );
            // cv::putText(_img, toString(j), rect_points[j],
            //              FONT_FACE, 1, cv::Scalar::all(255), 2, CV_AA);
        }

        return true;
    }

    return false;
}

bool SegmentedObj::drawName(cv::Mat &_img)
{
    if (isThere())
    {
        cv::putText(_img, name.c_str(), rect.center,
                    FONT_FACE, 0.7, cv::Scalar::all(255), 0.7, CV_AA);
    }

    return false;
}

bool SegmentedObj::draw3dAxis(cv::Mat &_img, const cv::Mat& _cam_mat,
                                             const cv::Mat& _dist_mat)
{
    if (isThere())
    {
        float size=0.15;

        cv::Mat obj_points (4,3,CV_32FC1);
        obj_points.at<float>(0,0)=   0; obj_points.at<float>(0,1)=   0; obj_points.at<float>(0,2)=   0;
        obj_points.at<float>(1,0)=size; obj_points.at<float>(1,1)=   0; obj_points.at<float>(1,2)=   0;
        obj_points.at<float>(2,0)=   0; obj_points.at<float>(2,1)=size; obj_points.at<float>(2,2)=   0;
        obj_points.at<float>(3,0)=   0; obj_points.at<float>(3,1)=   0; obj_points.at<float>(3,2)=size;

        vector<cv::Point2f> img_points;
        cv::projectPoints( obj_points, Rvec, Tvec, _cam_mat, _dist_mat, img_points);

        //draw lines of different colours
        cv::line(_img, img_points[0], img_points[1], cv::Scalar(0,0,255,255), 1, CV_AA);
        cv::line(_img, img_points[0], img_points[2], cv::Scalar(0,255,0,255), 1, CV_AA);
        cv::line(_img, img_points[0], img_points[3], cv::Scalar(255,0,0,255), 1, CV_AA);
        cv::putText(_img, "x", img_points[1], FONT_FACE, 0.6, cv::Scalar(0,0,255,255), 2);
        cv::putText(_img, "y", img_points[2], FONT_FACE, 0.6, cv::Scalar(0,255,0,255), 2);
        cv::putText(_img, "z", img_points[3], FONT_FACE, 0.6, cv::Scalar(255,0,0,255), 2);

        return true;
    }

    return false;
}

bool SegmentedObj::draw(cv::Mat &_img, const cv::Mat& _cam_mat,
                                       const cv::Mat& _dist_mat)
{
    bool res = true;

    res = res & draw3dAxis(_img, _cam_mat, _dist_mat);
    res = res & drawBox   (_img);
    res = res & drawName  (_img);

    return res;
}

SegmentedObj::operator std::string()
{
    return std::string(name + " [" + toString(size[0]) + " "
                                   + toString(size[1]) + "]");
}

SegmentedObj::~SegmentedObj()
{

}

/************************************************************************************/
/*                               CARTESIAN ESTIMATOR                                */
/************************************************************************************/
CartesianEstimator::CartesianEstimator(string _name) : ROSThreadImage(_name)
{
    init();
}

CartesianEstimator::CartesianEstimator(string _name, vector<string> _objs_name,
                                       cv::Mat _objs_size) : ROSThreadImage(_name)
{
    ROS_ASSERT_MSG(_objs_size.cols == 2, "Objects' sizes should have two columns. "
                   "%i found instead", _objs_size.cols);

    addObjects(_objs_name, _objs_size);

    init();
}

void CartesianEstimator::init()
{
    img_pub        = _img_trp.advertise(      "/"+getName()+"/image_result", SUBSCRIBER_BUFFER);
    img_pub_thres  = _img_trp.advertise("/"+getName()+"/image_result_thres", SUBSCRIBER_BUFFER);
    objs_pub       = _n.advertise<baxter_collaboration_msgs::ObjectsArray>("/"+getName()+"/objects", 1);

    _n.param<string>("/"+getName()+"/reference_frame", reference_frame,         "");
    _n.param<string>("/"+getName()+   "/camera_frame",    camera_frame,         "");
    _n.param<int>   ("/"+getName()+ "/area_threshold",  area_threshold, AREA_THRES);

    ROS_INFO("Reference Frame: %s", reference_frame.c_str());
    ROS_INFO("Camera Frame   : %s",    camera_frame.c_str());
    ROS_INFO("Area Threshold : %i",  area_threshold        );

    ROS_ASSERT_MSG(not camera_frame.empty(), "Camera frame is empty!");

    if(reference_frame.empty()) reference_frame = camera_frame;

    sensor_msgs::CameraInfoConstPtr msg = ros::topic::waitForMessage<sensor_msgs::CameraInfo>
                                                           ("/"+getName()+"/camera_info", _n);
                                                           // ("/cameras/right_hand_camera/camera_info", _n);

    // For now, we'll assume images that are always rectified
    cam_param = aruco_ros::rosCameraInfo2ArucoCamParams(*msg, true);

    objects_msg.header.frame_id = reference_frame;
    objects_msg.header.seq = 0;
}

bool CartesianEstimator::publishObjects()
{
    ros::Time curr_stamp(ros::Time::now());

    objects_msg.objects.clear();
    objects_msg.objects.resize(getNumValidObjects());
    objects_msg.header.stamp = curr_stamp;
    objects_msg.header.seq++;

    int cnt = 0;
    for(size_t i = 0; i < objs.size(); ++i)
    {
        if (objs[i]->isThere())
        {
            baxter_collaboration_msgs::Object &object_cnt = objects_msg.objects.at(cnt);
            object_cnt.pose = objs[i]->pose;
            object_cnt.id   = i;
            object_cnt.name = objs[i]->getName();
            ++cnt;
        }
    }

    objs_pub.publish(objects_msg);

    return true;
}

void CartesianEstimator::InternalThreadEntry()
{
    // This is introduced to avoid starting the execution of the thread
    // before the derived class finishes initialization
    ros::Duration(0.2).sleep();

    while(ros::ok())
    {
        // ROS_INFO_THROTTLE(120, "I'm running, and everything is fine..."
        //                        " Number of objects: %i", getNumValidObjects());
        cv::Mat img_in;
        cv::Mat img_out;
        if (!_img_empty)
        {
            pthread_mutex_lock(&_mutex_img);
            img_in=_curr_img;
            pthread_mutex_unlock(&_mutex_img);
            img_out = img_in.clone();

            detectObjects(img_in, img_out);
            draw(img_out);
            poseRootRF();

            if (objs_pub.getNumSubscribers() > 0)    publishObjects();

            if (img_pub.getNumSubscribers() > 0)
            {
                sensor_msgs::ImagePtr msg = cv_bridge::CvImage(std_msgs::Header(),
                                                    "bgr8", img_out).toImageMsg();
                img_pub.publish(msg);
            }
        }
        r.sleep();
    }
}

bool CartesianEstimator::addObject(std::string _name, double _h, double _w)
{
    vector<double> size;

    // Let's put the longer size first
    if (_h > _w)
    {
        size.push_back(_h);
        size.push_back(_w);
    }
    else
    {
        size.push_back(_w);
        size.push_back(_h);
    }

    objs.push_back(new SegmentedObj(_name, size, getAreaThreshold()));

    return true;
}

bool CartesianEstimator::addObjects(std::vector<std::string> _names, cv::Mat _o)
{
    clearObjs();

    bool res = true;

    for (int i = 0; i < _o.rows; ++i)
    {
        res = res & addObject(_names[i], _o.at<float>(i, 0), _o.at<float>(i, 1));
    }

    return res;
}

bool CartesianEstimator::addObjects(XmlRpc::XmlRpcValue _params)
{
    ROS_ASSERT(_params.getType()==XmlRpc::XmlRpcValue::TypeStruct);
    ROS_WARN_COND(_params.size() == 0, "No objects available in the parameter server!");

    bool res = true;

    for (XmlRpc::XmlRpcValue::iterator i=_params.begin(); i!=_params.end(); ++i)
    {
        ROS_ASSERT(i->second.getType()==XmlRpc::XmlRpcValue::TypeStruct);

        ROS_ASSERT(i->second.size()>=1);

        for (XmlRpc::XmlRpcValue::iterator j=i->second.begin(); j!=i->second.end(); ++j)
        {
            // ROS_ASSERT(j->first.getType()==XmlRpc::XmlRpcValue::TypeString);
            if (j->first=="size")
            {
                ROS_ASSERT(j->second.getType()==XmlRpc::XmlRpcValue::TypeArray);
                ROS_ASSERT(j->second[0].getType()==XmlRpc::XmlRpcValue::TypeDouble);
                ROS_ASSERT(j->second[1].getType()==XmlRpc::XmlRpcValue::TypeDouble);

                res = res & addObject(static_cast<string>(i->first.c_str()),
                              static_cast<double>(i->second["size"][0]),
                              static_cast<double>(i->second["size"][1]));
            }
        }

    }

    return res;
}

bool CartesianEstimator::detectObjects(const cv::Mat& _in, cv::Mat& _out)
{
    cv::Mat out_thres(_in.rows, _in.cols, CV_8U, 0.0);

    bool res = true;

    for (size_t i = 0; i < objs.size(); ++i)
    {
        if (objs[i])
        {
            res = res & objs[i]->detectObject(_in, _out, out_thres);
        }
    }

    if (img_pub_thres.getNumSubscribers() > 0)
    {
        sensor_msgs::ImagePtr msg = cv_bridge::CvImage(std_msgs::Header(),
                                          "mono8", out_thres).toImageMsg();
        img_pub_thres.publish(msg);
    }

    return res;
}


void CartesianEstimator::printObjectDB()
{
    ROS_INFO("Available objects in the database : %s", objectDBToString().c_str());
    return;
}

string CartesianEstimator::objectDBToString()
{
    string res = "";

    for (size_t i = 0; i < objs.size(); ++i)
    {
        if (objs[i])
        {
            res = res + std::string(*objs[i]) + ", ";
        }
    }
    res = res.substr(0, res.size()-2); // Remove the last ", "

    return res;
}

bool CartesianEstimator::poseRootRF()
{
    bool res = true;

    for (size_t i = 0; i < objs.size(); ++i)
    {
        if (objs[i])
        {
            if (objs[i]->isThere())
            {
                res = res & poseRootRF(i);
            }
        }
    }

    return res;
}

bool CartesianEstimator::poseRootRF(int idx)
{
    bool res = poseCameraRF(idx);
    res = res && cameraRFtoRootRF(idx);

    return res;
}

bool CartesianEstimator::poseCameraRF(int idx)
{
    // Let's be sure that the width of the RotatedRect is the longest,
    // in order to ensure consistency in the computation of the orientation
    if (objs[idx]->rect.size.height > objs[idx]->rect.size.width)
    {
        float tmp = objs[idx]->rect.size.height;

        objs[idx]->rect.size.height = objs[idx]->rect.size.width;
        objs[idx]->rect.size.width  = tmp;
    }

    // Set image points from the rotated rectangle that defines the segmented object
    cv::Mat ImgPoints(4,2,CV_32FC1);

    cv::Point2f obj_segm_pts[4];
    objs[idx]->rect.points(obj_segm_pts);

    for (int j=0; j<4; j++)
    {
        ImgPoints.at<float>(j,0)=obj_segm_pts[j].x;
        ImgPoints.at<float>(j,1)=obj_segm_pts[j].y;
    }

    double h_w = objs[idx]->size[0]/2;
    double h_h = objs[idx]->size[1]/2;

    // Matrix representing the points relative to the objects.
    // The convention used is to have 0 in the bottom left,
    // with the others organized in a clockwise manner
    cv::Mat ObjPoints(4,3,CV_32FC1);
    ObjPoints.at<float>(0,0)=-h_w;   ObjPoints.at<float>(0,1)=-h_h;   ObjPoints.at<float>(0,2)=0;
    ObjPoints.at<float>(1,0)=-h_w;   ObjPoints.at<float>(1,1)=+h_h;   ObjPoints.at<float>(1,2)=0;
    ObjPoints.at<float>(2,0)=+h_w;   ObjPoints.at<float>(2,1)=+h_h;   ObjPoints.at<float>(2,2)=0;
    ObjPoints.at<float>(3,0)=+h_w;   ObjPoints.at<float>(3,1)=-h_h;   ObjPoints.at<float>(3,2)=0;

    cv::Mat raux,taux;
    cv::solvePnP(ObjPoints, ImgPoints, cam_param.CameraMatrix, cv::Mat(), raux, taux);
    raux.convertTo(objs[idx]->Rvec, CV_32F);
    taux.convertTo(objs[idx]->Tvec, CV_32F);

    return true;
}

bool CartesianEstimator::cameraRFtoRootRF(int idx)
{
    // Get the current transform from the camera frame to output ref frame
    tf::StampedTransform cameraToReference;
    cameraToReference.setIdentity();

    if ( reference_frame != camera_frame )
    {
        getTransform(reference_frame, camera_frame, cameraToReference);
    }

    // Now find the transform the detected object

    tf::Transform transform = object2Tf(idx);
    transform = static_cast<tf::Transform>(cameraToReference) * transform;
    tf::TransformBroadcaster br;
    tf::poseTFToMsg(transform, objs[idx]->pose);
    br.sendTransform(tf::StampedTransform(transform, ros::Time::now(), reference_frame,
                                                        objs[idx]->getName().c_str()));

    return true;
}

bool CartesianEstimator::getTransform(const string& refFrame,
                                      const string& childFrame,
                                      tf::StampedTransform& transform)
{
    string errMsg;

    if(!tfListener_.waitForTransform(refFrame, childFrame, ros::Time(0),
                                     ros::Duration(0.5), ros::Duration(0.01), &errMsg))
    {
        ROS_ERROR("Unable to get pose from TF: %s", errMsg.c_str());
        return false;
    }
    else
    {
        try
        {
            tfListener_.lookupTransform(refFrame, childFrame, ros::Time(0), transform);
        }
        catch ( const tf::TransformException& e)
        {
            ROS_ERROR("Error in lookupTransform of %s in %s ",
                        childFrame.c_str(), refFrame.c_str());
            return false;
        }
    }
    return true;
}

tf::Transform CartesianEstimator::object2Tf(int idx)
{
    cv::Mat rot(3, 3, CV_32FC1);
    cv::Rodrigues(objs[idx]->Rvec, rot);
    cv::Mat tran = objs[idx]->Tvec;

    // This transforms from the RF of the object to the RF of the end-effector
    // in order to be able to properly align the end-effector with the object itself
    cv::Mat obj2EE(3, 3, CV_32FC1);
    //  0 -1  0
    // -1  0  0
    //  0  0 -1
    obj2EE.at<float>(0,0) =  0.0; obj2EE.at<float>(0,1) = -1.0; obj2EE.at<float>(0,2) =  0.0;
    obj2EE.at<float>(1,0) = -1.0; obj2EE.at<float>(1,1) =  0.0; obj2EE.at<float>(1,2) =  0.0;
    obj2EE.at<float>(2,0) =  0.0; obj2EE.at<float>(2,1) =  0.0; obj2EE.at<float>(2,2) = -1.0;
    rot = rot*obj2EE.t();

    tf::Matrix3x3 tf_rot(rot.at<float>(0,0), rot.at<float>(0,1), rot.at<float>(0,2),
                         rot.at<float>(1,0), rot.at<float>(1,1), rot.at<float>(1,2),
                         rot.at<float>(2,0), rot.at<float>(2,1), rot.at<float>(2,2));

    tf::Vector3 tf_orig(tran.at<float>(0,0), tran.at<float>(1,0), tran.at<float>(2,0));

    return tf::Transform(tf_rot, tf_orig);
}

bool CartesianEstimator::draw(cv::Mat &_img)
{
    bool res = true;

    for (size_t i = 0; i < objs.size(); ++i)
    {
        if (objs[i])
        {
            res = res & draw(_img, i);
        }
    }

    return res;
}

bool CartesianEstimator::draw(cv::Mat &_img, int idx)
{
    objs[idx]->draw(_img, cam_param.CameraMatrix, cam_param.Distorsion);

    return true;
}

int CartesianEstimator::getNumValidObjects()
{
    int res = 0;

    for(size_t i = 0; i < objs.size(); ++i)
    {
        if (objs[i])
        {
            if (objs[i]->isThere())     res++;
        }
    }

    return res;
}

void CartesianEstimator::clearObjs()
{
    for (size_t i = 0; i < objs.size(); ++i)
    {
        if (objs[i])
        {
            delete objs[i];
            objs[i] = 0;
        }
    }

    objs.clear();
    return;
}

CartesianEstimator::~CartesianEstimator()
{
    clearObjs();
}
