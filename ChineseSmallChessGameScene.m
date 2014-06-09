//
//  ChineseSmallChessGameScene.m
//  ChessGame
//
//  Created by CoodyChou on 12/10/24.
//
//

#import "ChineseSmallChessGameScene.h"

@implementation ChineseSmallChessGameScene

-(id)init{
	self = [super init];
	if (self != nil) {
		chineseSmallChessGameLayer = [[[ChineseSmallChessGameLayer alloc]initWithPlaySequence:[GameManager sharedGameManager].firstOrNot] autorelease];
		[self addChild:chineseSmallChessGameLayer];
	}
	return self;
}

@end
