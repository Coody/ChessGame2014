//
//  ChineseSmallChessGameLayer.h
//  ChessGame
//
//  Created by CoodyChou on 12/10/24.
//
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "cocos2d.h"
#import "GameBoardDelegate.h"
#import "ChineseSmallChessGameBoard.h"
#import "ChessDelegate.h"
#import "Player.h"
#import "GameManager.h"

@interface ChineseSmallChessGameLayer : CCLayer <GameBoardDelegate , ChessDelegate , NSStreamDelegate>{
	CCMenu *chineseSmallChessMenu;
	
	ChineseSmallChessGameBoard *gameBoard;
	CCSprite *background;
	Player *firstPlayer ;
	Player *secondPlayer;
	Player *recentPlayer;
	int logicalGameboard[4][8];
    
    NSOutputStream *oStream;
    NSInputStream *iStream;
    
    BOOL firstOrNot;
    BOOL firstStep;
    
    NSArray *messageArray;
    
    CCLabelTTF *whoIsPlaying;
}

-(id)initWithPlaySequence:(BOOL)tempFirstOrNot;

@end
