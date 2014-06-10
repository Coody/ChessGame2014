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
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCSprite *back = [CCSprite spriteWithFile:@"black2.png"];
        [self addChild:back];
        [back setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
        self.isTouchEnabled = YES;
        alertView = [[UIAlertView alloc] initWithTitle:@"歡迎光臨屯門遊樂局！\n請輸入帳號密碼" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登入", nil];
        alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [alertView show];
		CCMenuItemFont *ChineseSmallChessButton = [CCMenuItemFont itemFromString:@"暗棋" target:self selector:@selector(runRoomScene)];
//		CCMenuItemFont *ChineseChessButton = [CCMenuItemFont itemFromString:@"象棋" target:self selector:@selector(runChineseChessGame)];
		//CCMenuItemFont *OriginalChessButton = [CCMenuItemFont itemFromString:@"五子棋" target:self selector:@selector(test)];
		[ChineseSmallChessButton setColor:ccRED];
		[ChineseSmallChessButton setScale:1.7f];
//		[ChineseChessButton setColor:ccBLACK];
//		[ChineseChessButton setScale:1.7f];
//		[OriginalChessButton setColor:ccBLACK];
//		[OriginalChessButton setScale:1.7f];
		mainMenu = [CCMenu menuWithItems:ChineseSmallChessButton, nil];
//		[mainMenu alignItemsVerticallyWithPadding:screenSize.width*0.02f];
		[mainMenu setPosition:ccp(screenSize.width * 0.5f , screenSize.height * 0.5)];
		[self addChild:mainMenu z:ZOrderMenuLayer];
		//id delay = [CCDelayTime actionWithDuration:4];
		//[self runAction: delay];
        
		CCLOG(@"OK!!!!!");
	}
	return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            CCLOG(@"使用者取消輸入");
            break;
        case 1:{
            UITextField *uidTextField = [alertView textFieldAtIndex:0];
            UITextField *pwdTextField = [alertView textFieldAtIndex:1];
            [GameManager sharedGameManager].name = [NSString stringWithString:uidTextField.text];
            [GameManager sharedGameManager].passwd = [NSString stringWithFormat:pwdTextField.text];
            NSLog(@"name = %@" , [GameManager sharedGameManager].name);
            CCLOG(@"passwd = %@" , [GameManager sharedGameManager].passwd);
        }
            break;
        default:
            break;
    }
}

-(void)runRoomScene{
    [[GameManager sharedGameManager] loginButton];
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

@end
