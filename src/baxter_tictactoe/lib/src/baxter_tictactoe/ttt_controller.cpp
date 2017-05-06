#include "baxter_tictactoe/ttt_controller.h"

using namespace std;
using namespace baxter_core_msgs;
using namespace baxter_tictactoe;
using namespace geometry_msgs;
using namespace sensor_msgs;
using namespace cv;

/**************************************************************************/
/*                            TTTController                               */
/**************************************************************************/
/*UC changes, add counter to make robot pick up from different areas TODO reset counter at end of game*/
int counter;
geometry_msgs::Point coords [5];

/* Hard coded way points */ ////////////////Time-----joint state////////////
const double victory_wp[][JOINT_NUM * 2 + 1] =    {
													{0.396011,0.735160291754,0.85289331709,-0.100092246295,0.687606887384,-0.311781594781,0.801121465558,-0.312548585175,0.0191747598267,0.398451509198,0.777344763373,1.9140245259,-2.37958769449,-0.548781626239,-0.227029156348},
													{2.277558,0.729407863806,0.827582634119,-0.0966407895264,0.703713685638,-0.30641266203,0.815694283026,-0.309097128406,-0.230864108313,0.360485484741,0.750500099615,2.05131580626,0.50659715462,0.419543745007,-3.05952467794},
													{4.070346,0.698728248083,0.574859299603,-0.0832184576477,0.773126316211,-0.282252464648,0.913102062946,-0.283019455042,-0.410723355487,0.0479368995667,1.31807299048,1.35488852935,1.24827686472,0.576393280389,-1.89600025166},
													{5.311609,0.69911174328,0.579077746765,-0.0847524384338,0.772742821014,-0.284169940631,0.911184586963,-0.284936931024,-0.635068045459,0.17372332403,1.21031084026,1.10139820444,0.040266995636,0.525004924054,-1.72035945165},
													{6.021760,0.553767063794,-0.699878733673,-0.0080533991272,1.09257781492,-0.155315554596,1.3828836787,-0.152247593024,-0.46901462536,-0.705631161621,-0.413407821863,1.27473803328,0.145344679486,1.00935935728,-0.270364113556},
													{8.020817,0.556835025366,-0.698728248083,-0.00843689432373,1.0948787861,-0.154548564203,1.3828836787,-0.151864097827,-0.468631130164,-0.706014656818,-0.413407821863,1.27473803328,0.144577689093,1.00782537649,-0.270747608752},
													{9.520679,0.50774764021,-0.797670008789,-0.1438106987,1.73263129794,-0.253873820105,1.36907785162,-0.263461200018,-0.592500078644,-0.636602026245,-0.55645153017,0.694126305725,0.213606824469,-0.202101968573,-0.269980618359},
													{12.080919,0.510048611389,-0.797670008789,-0.143043708307,1.73263129794,-0.253873820105,1.36869435643,-0.263844695215,-0.592500078644,-0.63161658869,-0.556068034973,0.694509800922,0.213223329272,-0.201718473376,-0.269980618359},
													{14.030137,0.623563189563,-0.447538894354,-0.069796125769,0.177941771191,0.23891750744,0.166436915295,-0.206320415735,-0.759703984332,-0.443320447192,0.280334988666,1.77673324554,0.133456328394,1.66398565776,0.0839854480408},
													{16.560415,0.620878723187,-0.444087437585,-0.0705631161621,0.179475751978,0.237000031458,0.167970896082,-0.206320415735,-0.759320489136,-0.443703942389,0.280334988666,1.77558275995,0.132305842804,1.66475264815,0.0843689432373},
													{20.080919,0.510048611389,-0.797670008789,-0.143043708307,1.73263129794,-0.253873820105,1.36869435643,-0.263844695215,-0.592500078644,-0.63161658869,-0.556068034973,0.694509800922,0.213223329272,-0.201718473376,-0.269980618359},
													{23.030137,0.623563189563,-0.447538894354,-0.069796125769,0.177941771191,0.23891750744,0.166436915295,-0.206320415735,-0.759703984332,-0.443320447192,0.280334988666,1.77673324554,0.133456328394,1.66398565776,0.0839854480408},
													{27.528050,0.644271930176,-0.168737886475,-0.0782330200928,0.288388387793,0.118116520532,0.30526217644,-0.23124760351,-0.557985510956,-0.552233083008,0.0421844716187,1.56772836343,-2.78570910762,-1.47990796342,-0.770058354639},
													{29.315725,0.735160291754,0.859796230627,-0.101242731885,0.686456401794,-0.312932080371,0.800737970361,-0.311398099585,-0.205936920538,0.141893222717,1.66820410492,2.23807796697,-3.05032079323,-0.364320436707,-0.585597165106},
													{31.396011,0.735160291754,0.85289331709,-0.100092246295,0.687606887384,-0.311781594781,0.801121465558,-0.312548585175,0.0191747598267,0.398451509198,0.777344763373,1.9140245259,-2.37958769449,-0.548781626239,-0.227029156348}
												};
//--------------------------------------------------------time --------1----------------2---------------3-------------4------------5--------------6---------------7------------------8-------------9-------------10-----------11------------12-------------13---------------14----------
const double wave_wp[][JOINT_NUM * 2 + 1] = {
													{1.235733, 0.735160291754,0.849825355518,-0.100092246295, 0.683771935419,-0.312932080371,0.800354475165,-0.312165089978,0.0191747598267,0.398835004395,0.777344763373,1.91440802109,-2.37958769449,-0.548781626239,-0.226262165955},
													{5.055666, 0.738611748523,0.856728269055,-0.100475741492, 0.684155430615,-0.31638353714,0.800737970361,-0.314849556354,-0.821830206171,0.695660286511,3.05185477401,1.16812636864,-3.04840331724,-0.224728185168,-1.64174293636},
													{7.015908, 0.738611748523,0.857878754645,-0.0997087510986,0.684538925812,-0.316000041943,0.803805931934,-0.312932080371,-0.858262249841,0.862097201807,3.05070428842,2.61620423075,-3.04073341331,-0.30756314762,-1.6486458499},
													{12.009905,0.740145729309,0.860179725824,-0.100092246295,0.684155430615,-0.31638353714,0.801888455951,-0.314082565961,-0.857878754645,0.861330211414,3.05070428842,2.61888869713,-3.04073341331,-0.307179652423,-1.6482623547},
													{14.055666,0.738611748523,0.856728269055,-0.100475741492,0.684155430615,-0.31638353714,0.800737970361,-0.314849556354,-0.821830206171,0.695660286511,3.05185477401,1.16812636864,-3.04840331724,-0.224728185168,-1.64174293636},
													{16.015908,0.738611748523,0.857878754645,-0.0997087510986,0.684538925812,-0.316000041943,0.803805931934,-0.312932080371,-0.858262249841,0.862097201807,3.05070428842,2.61620423075,-3.04073341331,-0.30756314762,-1.6486458499},
													{18.059905,0.740145729309,0.860179725824,-0.100092246295,0.684155430615,-0.31638353714,0.801888455951,-0.314082565961,-0.857878754645,0.861330211414,3.05070428842,2.61888869713,-3.04073341331,-0.307179652423,-1.6482623547},
													{20.055666,0.738611748523,0.856728269055,-0.100475741492,0.684155430615,-0.31638353714,0.800737970361,-0.314849556354,-0.821830206171,0.695660286511,3.05185477401,1.16812636864,-3.04840331724,-0.224728185168,-1.64174293636},
													{25.235733,0.735160291754,0.849825355518,-0.100092246295,0.683771935419,-0.312932080371,0.800354475165,-0.312165089978,0.0191747598267,0.398835004395,0.777344763373,1.91440802109,-2.37958769449,-0.548781626239,-0.226262165955}
												};



//--------------------------------------------------------time --------1----------------2---------------3-------------4------------5--------------6---------------7------------------8-------------9-------------10-----------11------------12-------------13---------------14----------
const double giggle_wp[][JOINT_NUM * 2 + 1] = {
													{1,0.735160291754,0.849825355518,-0.100092246295,0.683771935419,-0.312932080371,0.800354475165,-0.312165089978,0.0191747598267,0.398835004395,0.777344763373,1.91440802109,-2.37958769449,-0.548781626239,-0.226262165955},
													{6.934641,0.73784475813,0.856728269055,-0.0993252559021,0.683771935419,-0.31638353714,0.800737970361,-0.312932080371,-0.316767032336,-0.481286471649,2.16636436522,2.4229226517,-3.05070428842,-0.19136410307,-0.511199096979},
													{10.235733,0.735160291754,0.849825355518,-0.100092246295,0.683771935419,-0.312932080371,0.800354475165,-0.312165089978,0.0191747598267,0.398835004395,0.777344763373,1.91440802109,-2.37958769449,-0.548781626239,-0.226262165955}
												};


TTTController::TTTController(string name, string limb, bool legacy_code, bool no_robot, bool use_forces):
                             ArmCtrl(name, limb, no_robot, use_forces, false, false),
                             r(100), _img_trp(_n), _legacy_code(legacy_code), _is_img_empty(true)
{
    pthread_mutexattr_t _mutex_attr;
    pthread_mutexattr_init(&_mutex_attr);
    pthread_mutexattr_settype(&_mutex_attr, PTHREAD_MUTEX_RECURSIVE_NP);
    pthread_mutex_init(&_mutex_img, &_mutex_attr);

    if (getLimb() == "left")
    {
        XmlRpc::XmlRpcValue hsv_red_symbols;
        ROS_ASSERT_MSG(_n.getParam("hsv_red",hsv_red_symbols), "No HSV params for RED!");
        hsv_red=hsvColorRange(hsv_red_symbols);

        XmlRpc::XmlRpcValue hsv_blue_symbols;
        ROS_ASSERT_MSG(_n.getParam("hsv_blue",hsv_blue_symbols), "No HSV params for BLUE!");
        hsv_blue=hsvColorRange(hsv_blue_symbols);

        XmlRpc::XmlRpcValue tiles_pile_pos;
        ROS_ASSERT_MSG(_n.getParam("tile_pile_position",tiles_pile_pos), "No 3D position of the pile of tiles!");
        tilesPilePosFromParam(tiles_pile_pos);

        XmlRpc::XmlRpcValue board_corner_poss;
        ROS_ASSERT_MSG(_n.getParam("board_corner_poss",board_corner_poss), "No 3D position of the board!");
        boardPossFromParam(board_corner_poss);

        _img_sub = _img_trp.subscribe("/cameras/"+getLimb()+"_hand_camera/image",
                               SUBSCRIBER_BUFFER, &TTTController::imageCb, this);
    }

    	insertAction(ACTION_SCAN,    static_cast<f_action>(&TTTController::scanBoardImpl));
        insertAction(ACTION_PICKUP,  static_cast<f_action>(&TTTController::pickUpTokenImpl));
        insertAction(ACTION_PUTDOWN, static_cast<f_action>(&TTTController::putDownTokenImpl));
        insertAction(ACTION_GESTURE, static_cast<f_action>(&TTTController::playbackJoints));
        ROS_INFO("---------------------------------------");
        startAction(LIST_ACTIONS);

    setHomeConfiguration();
    if (!callAction(ACTION_HOME)) setState(ERROR);
}

bool TTTController::tilesPilePosFromParam(XmlRpc::XmlRpcValue _params)
{
    ROS_ASSERT(_params.getType()==XmlRpc::XmlRpcValue::TypeArray);

    for(int j=0; j<_params.size(); ++j)
    {
        ROS_ASSERT(_params[j].getType()==XmlRpc::XmlRpcValue::TypeDouble);
    }
    //UC changed from original
    _tiles_pile_pos0.x = _params[0];
    _tiles_pile_pos0.y = _params[1];
    _tiles_pile_pos0.z = _params[2];
    _tiles_pile_pos1.x = _params[3];
    _tiles_pile_pos1.y = _params[4];
    _tiles_pile_pos1.z = _params[2];
    _tiles_pile_pos2.x = _params[5];
    _tiles_pile_pos2.y = _params[6];
    _tiles_pile_pos2.z = _params[2];
    _tiles_pile_pos3.x = _params[7];
    _tiles_pile_pos3.y = _params[8];
    _tiles_pile_pos3.z = _params[2];
    _tiles_pile_pos4.x = _params[9];
    _tiles_pile_pos4.y = _params[10];
    _tiles_pile_pos4.z = _params[2];
    coords[0] = _tiles_pile_pos0;
    coords[1] = _tiles_pile_pos1;
    coords[2] = _tiles_pile_pos2;
    coords[3] = _tiles_pile_pos3;
    coords[4] = _tiles_pile_pos4;
    ROS_INFO("[%s] Tile Pile Position: %g %g %g", getLimb().c_str(), _tiles_pile_pos0.x,
                                                  _tiles_pile_pos0.y, _tiles_pile_pos0.z);
    
    counter = 0;
    ROS_INFO("counter is at %i",counter);
    return true;
}

bool TTTController::boardPossFromParam(XmlRpc::XmlRpcValue _params)
{
    ROS_ASSERT(_params.getType()==XmlRpc::XmlRpcValue::TypeStruct);
    _board_corners_poss.clear();

    for (XmlRpc::XmlRpcValue::iterator i=_params.begin(); i!=_params.end(); ++i)
    {
        ROS_ASSERT(i->second.getType()==XmlRpc::XmlRpcValue::TypeArray);
        for(int j=0; j<i->second.size(); ++j)
        {
            ROS_ASSERT(i->second[j].getType()==XmlRpc::XmlRpcValue::TypeDouble);
        }
        // printf("%s %i %i\n", i->first.c_str(), static_cast<int>(i->second[0]),
        //                                        static_cast<int>(i->second[1]));
        if (i->first == "TL" || i->first == "TR" ||
            i->first == "BR" || i->first == "BL")
        {
            geometry_msgs::Point p;
            p.x = i->second[0];
            p.y = i->second[1];
            p.z = i->second[2];

            _board_corners_poss.push_back(p);
        }
    }

    ROS_ASSERT(_board_corners_poss.size() == 4);

    std::string coords_str = "";
    for (size_t i = 0; i < _board_corners_poss.size(); ++i)
    {
        coords_str = coords_str + "[ " + toString(_board_corners_poss[i].x) + " " +
                                         toString(_board_corners_poss[i].y) + " " +
                                         toString(_board_corners_poss[i].z) + "] ";
    }
    ROS_INFO("[%s] Board corners [BL BR TL TR]: %s", getLimb().c_str(), coords_str.c_str());

    // Now that we have the corners, let's compute all the coordinates
    _board_centers_poss.clear();
    _board_centers_poss.resize(9);

    _board_centers_poss[0] =                              _board_corners_poss[2];  // TL
    _board_centers_poss[1] = (_board_corners_poss[2] + _board_corners_poss[3])/2;
    _board_centers_poss[2] =                              _board_corners_poss[3];  // TR
    _board_centers_poss[3] = (_board_corners_poss[0] + _board_corners_poss[2])/2;
    _board_centers_poss[4] = (_board_corners_poss[0] + _board_corners_poss[1] +
                              _board_corners_poss[2] + _board_corners_poss[3])/4;
    _board_centers_poss[5] = (_board_corners_poss[1] + _board_corners_poss[3])/2;
    _board_centers_poss[6] =                              _board_corners_poss[0];  // BL
    _board_centers_poss[7] = (_board_corners_poss[0] + _board_corners_poss[1])/2;
    _board_centers_poss[8] =                              _board_corners_poss[1];  // BR

    ROS_INFO("[%s] Computed board centers [TL TR BL BR]:", getLimb().c_str());

    for (size_t i = 0; i < 3; ++i)
    {
        std::string coords_str = "";
        for (size_t j = 0; j < 3; ++j)
        {
            coords_str = coords_str + "[ " + toString(_board_centers_poss[i*3 + j].x) + " " +
                                             toString(_board_centers_poss[i*3 + j].y) + " " +
                                             toString(_board_centers_poss[i*3 + j].z) + "] ";
        }

        ROS_INFO("[%s] %s", getLimb().c_str(), coords_str.c_str());
    }

    return true;
}

/**************************************************************************/
/*                         PickUpToken                                    */
/**************************************************************************/
bool TTTController::gripToken()
{
    /*UC altered*/
	
    ROS_INFO("Counter = %d", counter);
    if (_legacy_code == true)
    {
        createCVWindows();
        cv::Point offset(0,0);
        // check if token is present before starting movement loop
        // (prevent gripper from colliding with play surface)
        while(RobotInterface::ok())
        {
            if(computeTokenOffset(offset)) break;

            ROS_WARN_THROTTLE(2,"No token detected by hand camera.");
            r.sleep();
        }

        offset = cv::Point(0,0);
    }

    ros::Time start_time = ros::Time::now();
    double start_z = getPos().z;

    while(RobotInterface::ok())
    {
        double px = 0.0, py = 0.0, pz = 0.0;

        if (_legacy_code == true)
        {
            cv::Point offset(0,0);
            computeTokenOffset(offset);

            // move incrementally towards token
            px = getPos().x - 0.07 * offset.y / 500;  // fixed constant to avoid going too fast
            py = getPos().y - 0.07 * offset.x / 500;  // fixed constant to avoid going too fast
            pz = start_z    - 0.08 * (ros::Time::now() - start_time).toSec();
        }
        else
        {
            px = coords[counter].x;
            py = coords[counter].y;
            pz = start_z - 0.10 * (ros::Time::now() - start_time).toSec();
        }

        goToPoseNoCheck(px,py,pz,VERTICAL_ORI_L);

        if(pz < -0.3)
        {
            ROS_WARN("I went too low! Exiting.");

            if (_legacy_code == true) { destroyCVWindows(); }
            gripObject();

            return false;
        }

        if(hasCollidedIR("loose")) break;
        r.sleep();
    }

    if (_legacy_code == true) { destroyCVWindows(); }
    gripObject();
    counter++;
    return true;
}

bool TTTController::computeTokenOffset(cv::Point &offset)
{
    Mat token(_img_size, CV_8UC1);
    Mat pool (_img_size, CV_8UC1);

    pool = detectPool();
    token = isolateToken(pool);

    bool res = false;

    Contours contours;
    vector<cv::Vec4i> hierarchy;
    findContours(token, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE);

    token = Mat::zeros(_img_size, CV_8UC1);

    // when hand camera is blind due to being too close to token, go straight down;
    if(contours.size() < 2)
    {
        offset = cv::Point(0,0);
    }
    else if(contours.size() <= 4)
    {
        // find highest and lowest x and y values from token triangles contours
        // to find x-y coordinate of top left token edge and token side length
        int y_min = (contours[0])[0].y;
        int x_min = (contours[0])[0].x;
        int y_max = 0;
        int x_max = 0;

        for (size_t i = 0; i < contours.size(); i++)
        {
            vector<cv::Point> contour = contours[i];
            for (size_t j = 0; j < contour.size(); j++)
            {
                if(y_min > contour[j].y) y_min = contour[j].y;
                if(x_min > contour[j].x) x_min = contour[j].x;
                if(y_max < contour[j].y) y_max = contour[j].y;
                if(x_max < contour[j].x) x_max = contour[j].x;
            }
        }

        // reconstruct token's square shape
        rectangle(token, Rect(x_min, y_min, y_max - y_min, y_max - y_min),
                                          Scalar(255,255,255), CV_FILLED);

        // find and draw the center of the token and the image
        int x_mid = int((x_max + x_min) / 2);
        int y_mid = int((y_max + y_min) / 2);

        int x_trg = int(_img_size.width/2+20);   // some offset to center the tile on the gripper
        int y_trg = int(_img_size.height/2-40);  // some offset to center the tile on the gripper

        circle(token, cv::Point(x_mid, y_mid), 3, Scalar(0, 0, 0), CV_FILLED);
        circle(token, cv::Point(x_trg, y_trg), 3, Scalar(180, 40, 40), CV_FILLED);

        offset.x = x_mid - x_trg;
        offset.y = y_mid - y_trg;

        ROS_DEBUG_THROTTLE(1, "Offset %i %i", offset.x, offset.y);

        res=true;
    }

    imshow("Processed", token);
    waitKey(10);

    return res;
}

cv::Mat TTTController::detectPool()
{
    Mat black = Mat::zeros(_img_size, CV_8UC1);
    Mat   out = Mat::zeros(_img_size, CV_8UC1);

    isolateBlack(black);
    // imshow("black", black);

    vector<cv::Vec4i> hierarchy;
    Contours contours;

    // find outer board contours
    findContours(black, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE);

    double largest = 0;
    int largest_index = 0;

    // iterate through contours and keeps track of contour w/ largest area
    for (size_t i = 0; i < contours.size(); i++)
    {
        if(contourArea(contours[i], false) > largest)
        {
            largest = contourArea(contours[i], false);
            largest_index = i;
        }
    }

    // contour w/ largest area is most likely the inner board
    vector<cv::Point> contour = contours[largest_index];

    drawContours(out, contours, largest_index, Scalar(255,255,255), CV_FILLED);
    return out;
}

Mat TTTController::isolateToken(Mat pool)
{
    Mat blue = Mat::zeros(_img_size, CV_8UC1);
    Mat out  = Mat::zeros(_img_size, CV_8UC1);

    isolateBlue(blue);    // imshow("blue", blue);

    bitwise_and(blue, pool, out);

    // Some morphological operations to remove noise and clean up the image
    for (size_t i = 0; i < 2; ++i)  erode(out, out, Mat());
    for (size_t i = 0; i < 4; ++i) dilate(out, out, Mat());
    for (size_t i = 0; i < 2; ++i)  erode(out, out, Mat());

    imshow("Rough", out);

    return out;
}

/**************************************************************************/
/*                               ScanBoard                                */
/**************************************************************************/

void TTTController::setDepth(float &dist)
{
    ROS_INFO("Computing depth..");

    geometry_msgs::Point init_pos = getPos();

    ros::Time start_time = ros::Time::now();

    // move downwards until collision with surface
    while(RobotInterface::ok())
    {
        double px = init_pos.x;
        double py = init_pos.y;
        double pz = init_pos.z - (ARM_SPEED+0.2) * (ros::Time::now() - start_time).toSec();

        double ox =   1.0;
        double oy = -0.03;
        double oz =   0.0;
        double ow =   0.0;

        goToPoseNoCheck(px,py,pz,ox,oy,oz,ow);

        if(hasCollidedIR("loose")) break;
        r.sleep();
    }

    // offset to account for height difference between IR camera and tip of vacuum gripper
    dist = init_pos.z - getPos().z + 0.04;
    ROS_INFO("Dist is %g", dist);
}

void TTTController::processImage(float dist)
{
    createCVWindows();
    while(RobotInterface::ok())
    {
        Contours contours;
        vector<cv::Point> centroids, board_corners, cell_to_corner;

        Mat binary, board;

        int board_area;

        isolateBlack(binary);
        isolateBoard(contours, board_area, board_corners, binary, board);

        waitKey(3);

        if(contours.size() == 9)
        {
            setOffsets(board_area, contours, dist, board, centroids);
            // imshow("[ScanBoard] Processed", board);

            if(offsetsReachable())
            {
                ROS_INFO_THROTTLE(2, "[Scan Board] Board is positioned correctly! Proceed with game\n");
                break;
            }
            else if(!offsetsReachable())
            {
                ROS_WARN("[Scan Board] Please move board within reachable zone\n");
                setZone(contours, dist, board_corners, centroids, cell_to_corner);

                // calls to IK solver in setZone takes too long; makes the image update
                // very slow and hard for users to calibrate board position, which is why
                // and inner loop is needed
                ros::Time start = ros::Time::now();
                int interval = 10;
                while(RobotInterface::ok())
                {
                    Mat zone = _curr_img.clone();

                    line(zone, centroids[0] + cell_to_corner[0],
                               centroids[2] + cell_to_corner[1], cv::Scalar(0,0,255), 1);
                    line(zone, centroids[2] + cell_to_corner[1],
                               centroids[8] + cell_to_corner[3], cv::Scalar(0,0,255), 1);
                    line(zone, centroids[0] + cell_to_corner[0],
                               centroids[6] + cell_to_corner[2], cv::Scalar(0,0,255), 1);
                    line(zone, centroids[6] + cell_to_corner[2],
                               centroids[8] + cell_to_corner[3], cv::Scalar(0,0,255), 1);

                    if((ros::Time::now() - start).toSec() > interval)
                    {
                        vector<cv::Point> temp_centroids, temp_board_corners;
                        isolateBlack(binary);
                        isolateBoard(contours, board_area, temp_board_corners, binary.clone(), board);
                        if(contours.size() == 9)
                        {
                            setOffsets(board_area, contours, dist, board, temp_centroids);
                        }

                        if(offsetsReachable()) { break; }
                        interval += 5;
                    }

                    imshow("Rough", zone);
                    waitKey(3);
                    r.sleep();
                }
            }
        }

        imshow("Processed", binary);
    }
    destroyCVWindows();
}

void TTTController::isolateBlack(Mat &output)
{
    Mat gray;
    pthread_mutex_lock(&_mutex_img);
    cvtColor(_curr_img, gray, CV_BGR2GRAY);
    pthread_mutex_unlock(&_mutex_img);
    threshold(gray, output, 55, 255, cv::THRESH_BINARY);
}

void TTTController::isolateBlue(Mat &output)
{
    Mat hsv(_img_size, CV_8UC1);

    pthread_mutex_lock(&_mutex_img);
    cvtColor(_curr_img, hsv, CV_BGR2HSV);
    pthread_mutex_unlock(&_mutex_img);

    output = hsvThreshold(hsv, hsv_blue);
}

void TTTController::isolateBoard(Contours &contours, int &board_area,
                                 vector<cv::Point> &board_corners, Mat input, Mat &output)
{
    output = Mat::zeros(_img_size, CV_8UC1);

    vector<cv::Vec4i> hierarchy; // captures contours within contours

    findContours(input, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE);

    double largest = 0, next_largest = 0;
    int largest_index = 0, next_largest_index = 0;

    // iterate through contours and keeps track of contour w/ 2nd-largest area
    for (size_t i = 0; i < contours.size(); i++)
    {
        if(contourArea(contours[i], false) > largest)
        {
            next_largest = largest;
            next_largest_index = largest_index;
            largest = contourArea(contours[i], false);
            largest_index = i;
        }
        else if(next_largest < contourArea(contours[i], false) && contourArea(contours[i], false) < largest)
        {
            next_largest = contourArea(contours[i], false);
            next_largest_index = i;
        }
    }

    board_area = contourArea(contours[next_largest_index], false);

    drawContours(output, contours, next_largest_index, Scalar(255,255,255), CV_FILLED, 8, hierarchy);

    findContours(output, contours, hierarchy, CV_RETR_TREE, CV_CHAIN_APPROX_SIMPLE);

    largest = 0;
    largest_index = 0;

    // iterate through contours and keeps track of contour w/ largest area
    for (size_t i = 0; i < contours.size(); i++)
    {
        if(contourArea(contours[i], false) > largest)
        {
            largest = contourArea(contours[i], false);
            largest_index = i;
        }
    }

    vector<cv::Point> board_outline = contours[largest_index];

    /* Set board corners and board area*/
    double y_min = board_outline[0].y;
    double x_min = board_outline[0].x;
    double y_max = 0;
    double x_max = 0;

    for (size_t i = 0; i < board_outline.size(); i++)
    {
        if(y_min > board_outline[i].y) y_min = board_outline[i].y;
        if(x_min > board_outline[i].x) x_min = board_outline[i].x;
        if(y_max < board_outline[i].y) y_max = board_outline[i].y;
        if(x_max < board_outline[i].x) x_max = board_outline[i].x;
    }

    board_corners.push_back(cv::Point(x_max, y_max));
    board_corners.push_back(cv::Point(x_min, y_max));
    board_corners.push_back(cv::Point(x_max, y_min));
    board_corners.push_back(cv::Point(x_min, y_min));

    // remove outer board contours
    contours.erase(contours.begin() + largest_index);

    for (size_t i = 0; i < contours.size(); i++)
    {
        if(contourArea(contours[i], false) < 200)
        {
            contours.erase(contours.begin() + i);
        }
    }

    for (size_t i = 0; i < contours.size(); i++)
    {
        drawContours(output, contours, i, Scalar(255,255,255), CV_FILLED);
    }
}

bool TTTController::descendingX(vector<cv::Point> i, vector<cv::Point> j)
{
    double x_i = moments(i, false).m10 / moments(i, false).m00;
    double x_j = moments(j, false).m10 / moments(j, false).m00;

    return x_i > x_j;
}

void TTTController::setOffsets(int board_area, Contours contours, float dist, Mat &output, vector<cv::Point> &centroids)
{
    cv::Point center(_img_size.width / 2, _img_size.height / 2);

    circle(output, center, 3, Scalar(180,40,40), CV_FILLED);
    cv::putText(output, "Center", center, cv::FONT_HERSHEY_PLAIN, 0.9, cv::Scalar(180,40,40));

    for (size_t i = contours.size(); i >= 3; i -= 3)
    {
        std::sort(contours.begin() + (i - 3), contours.begin() + i, descendingX);
    }

    _offsets.resize(9);//gesture_t
    centroids.resize(9);

    for (int i = int(contours.size()) - 1; i >= 0; i--)
    {
        double x = moments(contours[i], false).m10 / moments(contours[i], false).m00;
        double y = moments(contours[i], false).m01 / moments(contours[i], false).m00;
        cv::Point centroid(x,y);

        centroids[i] = centroid;

        // cv::putText(output, intToString(i), centroid, cv::FONT_HERSHEY_PLAIN, 0.9, cv::Scalar(180,40,40));
        // circle(output, centroid, 2, Scalar(180,40,40), CV_FILLED);
        line(output, centroid, center, cv::Scalar(180,40,40), 1);

        _offsets[i].x = (centroid.y - center.y) * 0.0025 * dist + 0.04;
        _offsets[i].y = (centroid.x - center.x) * 0.0025 * dist;
        _offsets[i].z = dist - 0.065;
    }
}

void TTTController::setZone(Contours contours, float dist, vector<cv::Point> board_corners,
                            vector<cv::Point> c, vector<cv::Point> &cell_to_corner)
{
    cell_to_corner.resize(4);

    // calculate offset between the center of corner cells and the corners of the board
    cell_to_corner[0] = cv::Point(board_corners[0].x - c[0].x, board_corners[0].y - c[0].y);
    cell_to_corner[1] = cv::Point(board_corners[1].x - c[2].x, board_corners[1].y - c[2].y);
    cell_to_corner[2] = cv::Point(board_corners[2].x - c[6].x, board_corners[2].y - c[6].y);
    cell_to_corner[3] = cv::Point(board_corners[3].x - c[8].x, board_corners[3].y - c[8].y);

    // if the centroid of a corner cell is reachable,
    // iterate and check if a location 10 pixels further from arm is still reachable
    // to establish a boundary of how far Baxter's arm can reach
    while(pointReachable(c[0], dist)) {c[0].x += 10.0;}
    while(pointReachable(c[2], dist)) {c[2].x -= 10.0;}
    while(pointReachable(c[6], dist)) {c[6].x += 10.0;}
    while(pointReachable(c[8], dist)) {c[8].x -= 10.0;}

    // if the centroid of a corner cell is unreachable,
    // iterate and check if a location 10 pixels closer is reachable
    while(!pointReachable(c[0], dist)) {c[0].x -= 5.0;}
    while(!pointReachable(c[2], dist)) {c[2].x += 5.0;}
    while(!pointReachable(c[6], dist)) {c[6].x -= 5.0;}
    while(!pointReachable(c[8], dist)) {c[8].x += 5.0;}
}

bool TTTController::offsetsReachable()
{
    for (size_t i = 0; i < NUMBER_OF_CELLS; i++)
    {
        double px = getPos().x + _offsets[i].x;
        double py = getPos().y + _offsets[i].y;
        double pz = getPos().z - _offsets[i].z;

        vector<double> joint_angles;
        if (!computeIK(px,py,pz,VERTICAL_ORI_L,joint_angles))
        {
            ROS_INFO("Offset number %lu not reachable", i);
            return false;
        }
    }
    return true;
}

bool TTTController::pointReachable(cv::Point centroid, float dist)
{
    // convert image location into real world pose coordinates
    cv::Point center(_img_size.width / 2, _img_size.height / 2);

    geometry_msgs::Point offset;

    offset.x = (centroid.y - center.y) * 0.0025 * dist + 0.04;
    offset.y = (centroid.x - center.x) * 0.0025 * dist;
    offset.z = dist - 0.085;

    double px = HOVER_BOARD_X + offset.x;
    double py = HOVER_BOARD_Y + offset.y;
    double pz = HOVER_BOARD_Z - offset.z;

    vector<double> joint_angles;
    return computeIK(px,py,pz,VERTICAL_ORI_L,joint_angles);
}

/**************************************************************************/
/*                               MISC                                     */
/**************************************************************************/

bool TTTController::createCVWindows()
{
    namedWindow("Hand Camera", WINDOW_NORMAL);
    namedWindow(      "Rough", WINDOW_NORMAL);
    namedWindow(  "Processed", WINDOW_NORMAL);
    resizeWindow("Hand Camera", 480, 300);
    resizeWindow(      "Rough", 480, 300);
    resizeWindow(  "Processed", 480, 300);
    moveWindow("Hand Camera", 10,  10);
    moveWindow(      "Rough", 10, 370);
    moveWindow(  "Processed", 10, 720);
    waitKey(10);

    return true;
}

bool TTTController::destroyCVWindows()
{
    destroyWindow("Hand Camera");
    destroyWindow("Processed");
    destroyWindow("Rough");

    return true;
}

bool TTTController::goHome()
{
    return ArmCtrl::goHome();
}

void TTTController::setHomeConfiguration()
{
    if (getLimb() == "left")
    {
        if (_legacy_code == true)
        {
            setHomeConf( 0.688, -0.858, -1.607, 1.371, 0.742, 1.733, 0.007);
        }
        else
        {
            setHomeConf( 0.581, -0.923, -1.162, 1.722, 0.653, 1.193, 0.024);
        }
    }
    else if (getLimb() == "right")
    {
        setHomeConf( -1.332, -0.579, 0.143, 2.270, -1.995, -1.469, -0.012);
    }
}

bool TTTController::startAction(string a, int o, bool block)
{
    baxter_collaboration_msgs::DoAction::Request  req;
    baxter_collaboration_msgs::DoAction::Response res;
    req.action = a;
    req.objects.push_back(o);

    //[UC] edition
    if(block)
    	serviceCb(req,res);
    else
    	unblocking_serviceCB(req, res);

    return res.success;
}

void TTTController::joinAction()
{
	// wait until the internal thread set the internal state 'DONE'
	ros::Rate r(THREAD_FREQ);
	    while( ros::ok() && ( int(getState()) != START   &&
	                          int(getState()) != ERROR   &&
	                          int(getState()) != DONE      ))
	    {
	        if (ros::isShuttingDown())
	        {
	            setState(KILLED);
	            return;
	        }

	        if (getState() == KILLED)
	        {
	        	// go home
	            recoverFromError();
	        }

	        r.sleep();
	    }

	    if ( int(getState()) == START   ||
	         int(getState()) == DONE      )
	    {
	    	ROS_INFO("[%s] Action succeed \n", getLimb().c_str());
	    }

	    if (getState() == ERROR)
	    {
	        ROS_INFO("[%s] Action failed. ERROR: %s \n", getLimb().c_str(), getSubState().c_str());
	    }

	    // Wait until internal thread exit
	    joinInternalThread();
	    return;
}

bool TTTController::playbackJoints()
{
	TTTController::gesture_t id = (TTTController::gesture_t)getObjectID();
	ROS_INFO("Playing gesture %d..", id);
	const double (* wps)[JOINT_NUM * 2 + 1];
	int wp_size = 0;
	double start_time;
	//vector<double> next_wp;
	int start_id;

	switch (id)
	{
		case wave:
			wps = wave_wp;
			wp_size = ARRAY_SIZE(wave_wp);
			break;
		case victory:
			wps = victory_wp;
			wp_size = ARRAY_SIZE(victory_wp);
			break;
		default:
			ROS_WARN("unknown gesture id %d", id);
			return false;
	}

	if(getLimb() == "left")
		start_id = 1;
	else
		start_id = 8;


    // set the start time at the beginning of each gesture
	start_time = ros::Time::now().toSec();
	ros::Rate rate(100);

	for(int j = 0; j < wp_size; j++)
	{
		vector<double> next_wp;
		// make a vector, skip time in the 1st element
		for(int i = start_id; i < JOINT_NUM + start_id; i++)
		{
			next_wp.push_back(wps[j][i]);
			ROS_INFO("Reached Line i=%i,j=%i",i,j);
		}

		// Keep sending message to limb topic until position reached or timeout
		while (RobotInterface::ok())
		{
			// Move the arm, return when goal gesture reached.
			goToJointConfNoCheck(next_wp);
			// go to the next way point if goal reached
			if(isConfigurationReached(next_wp, "strict"))
			{
				ROS_INFO("Reached way point %i", j);
				break;
			}
			// go to the next way point if time out
			if(ros::Time::now().toSec() - start_time > wps[j][0])
			{
				ROS_WARN("Time out when playing way point %d in gesture %d", j, id);
				break;
			}

			// send message at 100Hz
			rate.sleep();
		}
	}
	// Going back to home position
	goHome();

	ROS_INFO("Finished gesture %d..", id);
	return true;
}

bool TTTController::hoverAboveBoard()
{
    ROS_DEBUG("Hovering above board..");
    // return goToPose(HOVER_BOARD_X, 0.220, HOVER_BOARD_Z, 0.0,  1.0,  0.0,  0.0);
    return goToPose(HOVER_BOARD_X, HOVER_BOARD_Y, HOVER_BOARD_Z, 1.0, -0.03, 0, 0);
}

bool TTTController::hoverAboveCenterOfBoard()
{
    ROS_DEBUG("Hovering above center of board..");

    if (_legacy_code == true)
    {
        return goToPose(HOVER_BOARD_X + _offsets[4].x,
                        HOVER_BOARD_Y + _offsets[4].y,
                        HOVER_BOARD_Z - _offsets[4].z + 0.3,    // TODO this minus sign is a bug
                        VERTICAL_ORI_L);
    }
    else
    {
        return goToPose(_board_centers_poss[4].x,
                        _board_centers_poss[4].y,
                        _board_centers_poss[4].z + 0.3,
                        VERTICAL_ORI_L);
    }
}

bool TTTController::hoverAboveCell()
{
    ROS_DEBUG("Hovering above cell..");

    if (_legacy_code == true)
    {
        return goToPose(HOVER_BOARD_X + _offsets[getObjectID()-1].x,
                        HOVER_BOARD_Y + _offsets[getObjectID()-1].y,
                        HOVER_BOARD_Z - _offsets[getObjectID()-1].z + 0.05,
                        VERTICAL_ORI_L);
    }
    else
    {
        return goToPose(_board_centers_poss[getObjectID()-1].x,
                        _board_centers_poss[getObjectID()-1].y,
                        _board_centers_poss[getObjectID()-1].z + 0.05,
                        VERTICAL_ORI_L);
    }
}

bool TTTController::hoverAboveTokens(double height)
{
    return goToPose(0.540, 0.570, height, VERTICAL_ORI_L);
}

bool TTTController::scanBoardImpl()
{
    if (_legacy_code == false)
    {
        return true;
    }

    ROS_DEBUG("Scanning depth..");
    if (!hoverAboveBoard()) return false;

    // wait for image callback
    while(RobotInterface::ok())
    {
        if(!_is_img_empty) break;

        r.sleep();
    }

    float dist;
    setDepth(dist);
    if (!hoverAboveBoard()) return false;
    processImage(dist);

    ROS_DEBUG("Hovering above tokens..");
    hoverAboveTokens(Z_LOW);

    return true;
}

bool TTTController::pickUpTokenImpl()
{
    ROS_DEBUG("Picking up token..");
    setTracIK(true);

    while(RobotInterface::ok())
    {
        if(isIRok()) break;
        r.sleep();
    }

    // wait for image callback
    while(RobotInterface::ok())
    {
        if(!_is_img_empty) break;
        r.sleep();
    }

    hoverAboveTokens(Z_LOW);
    gripToken();
    hoverAboveTokens(Z_LOW);

    setTracIK(false);

    return true;
}

bool TTTController::putDownTokenImpl()
{
    ROS_DEBUG("Putting down token..");
    if (!hoverAboveCenterOfBoard()) return false;
    if (!hoverAboveCell()) return false;
    ros::Duration(0.1).sleep();
    if (!releaseObject()) return false;
    if (!hoverAboveCenterOfBoard()) return false;
    hoverAboveTokens(Z_LOW);

    return true;
}

void TTTController::imageCb(const sensor_msgs::ImageConstPtr& msg)
{
    cv_bridge::CvImageConstPtr cv_ptr;

    try
    {
        cv_ptr = cv_bridge::toCvShare(msg);
    }
    catch(cv_bridge::Exception& e)
    {
        ROS_ERROR("[TTT Controller] cv_bridge exception: %s", e.what());
        return;
    }

    pthread_mutex_lock(&_mutex_img);
    _curr_img     = cv_ptr->image.clone();
    _img_size     =      _curr_img.size();
    _is_img_empty =     _curr_img.empty();
    imshow("Hand Camera", _curr_img.clone());
    pthread_mutex_unlock(&_mutex_img);
}

TTTController::~TTTController()
{
    destroyCVWindows();

    pthread_mutex_destroy(&_mutex_img);
}
