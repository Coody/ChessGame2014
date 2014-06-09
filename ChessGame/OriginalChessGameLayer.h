//
//  OriginalChessGameLayer.h
//  ChessGame
//
//  Created by CoodyChou on 12/10/31.
//
//

#import "CCLayer.h"
#import "GameBoard.h"
#import "ChessDelegate.h"
#import "Player.h"

@interface OriginalChessGameLayer : CCLayerColor <GameBoardDelegate , ChessDelegate>{
	GameBoard *gameBoard;
	Player *firstPlayer;
	Player *secondPlayer;
	int logicalGameBoard[11][11];
}

@end
