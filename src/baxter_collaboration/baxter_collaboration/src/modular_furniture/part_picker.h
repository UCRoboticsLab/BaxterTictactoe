#ifndef __PART_PICKER_H__
#define __PART_PICKER_H__

#include <flatpack_furniture/artag_ctrl.h>

class PartPicker : public ARTagCtrl
{
private:
    bool cuff_button_pressed;

protected:
    /*
     * Callback function for the upper (oval) CUFF OK button.
     * Specialized from RobotInterface::cuffUpperCb. Here it is used to receive
     * feedback from the user about the internal states of the hold action
     *
     * @param msg the topic message
     */
    virtual void cuffUpperCb(const baxter_core_msgs::DigitalIOState& msg);

    /**
     * Waits for the user to press the cuff button. Used in the hold action.
     *
     * @param _wait_time Time duration (in s) after which the method will return false
     * @return           true/false if button has been pressed.
     */
    bool waitForUserFb(double _wait_time = 60.0);

    /**
     * Sets the joint-level configuration for the home position
     */
    void setHomeConfiguration();

    /**
     * [passObject description]
     * @return true/false if success/failure
     */
    bool passObject();

public:
    /**
     * Constructor
     */
    PartPicker(std::string _name, std::string _limb, bool _no_robot = false);

    /**
     * Destructor
     */
    ~PartPicker();
};

#endif
