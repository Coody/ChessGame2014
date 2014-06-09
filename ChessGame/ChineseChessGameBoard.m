//
//  ChineseChessGameBoard.m
//  ChessGame
//
//  Created by CoodyChou on 12/10/31.
//
//

#import "ChineseChessGameBoard.h"

@implementation ChineseChessGameBoard
-(id)init{
	self = [super init];
	if (self != nil) {
		background = [CCSprite spriteWithFile:@"ChineseChessGameBackground.png"];
		[self addChild:background z:1];
		[background setPosition:ccp(512	, 384)];
	}
	return self;
}
@end
