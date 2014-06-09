//
//  ShowPlayer.h
//  ChessGame
//
//  Created by Coody0829 on 2014/6/4.
//
//

#import "cocos2d.h"
#import "ShowPlayerDelegate.h"


@interface ShowPlayer : CCSprite{
    NSString *ID;
    NSString *name;
    CCMenu *chooseMainButton;
    id <ShowPlayerDelegate> delegate;
}

@property (nonatomic , assign) id delegate;

-(id)initWithID:(NSString *)tempID withName:(NSString *)tempName;

@end
