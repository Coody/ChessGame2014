//
//  OriginalChessGameBoard.m
//  ChessGame
//
//  Created by CoodyChou on 12/10/31.
//
//

#import "OriginalChessGameBoard.h"

@implementation OriginalChessGameBoard

-(id)init{
	self = [super init];
	if (self != nil) {
		background = [CCSprite spriteWithFile:@"ChessLayerBackground.png"];
	}
	return self;
}

@end
