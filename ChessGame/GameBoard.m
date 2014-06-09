//
//  GameBoard.m
//  ChessGame
//
//  Created by CoodyChou on 12/10/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameBoard.h"


@implementation GameBoard

@synthesize delegate;
@synthesize boardArray;
@synthesize noteSprite;

-(id)init{
	self = [super init];
	if (self != nil) {
		boardArray = [[CCArray alloc]init];
		noteSprite = [CCSprite spriteWithFile:@"NoteNothing.png"];
		[self addChild:noteSprite];
		[noteSprite setPosition:ccp(500, 532)];
		delegate = nil;
	}
	return self;
}

-(void)createAllChess{
	[delegate createChess];
}

-(void)initialChessPosition{
	[delegate setChessPosition];
}

@end
