#include "tictactoeBrain.h"
#include "std_msgs/String.h"
#include <stdlib.h> // srand, rand

using namespace std;
using namespace baxter_tictactoe;

tictactoeBrain::tictactoeBrain(std::string _name, std::string _strategy, bool legacy_code) : _nh(_name),
                               spinner(13), r(100), _legacy_code(legacy_code), num_games(NUM_GAMES), curr_game(0),
                               robot_turn(false), highest_empty_pool(0), woz_dance(false), woz_wave(true),
                               woz_giggle(false), woz_cheat(false),wins(3,0), curr_board(9), internal_board(9),
                               _is_board_detected(false),leftArmCtrl(_name, "left", legacy_code),
                               rightArmCtrl(_name, "right", legacy_code), n_robot_tokens(0), n_human_tokens(0)
{
    printf("\n");
    ROS_INFO("Legacy code %s enabled.", legacy_code?"is":"is not");
    setBrainState(TTTBrainState::INIT);

    srand(ros::Time::now().nsec);
    setStrategy(_strategy);

    pthread_mutexattr_t _mutex_attr;
    pthread_mutexattr_init(&_mutex_attr);
    pthread_mutexattr_settype(&_mutex_attr, PTHREAD_MUTEX_RECURSIVE_NP);
    pthread_mutex_init(&_mutex_brain, &_mutex_attr);
    pthread_mutex_init(&mutex_curr_board, &_mutex_attr);
    pthread_mutex_init(&_mutex_woz, &_mutex_attr);

    boardState_sub = _nh.subscribe("/baxter_tictactoe/board_state", SUBSCRIBER_BUFFER,
                                    &tictactoeBrain::boardStateCb, this);
    woz_cmd_sub = _nh.subscribe("/woz_cmd", SUBSCRIBER_BUFFER, &tictactoeBrain::wozCmdCb, this);

    tttBrain_pub   = _nh.advertise<TTTBrainState>("/baxter_tictactoe/ttt_brain_state", 1);
    woz_st_pub = _nh.advertise<baxter_collaboration_msgs::WOZ>("/woz_st", 1);
    animator_pub   = _nh.advertise<std_msgs::String>("/emotion", 1);

    brainstate_timer = _nh.createTimer(ros::Duration(0.1), &tictactoeBrain::publishTTTBrainState, this, false);
    invitation_timer = _nh.createTimer(ros::Duration(10), &tictactoeBrain::invitationCB, this, false, false);
    woz_timer =        _nh.createTimer(ros::Duration(1), &tictactoeBrain::pubWozSt, this, false);

    _nh.param<string>("voice", _voice_type, VOICE);
    ROS_INFO("Using voice %s", _voice_type.c_str());

    _nh.param<int>("num_games", num_games, NUM_GAMES);

    if (_nh.hasParam("cheating_games"))
    {
        _nh.getParam("cheating_games", cheating_games);
    }
    else
    {
        cheating_games.push_back(CHEATING_GAME_A);
        cheating_games.push_back(CHEATING_GAME_B);
    }

    ROS_INFO("Number of games: %i; Cheating games: %s",
              num_games, toString(cheating_games).c_str());

    _nh.param<string>("robot_color", _robot_color, "blue");
    _robot_color    = _robot_color==COL_BLUE?COL_BLUE:COL_RED;
    _opponent_color = _robot_color==COL_BLUE?COL_RED:COL_BLUE;

    ROS_INFO("Robot plays with %s tokens and the opponent with %s tokens.",
              getRobotColor().c_str(), getOpponentColor().c_str());

    startInternalThread();
}

void tictactoeBrain::InternalThreadEntry()
{
    bool wipe_out_board_message = true;
    while (ros::ok())
    {
        if      (getBrainState() == TTTBrainState::INIT)
        {
            rightArmCtrl.startAction(ACTION_SCAN);
            setBrainState(TTTBrainState::CALIB);
        }
        else if (getBrainState() == TTTBrainState::CALIB)
        {
            if (rightArmCtrl.getState() == DONE) { setBrainState(TTTBrainState::READY); }
        }
        else if (getBrainState() == TTTBrainState::READY)
        {
        	// wait for the first boradstate message come in
            if (_is_board_detected)
            {
            	setBrainState(TTTBrainState::WAIT);
            }
        }
        else if (getBrainState() == TTTBrainState::WAIT)
        {
        	pubAnimation("welcome");  //todo: do we need welcome face on anyway?
        	//if(getWozWave())
        	//{
        	//	ROS_INFO("start waving..");
        	//	playGesture(TTTController::wave);
        	//	// Play wave once only.
        	//	setWozWave(false);
        	//}

        	// Wait for the first move from opponent
        	waitForOpponent2Start();
        	setBrainState(TTTBrainState::MATCH_STARTED);
        }
        else if (getBrainState() == TTTBrainState::MATCH_STARTED)
        {
            saySentence("Welcome! Let's play Tic Tac Toe.", 3);
            saySentence("Do not grasp your token before I say that it is your turn", 4);
            curr_game = 1;
            setBrainState(TTTBrainState::GAME_STARTED);
        }
        else if (getBrainState() == TTTBrainState::GAME_STARTED)
        {
            pubAnimation("playing");
            //if (getCurrBoard().isEmpty())
	    if(getCurrBoard().getNumTokens(COL_RED))
            {
                setBrainState(TTTBrainState::GAME_RUNNING);
                wipe_out_board_message = true;
            }
            else if (wipe_out_board_message == true)
            {
                wipe_out_board_message = false;
                saySentence("Please clean the board so that we can start a new game.", 6);
            }
        }
        else if (getBrainState() == TTTBrainState::GAME_RUNNING)
        {
            ROS_WARN("GAME #%i", curr_game);

            playOneGame();

            if (curr_game > num_games) { setBrainState(baxter_tictactoe::TTTBrainState::MATCH_FINISHED); }
            else                       { setBrainState(baxter_tictactoe::TTTBrainState::GAME_STARTED);   }
        }
        else if (getBrainState() == TTTBrainState::MATCH_FINISHED)
        {
            saySentence("Game over. It was my pleasure to win over you. Thanks for being so human.", 10);
            ROS_INFO("Baxter Wins: %i\tHuman Wins: %i\tTies: %i", wins[0], wins[1], wins[2]);

            ROS_INFO("Match finished...going to WAIT mode........");
            setBrainState(TTTBrainState::WAIT);
		}

        //ROS_INFO("*********************Current brain state is %d *********************", s.state);
        r.sleep();
    }
}

void tictactoeBrain::playOneGame()
{
    int winner  = WIN_NONE;

    bool has_to_cheat=false;

    for (size_t j = 0; j < cheating_games.size(); ++j)
    {
        if (cheating_games[j] == curr_game)
        {
            has_to_cheat=true;
        }
    }

    if (has_to_cheat)   { setStrategy("cheating"); }
    else                { setStrategy(   "smart"); }

    saySentence("I start the game.",2);

    n_robot_tokens=0;
    n_human_tokens=internal_board.getNumTokens(getOpponentColor());

    while (winner == WIN_NONE && not internal_board.isFull() && not ros::isShuttingDown())
    {
        if (robot_turn) // Robot's turn
        {
            if (n_robot_tokens != 0) { saySentence("It is my turn", 0.3); }

            int cell_toMove = getNextMove();    // This should be from 1 to 9
            ROS_INFO("Moving to cell %i", cell_toMove);

            rightArmCtrl.startAction(ACTION_PICKUP, highest_empty_pool + 1 + internal_board.getNumCells());
            highest_empty_pool++;
            rightArmCtrl.startAction(ACTION_PUTDOWN, cell_toMove);
            internal_board.setCellState(cell_toMove-1, getRobotColor());
            n_robot_tokens = internal_board.getNumTokens(getRobotColor());

            if(internal_board.twoInARow(getRobotColor(),cell_toMove-1)){
            	// Please use the get function to access WOZ state for thread safty
            	if(getWozGiggle())
            	{
            		// Play giggle only when woz_giggle is true
            		pubAnimation("giggling");
            		playGesture(TTTController::giggle);
            		pubAnimation("playing");
            	}
            }
        }
        else // Participant's turn
        {
            waitForOpponentTurn(n_robot_tokens);
        }

        robot_turn = not robot_turn;
        winner = getWinner();
    }



    switch(winner)
    {
        case WIN_ROBOT:
            ROS_INFO("ROBOT's VICTORY");
            if(getWozDance())
            {
				pubAnimation("dance");
				playGesture(TTTController::victory); // Play gesture victory
            }

            if (has_cheated)
            {
                saySentence("You humans are so easy to beat!", 3);
            }
            saySentence("I won", 1);		
            break;
        case WIN_OPP:
            ROS_INFO("OPPONENT's VICTORY");
            saySentence("You won this time", 2);
            break;
        default:
            ROS_INFO("TIE");
            saySentence("That's a tie. I will win next time.", 3);
            winner = WIN_TIE;
    }

    cleanBoard();
	ROS_INFO("Board cleaned, let's start another game.");

	setBrainState(TTTBrainState::GAME_FINISHED);
	robot_turn = false; //[UC edition] let the player start first

    // Let's increment the winners' count
    wins[winner-1] = wins[winner-1] + 1;

    if (has_to_cheat && not has_cheated)
    {
        ROS_WARN("Cheating game ended without cheating. Game counter does not increase.");
        curr_game--;
    }

    curr_game++;
    internal_board.resetCellStates();

    return;
}

Board tictactoeBrain::getCurrBoard()
{
    Board res;

    pthread_mutex_lock(&mutex_curr_board);
    res = curr_board;
    pthread_mutex_unlock(&mutex_curr_board);

    return res;
}

bool tictactoeBrain::getWozDance()
{
	bool res;
	pthread_mutex_lock(&_mutex_woz);
	res = woz_dance;
	pthread_mutex_unlock(&_mutex_woz);
	return res;
}

bool tictactoeBrain::getWozWave()
{
	bool res;
	pthread_mutex_lock(&_mutex_woz);
	res = woz_wave;
	pthread_mutex_unlock(&_mutex_woz);
	return res;
}

bool tictactoeBrain::getWozGiggle()
{
	bool res;
	pthread_mutex_lock(&_mutex_woz);
	res = woz_giggle;
	pthread_mutex_unlock(&_mutex_woz);
	return res;
}

bool tictactoeBrain::getWozCheat()
{
	bool res;
	pthread_mutex_lock(&_mutex_woz);
	res = woz_cheat;
	pthread_mutex_unlock(&_mutex_woz);
	return res;
}

void tictactoeBrain::setWozCheat(bool st)
{
	pthread_mutex_lock(&_mutex_woz);
	woz_cheat = st;
	pthread_mutex_unlock(&_mutex_woz);
}

void tictactoeBrain::setWozWave(bool st)
{
	pthread_mutex_lock(&_mutex_woz);
	woz_wave= st;
	pthread_mutex_unlock(&_mutex_woz);
}

void tictactoeBrain::publishTTTBrainState(const ros::TimerEvent&)
{
    pthread_mutex_lock(&_mutex_brain);
    tttBrain_pub.publish(s);
    pthread_mutex_unlock(&_mutex_brain);
    //ROS_INFO("--------------------Current brain state %d --------------------", s.state);
}

void tictactoeBrain::invitationCB(const ros::TimerEvent&)
{
	// Due to the limitation of the sound_play package, it's not possible
	// to know is the sound card busy or not.
	// Simply say something and block long enough to avoid overlapping.
	if(getBrainState() == TTTBrainState::READY)
	{
		saySentence("Random", 3);
	}
	else
	{
		// Stop timer
		invitation_timer.stop();
	}
}

void tictactoeBrain::pubWozSt(const ros::TimerEvent&)
{
	baxter_collaboration_msgs::WOZ msg;
	pthread_mutex_lock(&_mutex_woz);
	msg.dance = woz_dance;
	msg.wave = woz_wave;
	msg.giggle = woz_giggle;
	msg.cheat = woz_cheat;
	pthread_mutex_unlock(&_mutex_woz);
	woz_st_pub.publish(msg);
	//ROS_INFO("publish WOZ state dance is %s", msg.dance ? "true":"false");
	//ROS_INFO("publish internal WOZ state dance is %s", getWozDance() ? "true":"false");
}

int tictactoeBrain::getBrainState()
{
    int state;
    pthread_mutex_lock(&_mutex_brain);
    state = s.state;
    pthread_mutex_unlock(&_mutex_brain);

    return state;
}

void tictactoeBrain::setBrainState(int state)
{
    if (state != getBrainState())
    {
        pthread_mutex_lock(&_mutex_brain);
        s.state = state;
        pthread_mutex_unlock(&_mutex_brain);
        ROS_WARN("New state [%i]", state);
    }

    if (state == TTTBrainState::GAME_FINISHED)
    {
        _is_board_detected = false;
    }
}

void tictactoeBrain::boardStateCb(const baxter_tictactoe::MsgBoard &msg)
{
	if(getBrainState() == TTTBrainState::GAME_FINISHED) return;

    ROS_DEBUG("New TTT board state received");
    pthread_mutex_lock(&mutex_curr_board);
    curr_board.fromMsgBoard(msg);
    pthread_mutex_unlock(&mutex_curr_board);
    _is_board_detected = true;
}

void tictactoeBrain::wozCmdCb(const baxter_collaboration_msgs::WOZ &msg)
{
	ROS_INFO("New WOZ client command received. ");
	pthread_mutex_lock(&_mutex_woz);
	woz_dance = msg.dance ? true : false;
	woz_wave = msg.wave ? true : false;
	woz_giggle= msg.giggle ? true : false;
	woz_cheat = msg.cheat ? true : false;
	pthread_mutex_unlock(&_mutex_woz);

	//ROS_INFO("receive WOZ state dance is %s", msg.dance ? "true":"false");
	//ROS_INFO("receiv internal WOZ state dance is %s", getWozDance() ? "true":"false");
}

int tictactoeBrain::randomStrategyMove()
{
    int r;
    Board aux = internal_board;
    do {
        r = rand() % NUMBER_OF_CELLS + 1; //random number between 1 and NUMBER_OF_CELLS
        ROS_DEBUG("Cell %d is in state %s ==? %s", r, aux.getCellState(r-1).c_str(),
                  MsgCell::EMPTY.c_str());
    }
    while(aux.getCellState(r-1)!=COL_EMPTY);

    ROS_WARN("Random move to cell # %i", r);
    return r;
}

int tictactoeBrain::cheatingStrategyMove()
{
    int next_cell_id=-1;
    if (  victoryMove(next_cell_id))    { return next_cell_id; }
    if ( cheatingMove(next_cell_id))    { return next_cell_id; }
    if (defensiveMove(next_cell_id))    { return next_cell_id; }
    return randomStrategyMove();
}

int tictactoeBrain::smartStrategyMove()
{
    int next_cell_id=-1;
    if (  victoryMove(next_cell_id))    { return next_cell_id; }
    if (defensiveMove(next_cell_id))    { return next_cell_id; }
    return randomStrategyMove();
}

bool tictactoeBrain::cheatingMove(int &cell_id)
{
    cell_id = -1;
    Board aux = internal_board;
    string cell_state = COL_EMPTY;

    for (size_t i = 0; i < aux.getNumCells(); ++i)
    {
        if (aux.getCellState(i)==getOpponentColor())
        {
            cell_state=aux.getCellState(i);
            aux.setCellState(i, getRobotColor());
            if (aux.threeInARow(getRobotColor()))
            {
                ROS_WARN("Cheating move to cell # %lu", i+1);
                has_cheated=true;
                cell_id = i+1;
                // If the robot cheats, the number of tokens expected from the humans decreases.
                --n_human_tokens;
                return true;
            }
            aux.setCellState(i, cell_state);
        }
    }

    // ROS_WARN("Cheating move not successful!");
    return false;
}

bool tictactoeBrain::defensiveMove(int &cell_id)
{
    cell_id = -1;
    Board aux = internal_board;
    string cell_state = COL_EMPTY;

    for (size_t i = 0; i < aux.getNumCells(); ++i)
    {
        if (aux.getCellState(i)==COL_EMPTY)
        {
            cell_state = aux.getCellState(i);
            aux.setCellState(i, getOpponentColor());
            if (aux.threeInARow(getOpponentColor()))
            {
                ROS_WARN("Defensive move to cell # %lu", i+1);
                cell_id = i+1;
                return true;
            }
            aux.setCellState(i, cell_state);
        }
    }

    // ROS_INFO("DefensiveMove not successful!");
    return false;
}

bool tictactoeBrain::victoryMove(int &cell_id)
{
    cell_id = -1;
    Board aux = internal_board;
    string cell_state = COL_EMPTY;

    for (size_t i = 0; i < aux.getNumCells(); ++i)
    {
        if (aux.getCellState(i)==COL_EMPTY)
        {
            cell_state = aux.getCellState(i);
            aux.setCellState(i, getRobotColor());
            if (aux.threeInARow(getRobotColor()))
            {
                ROS_WARN("Victory move to cell # %lu", i+1);
                cell_id = i+1;
                return true;
            }
            aux.setCellState(i, cell_state);
        }
    }

    // ROS_INFO("VictoryMove not successful!");
    return false;
}

int tictactoeBrain::getNextMove()
{
    return (this->*_choose_next_move)();
}

unsigned short int tictactoeBrain::getWinner()
{
    if (internal_board.threeInARow(getRobotColor()))      { return WIN_ROBOT; }
    if (internal_board.threeInARow(getOpponentColor()))   { return   WIN_OPP; }

    return WIN_NONE;
}

void tictactoeBrain::waitForOpponentTurn(const size_t& n_robot_tokens)
{
    ROS_INFO("Waiting for the participant's move. "
             "I am expecting %lu token%s from myself and %lu token%s from my opponent",
             n_robot_tokens, n_robot_tokens==1?"":"s",
             n_human_tokens+1, n_human_tokens==1?"":"s");

    int cnt = 0;
    bool say_it_is_your_turn = true;

    // We wait until the number of opponent's tokens equals the robots'
    while(ros::ok())
    {
        Board new_board = getCurrBoard();

        if (internal_board.isOneTokenAdded(new_board, getOpponentColor()))
        {
            ++cnt;
        }
        else
        {
            if (say_it_is_your_turn == true)
            {
                saySentence("It is your turn", 0.1);
                say_it_is_your_turn = false;
            }

            cnt = 0;
        }

        if (cnt == 100)
        {
            internal_board = new_board;
            n_human_tokens = internal_board.getNumTokens(getOpponentColor());
            return;
        } // 100 means 1 second

        r.sleep();
    }
}

void tictactoeBrain::waitForOpponent2Start()
{
	ROS_INFO("Waiting for the first move from opponent to start the game.");
	int cnt = 0;

	// start invitation timer.
	invitation_timer.start();
	 // We wait until the first of opponent's tokens detected on board
	while(ros::ok())
	{
		Board new_board = getCurrBoard();

		if (internal_board.isOneTokenAdded(new_board, getOpponentColor()))
		{
			++cnt;
		}
		else
		{
			cnt = 0;
		}

		if (cnt == 100)
		{
			internal_board = new_board;
			n_human_tokens = internal_board.getNumTokens(getOpponentColor());
			robot_turn = true;
			return;
		} // 100 means 1 second

		if(getWozWave())
		{
			ROS_INFO("start waving..");
			playGesture(TTTController::wave);
			// Play wave once only.
			setWozWave(false);
		}

		r.sleep();
	}
}

void tictactoeBrain::saySentence(std::string sentence, double t)
{
    ROS_INFO("saySentence: %s", sentence.c_str());
    _voice_synthesizer.say(sentence, _voice_type);
    ros::Duration(t).sleep();
}

void tictactoeBrain::setStrategy(std::string strategy)
{
    if (strategy=="random")
    {
        _choose_next_move=&tictactoeBrain::randomStrategyMove;
        ROS_INFO("[strategy] Randomly place tokens");
    }
    else if (strategy=="smart")
    {
        _choose_next_move=&tictactoeBrain::smartStrategyMove;
        ROS_INFO("[strategy] Try to win without cheating");
    }
    else if (strategy=="cheating")
    {
        _choose_next_move=&tictactoeBrain::cheatingStrategyMove;
        ROS_INFO("[strategy] Try to win by cheating");
    }
    else
    {
        ROS_ERROR("%s is not an available strategy", strategy.c_str());
    }
}

void tictactoeBrain::pubAnimation(std::string emotion)
{
    std_msgs::String msg; 
    msg.data = emotion;
    ROS_INFO("Change emtion to : %s", emotion.c_str());
    animator_pub.publish(msg);
}



void tictactoeBrain::playGesture(TTTController::gesture_t gid)
{
	leftArmCtrl.startAction(ACTION_GESTURE, gid, false);
	rightArmCtrl.startAction(ACTION_GESTURE, gid, false);

	leftArmCtrl.joinAction();
	rightArmCtrl.joinAction();
}

int tictactoeBrain::getNextRobotTile(baxter_tictactoe::Board & board)
{
	for(uint i = 0; i < board.getNumCells(); i++ )
	{
		if(board.getCellState(i) == COL_BLUE)
		{
			// Found blue tile in current board, check internal board
			if(internal_board.getCellState(i) != COL_BLUE)
			{
				// Conflict
				ROS_WARN("internal cell %d contains no blue tile but it's detected by camera.", i+1);
			}
			// remove the tile from the board snapshot and return the id.
			board.setCellState(i, COL_EMPTY);
			return i+1;
		}
	}
	return -1;
}

void tictactoeBrain::cleanBoard()
{
	int token_id;
	size_t cellNum = internal_board.getNumCells();
	// take a snapshot of the current board
	baxter_tictactoe::Board catched_board = getCurrBoard();

	// get the cell number of blue piece
	while((token_id = getNextRobotTile(catched_board)) != -1 &&
		   highest_empty_pool > 0)
	{
		//pick up the tile from cell
		ROS_INFO("Cleaning board, pickup from cell %d", token_id);
		rightArmCtrl.startAction(ACTION_PICKUP, token_id);
		//place the tiles back
		ROS_INFO("Cleaning board, drop tile to pool %d", highest_empty_pool);
		rightArmCtrl.startAction(ACTION_PUTDOWN, highest_empty_pool + cellNum);
		highest_empty_pool--;
	}

	// wait until the board is cleaned and keep cleaned for 2 seconds
	int empty_timer = 0;
	ros::Rate rate(10);
	while(ros::ok() && empty_timer < 20)
	{
		if (getCurrBoard().isEmpty()) empty_timer++;
		else empty_timer = 0;
	}
}

tictactoeBrain::~tictactoeBrain()
{
    pthread_mutex_destroy(&_mutex_brain);
    pthread_mutex_destroy(&mutex_curr_board);
    pthread_mutex_destroy(&_mutex_woz);
    brainstate_timer.stop();
    //invitation_timer.stop();
    woz_timer.stop();
}
