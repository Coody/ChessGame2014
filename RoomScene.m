//
//  RoomScene.m
//  ChessGame
//
//  Created by Coody0829 on 2014/6/4.
//
//

#import "RoomScene.h"

@implementation RoomScene

-(id)init{
    self = [super init];
    if (self != nil) {
        roomLayer = [RoomLayer node];
        [self addChild:roomLayer];
    }
    return self;
}

@end
