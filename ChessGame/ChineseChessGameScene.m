//
//  ChineseChessGameScene.m
//  ChessGame
//
//  Created by CoodyChou on 12/10/31.
//
//

#import "ChineseChessGameScene.h"

@implementation ChineseChessGameScene

-(id)init{
	self = [super init];
	if (self != nil) {
		chineseChessGameLayer = [ChineseChessGameLayer node];
		[self addChild:chineseChessGameLayer];
	}
	return self;
}

@end
