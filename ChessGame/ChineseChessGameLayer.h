//
//  ChineseChessGameLayer.h
//  ChessGame
//
//  Created by CoodyChou on 12/10/31.
//
//

#import "CCLayer.h"
#import "Player.h"
#import "ChineseChessGameBoard.h"
#import "GameBoardDelegate.h"
#import "ChessDelegate.h"

@interface ChineseChessGameLayer : CCLayerColor  <GameBoardDelegate , ChessDelegate>{
	ChineseChessGameBoard *gameBoard;
	Player *firstPlayer;
	Player *secondPlayer;
	int logicalGameBoard[9][10];
}

@end
