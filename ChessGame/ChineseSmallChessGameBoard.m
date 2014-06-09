//
//  ChineseSmallChessGameBoard.m
//  ChessGame
//
//  Created by CoodyChou on 12/10/26.
//
//

#import "ChineseSmallChessGameBoard.h"

@implementation ChineseSmallChessGameBoard

-(id)init{
	self = [super init];
	if (self != nil) {
		background = [CCSprite spriteWithFile:@"ChineseSmallChessGameBoard.png"];
		[self addChild:background z:0];
		[background setPosition:ccp(500	, 260)];
	}
	return self;
}

@end
