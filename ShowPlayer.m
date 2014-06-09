//
//  ShowPlayer.m
//  ChessGame
//
//  Created by Coody0829 on 2014/6/4.
//
//

#import "ShowPlayer.h"
#import "GameManager.h"

@interface ShowPlayer()
-(void)sendInvite;
@end

@implementation ShowPlayer
@synthesize delegate;

-(id)initWithID:(NSString *)tempID withName:(NSString *)tempName{
    self = [super initWithFile:@"showPlayBackground.png"];
    if (self != nil) {
        ID = [NSString stringWithString:tempID];
        name = [NSString stringWithString:tempName];
        CCLabelTTF *idLabel = [CCLabelTTF labelWithString:ID fontName:@"Helvetica-Bold" fontSize:24];
        [idLabel setColor:ccRED];
        [self addChild:idLabel];
        [idLabel setPosition:ccp(130,190)];
        CCLabelTTF *nameLabel = [CCLabelTTF labelWithString:name fontName:@"Helvetica-Bold" fontSize:24];
        [nameLabel setColor:ccRED];
        [self addChild:nameLabel];
        [nameLabel setPosition:ccp(120, 95)];
        CCMenuItemFont *chooseButton = [CCMenuItemFont itemFromString:@"邀請與等待" target:self selector:@selector(sendInvite)];
        [chooseButton setFontName:@"Helvetica-Bold"];
        [chooseButton setFontSize:22];
        [chooseButton setColor:ccRED];
        chooseMainButton = [CCMenu menuWithItems:chooseButton, nil];
        [self addChild:chooseMainButton];
        [chooseMainButton setPosition:ccp(115, 50)];
        delegate = nil;
    }
    return self;
}

-(void)sendInvite{
    [delegate invitePlayer:name];
}

-(void)test{
    
}

@end
