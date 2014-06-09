//
//  PlayerState.h
//  ChessGame
//
//  Created by Coody0829 on 2014/6/7.
//
//

#import "CCLabelTTF.h"
#import "Constant.h"

@interface PlayerState : CCLabelTTF{
    EnumLobbyState recentState;
}

-(id)init;
-(void)showState;
-(void)changeState:(EnumLobbyState)tempState;

@end
