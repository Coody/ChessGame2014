//
//  GameBoard.h
//  ChessGame
//
//  Created by CoodyChou on 12/10/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameBoardDelegate.h"
#import "cocos2d.h"

@interface GameBoard : CCNode {
	CCArray *boardArray;
	CCSprite *noteSprite;
	id <GameBoardDelegate> delegate;
}

@property (nonatomic , assign) id delegate;
@property (nonatomic , assign) CCArray *boardArray;
@property (nonatomic , assign) CCSprite *noteSprite;

-(void)createAllChess;
-(void)initialChessPosition;

@end
