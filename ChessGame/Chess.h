//
//  Chess.h
//  ChessGame
//
//  Created by CoodyChou on 12/10/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ChessDelegate.h"

@interface Chess : CCSprite {
    BOOL canMoveOrNot;
	int gameBoardPosition;
	id <ChessDelegate> delegate;
}

@property (nonatomic,assign) id delegate;
@property (readwrite) BOOL canMoveOrNot;
@property (readwrite) int gameBoardPosition;
-(void)selectedAction;
-(void)moveAction;
-(void)unSelectedAction;

@end
