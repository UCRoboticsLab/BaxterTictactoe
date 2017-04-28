#include <ros/ros.h>
#include <sound_play/sound_play.h>

#include <robot_utils/ros_thread.h>

#include <baxter_tictactoe/MsgBoard.h>
#include <baxter_tictactoe/TTTBrainState.h>

#include "baxter_tictactoe/ttt_controller.h"
#include "baxter_tictactoe/tictactoe_utils.h"

#include <pthread.h>

namespace baxter_tictactoe
{

#define WIN_NONE    0
#define WIN_ROBOT   1
#define WIN_OPP     2
#define WIN_TIE     3

class tictactoeBrain : public ROSThread
{
private:
    ros::NodeHandle _nh;        // ROS node handle
    ros::AsyncSpinner spinner;  // AsyncSpinner to handle callbacks

    ros::Rate r;

    bool _legacy_code;   // Flag to enable the legacy code [who does not work]

    int    num_games;
    int    curr_game;

    std::vector<int> cheating_games; // vector that stores which of the games will be a cheating one.
    std::vector<int>           wins; // vector of three elements to count the wins (wins[0]->robot, wins[1]->opponent, wins[2]->ties)

    /* STATE OF THE BOARD */
    baxter_tictactoe::Board      curr_board; // Board as read from the board state sensor
    baxter_tictactoe::Board  internal_board; // Internal model of the state of the world

    ros::Subscriber   boardState_sub; // subscriber to receive the state of the board
    pthread_mutex_t mutex_curr_board;
    bool          _is_board_detected;

    /* STATE OF THE TTT DEMO */
    baxter_tictactoe::TTTBrainState    s; // state of the system
    ros::Timer          brainstate_timer; // timer to publish the state of the system at a specific rate

    ros::Publisher  tttBrain_pub;   // publisher to publish state of the system
    pthread_mutex_t _mutex_brain;   // mutex to protect the state of the system

    /* MISC */
    std::string    _robot_color;  // Color of the tokens the robot    is playing with.
    std::string _opponent_color;  // Color of the tokens the opponent is playing with.

    sound_play::SoundClient _voice_synthesizer;
    std::string                    _voice_type; // Type of voice.

    // Pointer to the function that chooses the next move
    int (tictactoeBrain::*_choose_next_move)();

    TTTController  leftArmCtrl;
    TTTController rightArmCtrl;

    bool has_cheated;

    size_t n_robot_tokens;
    size_t n_human_tokens;

    /**
     * Timer callback to publish the state of the demo.
     */
    void publishTTTBrainState(const ros::TimerEvent&);

    /**
     * ROS callback to handle the message published when the state of a cell has changed.
     *
     * \param msg the message with the new the state of each of the cells
     **/
    void boardStateCb(const baxter_tictactoe::MsgBoard &msg);

    /**
     * It determines randomly the next empty cell to place a token.
     *
     * @return                the cell where to place the next token
     **/
    int randomStrategyMove();

    /**
     * It determines the next cell to win by cheating (by placing a token on top of an opponent's token).
     * If the robot cannot win by explicitly cheating, it will try to win without breaking the rules.
     * Otherwise, it will try block opponent's victory. If this is not needed, it will randomly choose a cell.
     *
     * @return                the cell where to place the next token
     **/
    int cheatingStrategyMove();

    /**
     * It determines the next cell to win without cheating. If the robot cannot win, it will
     * try to block the opponent's victory. If this is not needed, it will randomly choose a cell.
     *
     * @return                the cell where to place the next token
     **/
    int smartStrategyMove();

    /*
     * It determines if the robot can win in this turn cheating, i.e. placing a token in a cell
     * occupied with an opponent's token.
     *
     * @param       id of the cell to move to if the action was successful (-1 if not)
     * @return      true/false if success/failure
     */
    bool cheatingMove(int &cell_id);

    /**
     * It determines if the opponent can win in the next move.
     *
     * @param       id of the cell to move to if the action was successful (-1 if not)
     * @return      true/false if success/failure
     **/
    bool defensiveMove(int &cell_id);

    /**
     * It determines if the robot can win in the next move.
     *
     * @param       id of the cell to move to if the action was successful (-1 if not)
     * @return      true/false if success/failure
     **/
    bool victoryMove(int &cell_id);

protected:

    void InternalThreadEntry();

public:

    tictactoeBrain(std::string _name="ttt_brain", std::string _strategy="smart",
                   bool legacy_code = false);

    ~tictactoeBrain();

    /**
     * Returns the cell where the next token is gonna be placed.
     * @param cheating It indicates if cheating happens
     * @return The return value is between 1 (first row, first column)
     * and NUMBER_OF_CELLS (last row, last column).
     **/
    int getNextMove();

    /**
     * This function returns the winner of the game.
     * @return 0 if there is not winner, 1 if the winner is the robot, or 2 if the winner is the opponent.
     **/
    unsigned short int getWinner();

    /**
     * This function blocks until the opponent has done his move.
     * This is detected considering the number of the opponent's
     * tokens on the board. The function waits until the number
     * of opponent's tokens in the board increases.
     * @param number of opponent's token at the beginning
     **/
    void waitForOpponentTurn(const size_t& n_robot_tokens);

    /**
     * This function synthesizes sentence and waits t seconds.
     * @param sentence string corresponding with the sentence to synthesize.
     * @param t number of seconds to block.
     **/
    void saySentence(std::string sentence, double t);

    /**
     * Plays one game
     */
    void playOneGame();

    /* GETTERS */
    std::string getRobotColor()        { return    _robot_color; };
    std::string getOpponentColor()     { return _opponent_color; };

    /**
     * Thread-safe method to retrieve the state of the tictactoeBrain
     *
     * @return the state of the tictactoeBrain
     */
    int getBrainState();

    /**
     * Thread-safe method to retrieve the latest board published by boardstate
     *
     * @return the latest board published by boardstate
     */
    baxter_tictactoe::Board  getCurrBoard();

    /* SETTERS */
    void setStrategy(std::string strategy);
    void setBrainState(int state);
};

}
