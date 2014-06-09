//
//  OriginalChessGameScene.m
//  ChessGame
//
//  Created by CoodyChou on 12/10/31.
//
//

#import "OriginalChessGameScene.h"

@implementation OriginalChessGameScene

-(id)init{
	self = [super init];
	if (self != nil) {
		originalChessGameLayer = [OriginalChessGameLayer node];
		[self addChild:originalChessGameLayer];
	}
	return self;
}

@end
