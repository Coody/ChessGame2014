//
//  RoomLayer.h
//  ChessGame
//
//  Created by Coody0829 on 2014/6/4.
//
//

#import "cocos2d.h"
#import "ShowPlayerDelegate.h"
#import "PlayerState.h"

@interface RoomLayer : CCLayer <NSStreamDelegate , ShowPlayerDelegate>{
    NSOutputStream *oStream;
    NSInputStream *iStream;
    
    NSMutableArray *showPlayerArray;
    
    NSString *testtest;
    
    CCMenu *askMenu;
    CCLabelTTF *showNameAndID;
    CCMenu *closeStreamMenu;
    
    PlayerState *state;
}

@end
