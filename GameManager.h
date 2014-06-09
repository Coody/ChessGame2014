//
//  GameManager.h
//  ChessGame
//
//  Created by CoodyChou on 12/10/24.
//
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "Player.h"

@interface GameManager : NSObject <NSStreamDelegate> {
	BOOL isMusicOn ;
	BOOL isSoundEffectOn;
	BOOL hasPlayerDied;
	SceneTypes currentScene;
    
    Player *getRecentPlayer;
    
    NSString *token;
    NSMutableString *inputString;
    NSString *outputString;
    
    BOOL firstOrNot;
    
    NSOutputStream *oStream;
    NSInputStream *iStream;
}

@property (readwrite) BOOL isMusicOn;
@property (readwrite) BOOL isSoundEffectOn;
@property (readwrite) BOOL hasPlayerDied;
@property (nonatomic,retain) NSString *token;
@property (nonatomic,retain) NSMutableString *inputString;
@property (nonatomic,retain) NSString *outputString;
@property (readwrite) BOOL firstOrNot;

@property (nonatomic,retain) NSOutputStream *oStream;;
@property (nonatomic,retain) NSInputStream *iStream;

+(GameManager *)sharedGameManager;
-(void)runSceneWithID:(SceneTypes)sceneID;

- (void)loginButton;
-(void)testListen;

@end
