//
//  LoginScene.m
//  ChessGame
//
//  Created by coody0829 on 2014/5/6.
//
//

#import "LoginScene.h"

@implementation LoginScene

-(id)init{
    self = [super init];
    if (self != nil) {
        CCSprite *tempSprite = [CCSprite spriteWithFile:@"black.png"];
        [self addChild:tempSprite];
        [tempSprite setPosition:ccp(240, 160)];
    }
    return self;
}

@end
