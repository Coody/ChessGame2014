//
//  PlayerState.m
//  ChessGame
//
//  Created by Coody0829 on 2014/6/7.
//
//

#import "PlayerState.h"
#include "GameManager.h"

@implementation PlayerState

-(id)init{
    self = [super initWithString:@"test" fontName:@"Helvetica-Bold" fontSize:20];
    if ( self != nil ) {
        recentState = EnumLobbyStateErrorDisconnect;
        [self setColor:ccBLACK];
        [self changeState:recentState];
    }
    return self;
}

-(void)showState{
    id fadeInAction = [CCFadeIn actionWithDuration:1.0f];
    id delaytimeAction = [CCDelayTime actionWithDuration:1.0f];
    id fadeOutAction = [CCFadeOut actionWithDuration:1.0f];
    id allFadeInOutAction = [CCSequence actions:fadeInAction,delaytimeAction,fadeOutAction, nil];
    [self runAction:allFadeInOutAction];
}

-(void)changeState:(EnumLobbyState)tempState{
    NSString *tempStateString ;
    switch ( tempState ) {
        case EnumLobbyStateErrorDisconnect:
            tempStateString = @"[System Error!!]";
            break;
        case EnumLobbyStateLogin:
            tempStateString = @"[Login...]";
            break;
        case EnumLobbyStateResult0:
            tempStateString = @"[Match Success(1)!!]";
            break;
        case EnumLobbyStateResult1:
            tempStateString = @"[Someone invite!!]";
            break;
        case EnumLobbyStateResult2:
            tempStateString = @"[Fail and recreate room..]";
            break;
        case EnumLobbyStateStartGame:
            tempStateString = @"[Match Success(2)!!]";
            break;
        case EnumLobbySomeoneLoginIn:
            tempStateString = @"[Wait for player...]";
            break;
        case EnumStartMatch:
            tempStateString = @"[Start Matching...]";
            break;
        case EnumCloseStream:
            tempStateString = @"[Close Socket...]";
            break;
        default:
            tempStateString = @"[Program shouldn't run here!!]";
            break;
    }
    recentState = tempState;
    [self setString:tempStateString];
    [self showState];
}

@end
