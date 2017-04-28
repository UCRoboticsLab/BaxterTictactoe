#include "robot_utils/ros_thread_image.h"

/**************************************************************************/
/*                          ROSThreadImage                                */
/**************************************************************************/

ROSThreadImage::ROSThreadImage(std::string name) :  ROSThread(), _n(name), _name(name),
                                     spinner(4), _img_trp(_n), _img_empty(true), r(30) // 30Hz
{
    pthread_mutexattr_t _mutex_attr;
    pthread_mutexattr_init(&_mutex_attr);
    pthread_mutexattr_settype(&_mutex_attr, PTHREAD_MUTEX_RECURSIVE_NP);
    pthread_mutex_init(&_mutex_img, &_mutex_attr);

    _img_sub = _img_trp.subscribe("/"+getName()+"/image", // "/cameras/right_hand_camera/image",
                           SUBSCRIBER_BUFFER, &ROSThreadImage::imageCb, this);

    spinner.start();
    startInternalThread();
}

ROSThreadImage::~ROSThreadImage()
{
    // closeInternalThread();
    pthread_mutex_destroy(&_mutex_img);
}

void ROSThreadImage::imageCb(const sensor_msgs::ImageConstPtr& msg)
{
    // ROS_INFO("imageCb");
    cv_bridge::CvImageConstPtr cv_ptr;

    try
    {
        cv_ptr = cv_bridge::toCvShare(msg, "bgr8");
    }
    catch(cv_bridge::Exception& e)
    {
        ROS_ERROR("cv_bridge exception: %s", e.what());
        return;
    }

    pthread_mutex_lock(&_mutex_img);
    _curr_img  = cv_ptr->image.clone();
    _img_size  =      _curr_img.size();
    _img_empty =     _curr_img.empty();
    pthread_mutex_unlock(&_mutex_img);
}

