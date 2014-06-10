//
//  GameManager.m
//  ChessGame
//
//  Created by CoodyChou on 12/10/24.
//
//

#import "GameManager.h"
#import "cocos2d.h"
#import "StartScene.h"
#import "ChineseSmallChessGameScene.h"
#import "ChineseChessGameScene.h"
#import "RoomScene.h"

#define changePlayer 0

@implementation GameManager
static GameManager *_sharedGameManager = nil;

@synthesize isMusicOn;
@synthesize isSoundEffectOn;
@synthesize hasPlayerDied;
@synthesize inputString;
@synthesize outputString;
@synthesize token;
@synthesize firstOrNot;
@synthesize iStream;
@synthesize oStream;

@synthesize name;
@synthesize passwd;

+(GameManager *)sharedGameManager{
	@synchronized([GameManager class]){
		if ( !_sharedGameManager ) {
			[[self alloc]init];
		}return _sharedGameManager;
	}
	return nil;
}

+(id)alloc{
	@synchronized([GameManager class]){
		NSAssert( _sharedGameManager == nil , @"Attempted to allocate the second instance of the Game Manager singleton");
		_sharedGameManager = [super alloc];
		return _sharedGameManager;
	}
	return nil;
}

-(id)init{
	self = [super init];
	if ( self != nil ) {
		hasPlayerDied = NO;
		isMusicOn = YES;
		isSoundEffectOn = YES;
		currentScene = SceneINIT;
        token = NULL;
        inputString = NULL;
        firstOrNot = NULL;
        outputString = [[NSString alloc] init];
	}
	return self;
}

-(void)runSceneWithID:(SceneTypes)sceneID{
	SceneTypes oldScene = currentScene;
	currentScene = sceneID;
	id changeSceneAction = nil ;
	switch (sceneID) {
		case SceneStart:
			CCLOG(@"run Start Scene!!");
			changeSceneAction = [CCTransitionFade transitionWithDuration:CHANGE_SCENE_TIME*0.1 scene:[StartScene node]];
			break;
		case SceneChineseSmallChess:
			changeSceneAction = [CCTransitionFade transitionWithDuration:CHANGE_SCENE_TIME scene:[ChineseSmallChessGameScene node]];
			break;
		case SceneChineseChess:
			//changeSceneAction = [CCTransitionFade transitionWithDuration:CHANGE_SCENE_TIME scene:[ChineseChessGameScene node]];
            break;
        case SceneRoomScene:
            changeSceneAction = [CCTransitionFade transitionWithDuration:CHANGE_SCENE_TIME scene:[RoomScene node]];
            break;
		default:
			break;
	}
	if ( changeSceneAction == nil ) {
		currentScene = oldScene;
		CCLOG(@"run Start Scene!!2");
		return;
	}
	if ([[CCDirector sharedDirector] runningScene] == nil) {
		[[CCDirector sharedDirector] runWithScene:changeSceneAction];
		CCLOG(@"run Start Scene!!3");
	}
	else{
		CCLOG(@"test");
		[[CCDirector sharedDirector] replaceScene:changeSceneAction];
		CCLOG(@"run Start Scene!!4");
	}
}

#pragma mark -
#pragma mark Socket part


- (void)loginButton{
    // HTTP POST and request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    NSURL *connect = [[NSURL alloc] initWithString:@"https://fgc.heapthings.com/api/getToken"];
    NSString *username;
    NSString *password;
    username = name;
    password = passwd;
    
    NSString *gameID = @"coody";
    NSString *httpBodyString=[NSString stringWithFormat:@"username=%@&password=%@&gameID=%@", username,password, gameID];
    
    [request setURL:connect];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    //JSON -> Dictionary
    NSError *error=Nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error){
        NSLog(@"JSONObjectWithData error: %@", error);
    }
    else{
        for (NSString *str in dic)
        {
            NSLog(@"%@:%@",str,[dic objectForKey:str]);
        }
    }
    //check result
    int check = [[dic objectForKey:@"result"]intValue];
    if(check)
    {
        NSLog(@"result success");
        [GameManager sharedGameManager].token = [dic objectForKey:@"token"];
        CCLOG(@" outputString = %@" , outputString);
        CCLOG(@" token = %@" , [GameManager sharedGameManager].token);
        //sent token & userid
        //        connect = [NSURL URLWithString:@"https://fgc.heapthings.com/api/checkToken"];
        //        NSString *token = [dic objectForKey:@"token"];
        //        httpBodyString=[NSString stringWithFormat:@"username=%@&token=%@", username, token];
        //        data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSLog(@"temp = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        // XIB-> Storyboard
        //UIStoryboard *myViewController =[[UIStoryboard storyboardWithName:@"Storyboard" bundle:NULL]instantiateViewControllerWithIdentifier:@"loginPageViewController"];
        //[self.navigationController pushViewController:myViewController animated:YES];
    }
    else
    {
        NSLog(@"result fail");
    }
}

-(void)testListen{
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
    
    NSString *ip = @"fgc.heapthings.com";
    NSInteger port = 5566;
    
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef)ip, port, &readStream, &writeStream);
    
    if (readStream && writeStream) {
        CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        
        CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        
        iStream = (__bridge NSInputStream *)readStream;
        [iStream setDelegate:self];
        [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [iStream open];
        
        oStream = (__bridge NSOutputStream *)writeStream;
        [oStream setDelegate:self];
        [oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [oStream open];
        
        
        CCLOG(@"連線成功！！");
        //        inputString = [[NSMutableString alloc] initWithFormat:@"{\"token\":\"%@\",\"gameID\":\"Coody\"}",[GameManager sharedGameManager].token];
        //[inputString initWithFormat:@"{\"token\":\"%@\",\"gameID\":\"Coody\"}",[GameManager sharedGameManager].token];
        
    }
}

@end
