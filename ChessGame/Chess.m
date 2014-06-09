//
//  Chess.m
//  ChessGame
//
//  Created by CoodyChou on 12/10/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Chess.h"
#import "Constant.h"

@implementation Chess
@synthesize delegate;
@synthesize canMoveOrNot;
@synthesize gameBoardPosition;

-(id)initWithFile:(NSString *)filename{
	self = [super initWithFile:filename];
	if (self != nil) {
		canMoveOrNot = NO;
		gameBoardPosition = -1;
	}
	return self;
}

-(void)selectedAction{
	id becomeBigAction = [CCScaleTo actionWithDuration:SELECT_ACTION_TIME scale:0.92f];
	id becomeSmallAction = [CCScaleTo actionWithDuration:SELECT_ACTION_TIME scale:0.8f];
	id allAction = [CCSequence actionOne:becomeBigAction two:becomeSmallAction];
	id repeat = [CCRepeatForever actionWithAction:allAction];
	[self runAction:repeat];
}

-(void)moveAction{
	id bigAction = [CCScaleTo actionWithDuration:MOVE_ACTION_TIME*0.5 scale:1.2f];
	id smallAction = [CCScaleTo actionWithDuration:MOVE_ACTION_TIME*0.5 scale:0.8f];
	id allAction = [CCSequence actionOne:bigAction two:smallAction];
	[self runAction:allAction];
}

-(void)unSelectedAction{
	[self stopAllActions];
	[self setScale:0.8f];
}

@end
