//
//  StartScene.m
//  ChessGame
//
//  Created by CoodyChou on 12/10/24.
//
//

#import "StartScene.h"

@implementation StartScene

-(id)init{
	self = [super init];
	if (self != nil ) {
		startLayer = [StartLayer node];
		[self addChild:startLayer];
	}
	return self;
}

@end
