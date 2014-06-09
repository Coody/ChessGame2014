//
//  RoomLayer.m
//  ChessGame
//
//  Created by Coody0829 on 2014/6/4.
//
//

#import "RoomLayer.h"
#import "GameManager.h"
#import "ShowPlayer.h"

@interface RoomLayer()
-(void)sendFirstString;
-(void)showAllPlayerWithPlayerList:(NSData *)tempData;
-(void)acceptInviteOrNot:(NSData *)tempData;
-(void)pressAccept;
-(void)pressDeny;
-(void)startGameWithData:(NSData *)tempData;
-(void)matchPlayerWithData:(NSData *)tempData;
-(void)createRoom:(NSDictionary *)playerDic;

-(void)STUB_showAllPlayerWithPlayerList:(NSData *)tempData;

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode;
-(void)cleanAllRoom;
-(void)invitePlayer:(NSString *)tempID;
-(void)closeStream;
@end

@implementation RoomLayer

-(id)init{
    self = [super init];
    if ( self != nil) {
        iStream = [GameManager sharedGameManager].iStream;
        oStream = [GameManager sharedGameManager].oStream;
        iStream.delegate =self;
        oStream.delegate = self;
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"遊  戲  大  廳" fontName:@"Helvetica-Bold" fontSize:48];
        [self addChild:title z:10000];
        [title setPosition:ccp(screenSize.width*0.5, screenSize.height*0.95)];
        [title setColor:ccBLACK];
        CCSprite *background = [CCSprite spriteWithFile:@"ChessLayerBackground.png"];
        [self addChild:background];
        [background setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
        
        showPlayerArray = [[NSMutableArray alloc] init];
        state = [[PlayerState alloc] init];
        [self addChild:state];
        state.anchorPoint = ccp(0, 0.5);
        [state setPosition:ccp(screenSize.width*0.645, screenSize.height*0.94)];
        [self sendFirstString];
        
        CCMenuItemFont *closeStreamMenuButton = [CCMenuItemFont itemFromString:@"[close socket]" target:self selector:@selector(closeStream)];
        [closeStreamMenuButton setFontName:@"Helvetica-Bold"];
        [closeStreamMenuButton setFontSize:20];
        closeStreamMenu = [CCMenu menuWithItems:closeStreamMenuButton, nil];
        [self addChild:closeStreamMenu];
        [closeStreamMenu setColor:ccBLACK];
        [closeStreamMenu setPosition:ccp(screenSize.width*0.71, screenSize.height*0.967)];
        // You may also want to make your rect = [[UIScreen mainScreen] applicationFrame]
        
    }
    return self;
}

//-(BOOL)testListen{
//    CFReadStreamRef readStream = NULL;
//    CFWriteStreamRef writeStream = NULL;
//    
//    BOOL checkListen = NO;
//    
//    NSString *ip = @"fgc.heapthings.com";
//    NSInteger port = 5566;
//    
//    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef)ip, port, &readStream, &writeStream);
//    
//    if (readStream && writeStream) {
//        CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
//        CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
//        
//        CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
//        CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
//        
//        iStream = (__bridge NSInputStream *)readStream;
//        [iStream setDelegate:self];
//        [iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//        [iStream open];
//        
//        oStream = (__bridge NSOutputStream *)writeStream;
//        [oStream setDelegate:self];
//        [oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//        [oStream open];
//        
//        checkListen = YES;
//        
//        CCLOG(@"連線成功！！");
//        [state changeState:EnumLobbyStateLogin];
//        //        inputString = [[NSMutableString alloc] initWithFormat:@"{\"token\":\"%@\",\"gameID\":\"coody\"}",[GameManager sharedGameManager].token];
//        //[inputString initWithFormat:@"{\"token\":\"%@\",\"gameID\":\"coody\"}",[GameManager sharedGameManager].token];
//        
//    }
//    else{
//        checkListen = NO;
//        [state changeState:EnumLobbyStateErrorDisconnect];
//    }
//    return checkListen;
//}

-(void)sendFirstString{
    NSString *str = [NSString stringWithFormat:@"{\"token\":\"%@\",\"gameID\":\"coody\"}\n",[GameManager sharedGameManager].token];
    //NSString *str = @"{\"token\":\"12312312314\",\"gameID\":\"Coody\"}\n";
    //NSString *str = [[NSString alloc] initWithString:@"{\"token\":\"12312312314\",\"gameID\":\"coody\"}"];
    const uint8_t *nuit8Text;
    nuit8Text = (uint8_t *)[str cStringUsingEncoding:NSASCIIStringEncoding];
    NSUInteger buffLen = strlen((char *)nuit8Text);
    NSInteger writtenLength = [oStream write:nuit8Text maxLength:buffLen];
    CCLOG(@"str = %@ (%lu)" ,str,(unsigned long)buffLen);
    
    if (writtenLength != buffLen) {
        [NSException raise:@"WriteFailure" format:@""];
    }
}

-(void)showAllPlayerWithPlayerList:(NSData *)tempData{
    
    NSError *error;
    NSDictionary *playerListDic = [NSJSONSerialization JSONObjectWithData:tempData options:NSJSONReadingMutableLeaves error:&error];
    BOOL checkState = [[playerListDic objectForKey:@"result"] boolValue];
    NSDictionary *playerListInfo;
    CCLOG(@" java's boolean = %c" , checkState);
    if ( checkState ) {
        playerListInfo = [playerListDic objectForKey:@"list"];
        if ( [playerListInfo isKindOfClass:[NSNull class]] ) {
            CCLOG(@"沒人在線上！！");
            /*
             此處請寫無人在線上的標語，並且要移除所有圖案。
             */
        }
        else{
            //CCLOG(@"playerListInfo = %@" , playerListInfo);
            [self createRoom:playerListInfo];
        }
    }
    else{
        CCLOG(@"Error message from server!");
    }
}

-(void)acceptInviteOrNot:(NSData *)tempData{
    NSError *error;
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:tempData
                                                              options:NSJSONReadingMutableLeaves
                                                                error:&error];
    NSString *resultID = [resultDic objectForKey:@"resultID"];
    NSString *inviteID = [resultDic objectForKey:@"id"];
    CCLOG(@"Receive ID & resultID = %@ (should be 1)" , resultID);
    NSString *inviteIDAndString = [NSString stringWithFormat:@"玩家 %@ 邀請你玩遊戲！",inviteID];
    showNameAndID = [CCLabelTTF labelWithString:inviteIDAndString fontName:@"Helvetica-Bold" fontSize:22];
    [showNameAndID setColor:ccBLACK];
    [self addChild:showNameAndID];
    CCMenuItemFont *acceptButton = [CCMenuItemFont itemFromString:@"接受" target:self selector:@selector(pressAccept)];
    CCMenuItemFont *denyButton = [CCMenuItemFont itemFromString:@"拒絕" target:self selector:@selector(pressDeny)];
    [acceptButton setColor:ccBLUE];
    [denyButton setColor:ccRED];
    askMenu = [CCMenu menuWithItems:acceptButton , denyButton, nil];
    [askMenu alignItemsHorizontallyWithPadding:20];
    [self addChild:askMenu];
    [showNameAndID setPosition:ccp(512, 420)];
    [askMenu setPosition:ccp(512, 384)];
    [state changeState:EnumLobbyStateResult1];
}

-(void)pressAccept{
    NSString *acceptBool = @"true";
    NSString *acceptString = [NSString stringWithFormat:@"{\"accept\":%@}\n",acceptBool];
    CCLOG(@" send accept: %@" , acceptString);
    const uint8_t *nuit8Text;
    nuit8Text = (uint8_t *)[acceptString cStringUsingEncoding:NSASCIIStringEncoding];
    NSInteger buffLen = strlen((char *)nuit8Text);
    NSInteger writtenLength = [oStream write:nuit8Text maxLength:buffLen];
    if (writtenLength != buffLen) {
        [NSException raise:@"WriteFailure" format:@""];
    }
    
    
}

-(void)pressDeny{
    NSString *denyBool = @"false";
    NSString *denyString = [NSString stringWithFormat:@"{\"accept\":%@}\n",denyBool];
    const uint8_t *nuit8Text;
    nuit8Text = (uint8_t *)[denyString cStringUsingEncoding:NSASCIIStringEncoding];
    NSInteger buffLen = strlen((char *)nuit8Text);
    NSInteger writtenLength = [oStream write:nuit8Text maxLength:buffLen];
    if (writtenLength != buffLen) {
        [NSException raise:@"WriteFailure" format:@""];
    }
    [self cleanAllAcceptMessage];
    [self cleanAllRoom];
}

-(void)cleanAllAcceptMessage{
    [showNameAndID removeFromParentAndCleanup:YES];
    [askMenu removeFromParentAndCleanup:YES];
}

-(void)startGameWithData:(NSData *)tempData{
    NSError *error;
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:tempData
                                                              options:NSJSONReadingMutableLeaves
                                                                error:&error];
    NSString *playerID = [resultDic objectForKey:@"id"];
    BOOL firstPlay = [[resultDic objectForKey:@"whoFirst"] boolValue];
    CCLOG(@"start Game = %@" , resultDic);
    CCLOG(@"ID = %@",playerID);
    CCLOG(@"firstPlay = %d" , firstPlay);
    [GameManager sharedGameManager].firstOrNot = firstPlay;
    [[GameManager sharedGameManager] runSceneWithID:SceneChineseSmallChess];
}

-(void)matchPlayerWithData:(NSData *)tempData{
    NSError *error;
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:tempData options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *playerListInfo;
    NSString *checkResultID = [resultDic objectForKey:@"resultID"];
    int resultIDNumber = [checkResultID intValue];
    CCLOG(@"配對！！ checkResultID = %d" , resultIDNumber);
    switch (resultIDNumber) {
        case 0:{
            /*
             遊戲開始，會先接收玩家的 ID 以及誰先誰後
             */
            CCLOG(@"配對成功！！");
            //[self startGameWithData:tempData];
        }
            break;
        case 1:{
            /*
             接收到玩家挑戰，要回應是否要接受挑戰
             */
            [state changeState:EnumLobbyStateResult1];
            [self acceptInviteOrNot:tempData];
        }
            break;
        case 2:{
            /*
             重新繪製玩家列表！
             */
            CCLOG(@"playerListDic = %@" , resultDic);
            playerListInfo = [resultDic objectForKey:@"list"];
            CCLOG(@"playerListInfo = %@" , resultDic);
            if ( [playerListInfo isKindOfClass:[NSNull class]] ) {
                CCLOG(@"沒人在線上！！");
                /*
                 此處請寫無人在線上的標語，並且要移除所有圖案。
                 */
                [self cleanAllRoom];
                [state changeState:EnumLobbySomeoneLoginIn];
            }
            else{
                CCLOG(@"有人在線上！！");
                //CCLOG(@"playerListInfo = %@" , playerListInfo);
                [self createRoom:playerListInfo];
                [state changeState:EnumLobbyStateResult2];
            }
        }
            break;
        default:
            break;
    }
}

-(void)createRoom:(NSDictionary *)playerDic{
    int i = 0;
    for ( NSDictionary *showIDString in playerDic ) {
        CCLOG(@"showIDString = %@" , showIDString);
        ShowPlayer *tempPlayer = [[ShowPlayer alloc] initWithID:@"id" withName:[showIDString objectForKey:@"id"]];
        [self addChild:tempPlayer];
        [tempPlayer setPosition:ccp(125+12+(i%4)*250, 600 - (i/4)*250)];
        [showPlayerArray addObject:tempPlayer];
        tempPlayer.delegate = self;
        i++;
    }
    CCLOG(@"showPlayerArray = %@" , showPlayerArray);
    
}


-(void)test{}

//
//-(BOOL)checkPlayInList:(NSString *)tempName{
//    BOOL check = NO;
//    if (showPlayerArray == NULL) {
//        check = YES;
//    }
//    else{
//        for ( NSString *tempString in showPlayerArray ) {
//            if( [tempString isEqualToString:tempName] ){
//                check = YES;
//            }
//        }
//    }
//    return check;
//}

#pragma mark -
#pragma mark stub

-(void)STUB_showAllPlayerWithPlayerList:(NSData *)tempData{
//    NSString *tempString = @"{\"result\":true,\"list\":[{\"coody1\":\"coody111\",\"coody02\":\"coody222\",\"coody03\",\"coody3333\"}]}\n";
    NSDictionary *playerListDic = [NSDictionary dictionaryWithObjectsAndKeys:@"coody0829",@"Coody123",@"test001",@"test1",@"test002",@"test2", nil];
    
    CCLOG(@"Count = %lu",(unsigned long)[playerListDic count]);
    [self createRoom:playerListDic];
    [self cleanAllAcceptMessage];
}






//- (IBAction)btnPressIOS5Json:(id)sender {
//    
//    NSError *error;
//    //加载一个NSURL对象
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://m.weather.com.cn/data/101180601.html"]];
//    //将请求的url数据放到NSData对象中
//    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
//    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//    NSDictionary *weatherInfo = [weatherDic objectForKey:@"weatherinfo"];
//    txtView.text = [NSString stringWithFormat:@"今天是 %@  %@  %@  的天气状况是：%@  %@ ",[weatherInfo objectForKey:@"date_y"],[weatherInfo objectForKey:@"week"],[weatherInfo objectForKey:@"city"], [weatherInfo objectForKey:@"weather1"], [weatherInfo objectForKey:@"temp1"]];
//    NSLog(@"weatherInfo字典里面的内容为--》%@", weatherDic );
//}

#pragma mark -
#pragma mark delegate


-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    if ( eventCode == NSStreamEventHasBytesAvailable) {
        
        /* 
         處理 server端傳送過來的JSon，轉成字串以及 NSData
         */
        NSMutableData *data = [[NSMutableData alloc] init];
        uint8_t buf[1024];
        bzero(buf, sizeof(buf));
        NSInteger readLength = [iStream read:buf maxLength:sizeof(buf) - 1];
        buf[readLength] = '\0';
        [data appendBytes:(const void *)buf length:readLength];
        
        NSError *error;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        int checkResultID = -1;
        checkResultID = [[resultDic objectForKey:@"resultID"] intValue];
        CCLOG(@"check resultID = %d" , checkResultID);
        NSString *checkID = [resultDic objectForKey:@"id"];
        BOOL *checkResult = [[resultDic objectForKey:@"result"] boolValue];
        CCLOG(@"resultDic = %@" , resultDic);
        /*
         優先判斷Server目前傳送的是哪類的資料
         */
        if ( resultDic == NULL ) {
            /*
             空的！
             */
            
        }
        else{
            if ( checkResult ) {
                NSString *list = [resultDic objectForKey:@"list"];
                if ( [list isKindOfClass:[NSNull class]] ) {
                    [state changeState:EnumLobbySomeoneLoginIn];
                }
                else{
                    /* 這裡是 Stub */
                    [self showAllPlayerWithPlayerList:data];
                    //[self STUB_showAllPlayerWithPlayerList:data];
                    [state changeState:EnumLobbyStateLogin];
                }
            }
            /*
             這裡要小心，因為他給的API有兩個地方可能會搜尋到 ID 這個 key ，
             一個是：與誰要求對戰
             一個是：伺服器配對結果 resultID 1, 附上對方玩家id
             由於我們會優先搜尋 checkResult ，所以目前沒這問題，
             但是未來要更改程式碼這裡要注意！
             */
            else if( checkID != NULL ){
                /*
                 實作開始遊戲！！接收到ID以及誰先開始的訊息。
                 */
                NSString *firstPlay = [resultDic objectForKey:@"whoFirst"];
                if ( firstPlay ) {
                    CCLOG(@"要開始遊戲！！");
                    [self startGameWithData:data];
                }
                else{
                    CCLOG(@"只是傳送ID.....");
                }
            }
            else{
                CCLOG(@"Program shouldn't come here!!\nData = %@" , data);
            }
            if( checkResultID != -1 /*[[checkInput objectAtIndex:5] isEqualToString:@"resultID"]*/ ){
                /* 實作配對部分 */
                CCLOG(@"checkResultID = %d" , checkResultID);
                [self matchPlayerWithData:data];
            }
            else{
                CCLOG(@"Program shouldn't come here!!\nData = %@" , data);
            }
        }
    }
    else{
        CCLOG(@"eventCode = %u" , eventCode);
        //[self sendFirstString];
    }
}

-(void)cleanAllRoom{
        if ( showPlayerArray != NULL ) {
            for ( ShowPlayer *tempPlayer in showPlayerArray ) {
                [tempPlayer removeFromParentAndCleanup:YES];
            }
           [showPlayerArray removeAllObjects];
        }
}

-(void)invitePlayer:(NSString *)tempID{
    NSString *inviteString = [NSString stringWithFormat:@"{\"invite\":\"%@\"}\n",tempID];
    CCLOG(@"inviteString = %@" , inviteString);

    //NSString *str = @"{\"token\":\"12312312314\",\"gameID\":\"coody\"}\n";
    //NSString *str = [[NSString alloc] initWithString:@"{\"token\":\"12312312314\",\"gameID\":\"coody\"}"];
    const uint8_t *nuit8Text;
    nuit8Text = (uint8_t *)[inviteString cStringUsingEncoding:NSASCIIStringEncoding];
    NSUInteger buffLen = strlen((char *)nuit8Text);
    NSInteger writtenLength = [oStream write:nuit8Text maxLength:buffLen];
    CCLOG(@"str = %@ (%lu)" ,inviteString,(unsigned long)buffLen);
    
    if (writtenLength != buffLen) {
        [NSException raise:@"WriteFailure" format:@""];
    }
}

-(void)closeStream{
    [iStream close];
    [iStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [iStream setDelegate:nil];
    
    [oStream close];
    [oStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [oStream setDelegate:nil];
    CCLOG(@"關閉Socket!");
    [self cleanAllRoom];
    [self cleanAllAcceptMessage];
    [state changeState:EnumCloseStream];
}

@end














