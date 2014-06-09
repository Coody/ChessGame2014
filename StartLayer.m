//
//  StartLayer.m
//  ChessGame
//
//  Created by CoodyChou on 12/10/24.
//
//

#import "StartLayer.h"
#import "GameManager.h"

@interface StartLayer ()
-(void)runRoomScene;
-(void)runChineseSmallChessGame;
-(void)runChineseChessGame;
-(void)runOriginalChessGame;
-(void)runChineseSmallChessGame;
@end
@implementation StartLayer

-(id)init{
	self = [super init];
	if (self != nil) {
        self.isTouchEnabled = YES;
		CGSize screenSize = [CCDirector sharedDirector].winSize;
        tempBack = [CCSprite spriteWithFile:@"black2.png"];
		CCSprite *background = [CCSprite spriteWithFile:@"black.png"];
		CCMenuItemFont *ChineseSmallChessButton = [CCMenuItemFont itemFromString:@"暗棋" target:self selector:@selector(runRoomScene)];
//		CCMenuItemFont *ChineseChessButton = [CCMenuItemFont itemFromString:@"象棋" target:self selector:@selector(runChineseChessGame)];
		//CCMenuItemFont *OriginalChessButton = [CCMenuItemFont itemFromString:@"五子棋" target:self selector:@selector(test)];
		[ChineseSmallChessButton setColor:ccBLACK];
		[ChineseSmallChessButton setScale:1.7f];
//		[ChineseChessButton setColor:ccBLACK];
//		[ChineseChessButton setScale:1.7f];
//		[OriginalChessButton setColor:ccBLACK];
//		[OriginalChessButton setScale:1.7f];
		mainMenu = [CCMenu menuWithItems:ChineseSmallChessButton, nil];
//		[mainMenu alignItemsVerticallyWithPadding:screenSize.width*0.02f];
		[mainMenu setPosition:ccp(screenSize.width * 0.5f , screenSize.height * 0.5)];
        [self addChild:tempBack z:10000];
        [tempBack setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
		[self addChild:mainMenu z:ZOrderMenuLayer];
		[self addChild:background z:ZOrderBackground];
		[background setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
		//id delay = [CCDelayTime actionWithDuration:4];
		//[self runAction: delay];
        
		CCLOG(@"OK!!!!!");
	}
	return self;
}

-(void)runRoomScene{
    
    [[GameManager sharedGameManager] testListen];
    [[GameManager sharedGameManager] runSceneWithID:SceneRoomScene];
}

-(void)runChineseSmallChessGame{
    //[[GameManager sharedGameManager] loginButton];
	[[GameManager sharedGameManager] runSceneWithID:SceneChineseSmallChess];
}

-(void)runChineseChessGame{
	[[GameManager sharedGameManager]runSceneWithID:SceneChineseChess];
}

-(void)runOriginalChessGame{
	[[GameManager sharedGameManager]runSceneWithID:SceneOriginalChess];
}

-(void)test{
	CCLOG(@"test");
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.isTouchEnabled = NO;
    [tempBack removeFromParentAndCleanup:YES];
    [[GameManager sharedGameManager] loginButton];
}

@end
