//
//  Constant.h
//  ChessGame
//
//  Created by CoodyChou on 12/10/24.
//
//

#ifndef ChessGame_Constant_h
#define ChessGame_Constant_h

#define CHANGE_SCENE_TIME 0.7f
#define NOT_TOUCH_ANY_OBJECT -1

#define MOVE_ACTION_TIME 0.4f
#define SELECT_ACTION_TIME 0.4f


typedef enum{
	ChessColorBlack = 1,
	ChessColorRed = 0,
	ChessColorUnknown = -1
}ChessColorEnum;

typedef enum{
	ChineseChessERROR = 0,
	/* red is even , black is red */
	ChineseChessSoldierB = 1, /* have 5 solders */
	ChineseChessSoldierR = 2,
	
	ChineseChessCannonB = 3,  /* have two , 3 and 4 is 炮 */
	ChineseChessCannonR = 4,
	ChineseChessHorseB = 5,
	ChineseChessHorseR = 6,
	ChineseChessChariotB = 7,
	ChineseChessChariotR = 8,
	ChineseChessElephantB = 9,
	ChineseChessElephantR = 10,
	ChineseChessAdvisorB = 11,
	ChineseChessAdvisorR = 12,
	
	ChineseChessGeneralB = 13, /* ony one General */
	ChineseChessGeneralR = 14
}ChineseChessType;

typedef enum{
	SceneINIT = 0,
	SceneStart = 1,
	SceneChineseChess = 2,
	SceneChineseSmallChess = 3,
	SceneOriginalChess =4,
    SceneRoomScene = 5
}SceneTypes;

typedef enum{
	ZOrderMenuLayer = 100,
	ZOrderBackground = 1,
	ZOrderChess = 20,
	ZOrderChessMoving = 25
}GameZOrder;

typedef enum{
    EnumLobbyStateErrorDisconnect = -1,
    EnumLobbyStateLogin = 0,
    EnumLobbyStateResult0 = 1,  //成功
    EnumLobbyStateResult1 = 2,  //失敗、但是有人想和你玩遊戲，請傳送是否接受玩遊戲
    EnumLobbyStateResult2 = 3,  //失敗、且拒絕遊戲（或是被對方拒絕遊戲），請重新整理完家列表！
    EnumLobbyStateStartGame = 4, //開始遊戲
    EnumLobbySomeoneLoginIn = 5, //有玩家登入！
    EnumStartMatch = 6,
    EnumCloseStream = 7
}EnumLobbyState;

#endif
