//
//  ChineseSmallChessGameLayer.m
//  ChessGame
//
//  Created by CoodyChou on 12/10/24.
//
//

#import "ChineseSmallChessGameLayer.h"
#import "ChineseChess.h"

@interface ChineseSmallChessGameLayer()
-(void)setTouchCanTouchOrNot;
-(void)shuffleChess;
-(void)changePlayer;
-(BOOL)checkPlayer:(ChineseChess *)checkChess;
-(void)selectOrOpenChess:(ChineseChess *)tempChess withRecentIndex:(int *)index;
-(void)setChessLogicalGameboardPosition;
-(BOOL)checkTwoChessCanEatOrNot:(int)recentType withBefore:(int)beforeType;
-(BOOL)checkCannonCanEatOrNot:(int)recentTouch with:(int)beforeTouch;

-(void)moveTwoChess:(ChineseChess *)recentChess withBeforeChess:(ChineseChess *)beforeChess;
-(void)changeLogicalGameBoard:(ChineseChess *)recentChess withBefore:(ChineseChess *)beforeChess;
-(BOOL)isCloseOrNot:(int)recentPosition withBefore:(int)beforePosition;

-(void)showGameBoard;
-(void)testError:(int)check;

-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode;
//-(void)sendFirstString;

@end


@implementation ChineseSmallChessGameLayer

-(id)initWithPlaySequence:(BOOL)tempFirstOrNot{
	self = [super init];
	if (self != nil) {
        
        iStream = [GameManager sharedGameManager].iStream;
        oStream = [GameManager sharedGameManager].oStream;
        iStream.delegate =self;
        oStream.delegate = self;
		self.isTouchEnabled = YES;
        
        messageArray = [[NSArray alloc] init];
		CGSize screenSize = [CCDirector sharedDirector].winSize;
				
        whoIsPlaying = [CCLabelTTF labelWithString:@"現在是我在下！" fontName:@"Helvetica-Bold" fontSize:22];
        [self addChild:whoIsPlaying z:20000];
        [whoIsPlaying setColor:ccBLACK];
        [whoIsPlaying setPosition:ccp(screenSize.width*0.5,screenSize.height*0.86)];
        
        firstOrNot = tempFirstOrNot;
		gameBoard = [[ChineseSmallChessGameBoard alloc] init];
		gameBoard.delegate = self;
		[gameBoard createAllChess];
		[self shuffleChess];
		[gameBoard initialChessPosition];
		firstPlayer = [[Player alloc] init];
		secondPlayer = [[Player alloc]init];
        CCLabelTTF *showWhoFirst ;
		
		background =[CCSprite spriteWithFile:@"ChessLayerBackground.png"];
		[self addChild:background];
		[background setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
		[self addChild:gameBoard];
		for ( ChineseChess *tempChess in gameBoard.boardArray ) {
			CCLOG(@"type = %d , position = %d " , tempChess.type , tempChess.gameBoardPosition);
		}
		for (int i = 0; i < 4; i++) {
			for (int j = 0 ; j < 8; j++) {
				logicalGameboard[i][j] = 0;
			}
		}
        /*
         Set
         */
        [self setChessLogicalGameboardPosition];
		if ( tempFirstOrNot == YES ) {
            firstStep = YES;
			recentPlayer = firstPlayer;
            showWhoFirst = [CCLabelTTF labelWithString:@"我先開始！" fontName:@"Helvetica-Bold" fontSize:20];
            [self addChild:showWhoFirst];
            [showWhoFirst setColor:ccBLACK];
            [showWhoFirst setPosition:ccp(screenSize.width*0.5, screenSize.height*0.9)];
            [whoIsPlaying setVisible:YES];
            CCLOG(@"我先開始！");
		}
		else{
            firstStep = NO;
			recentPlayer = secondPlayer;
            showWhoFirst = [CCLabelTTF labelWithString:@"後手！" fontName:@"Helvetica-Bold" fontSize:20];
            [self addChild:showWhoFirst];
            [showWhoFirst setColor:ccBLACK];
            [showWhoFirst setPosition:ccp(screenSize.width*0.5, screenSize.height*0.9)];
            
            [self setTouchCanTouchOrNot];
            [whoIsPlaying setVisible:NO];
            CCLOG(@"後手！");
		}
	}
	return self;
}

-(void)dealloc{
    [messageArray release];
	[gameBoard release];
	[firstPlayer release];
	[secondPlayer release];
	[super dealloc];
}

-(void)setTouchCanTouchOrNot{
	if ( self.isTouchEnabled == YES ) {
		self.isTouchEnabled = NO;
	}
	else{
		self.isTouchEnabled = YES;
	}
}

-(void)shuffleChess{
    if ( firstOrNot == YES ) {
        /*
         交換兩個棋子100次來洗棋子
         */
        for (int i = 0;  i < 100 ; i++ ) {
            int tempShuffleNumber;
            ChineseChess *tempFirstChess= [gameBoard.boardArray objectAtIndex:arc4random()%32];
            ChineseChess *tempSecondChess = [gameBoard.boardArray objectAtIndex:arc4random()%32];
            tempShuffleNumber = tempFirstChess.gameBoardPosition;
            tempFirstChess.gameBoardPosition = tempSecondChess.gameBoardPosition;
            tempSecondChess.gameBoardPosition = tempShuffleNumber;
        }
    }
	else{
        /*
         後手不用洗，等待接收。
         */
    }
}


-(void)changePlayer{
    [recentPlayer setRecentTouchObjectIndex:NOT_TOUCH_ANY_OBJECT withType:NOT_TOUCH_ANY_OBJECT];
	if ( recentPlayer == firstPlayer ) {
		recentPlayer = secondPlayer;
		CCLOG(@"change player to %d!!(黑色 1,紅色 0)",recentPlayer.chessColor);
        
	}
	else{
		recentPlayer = firstPlayer;
		CCLOG(@"change player to %d!!(黑色 1,紅色 0)",recentPlayer.chessColor);
	}
	[self changeNote:recentPlayer];
    [self setTouchCanTouchOrNot];
}

/*
 用來判斷玩家是否碰到據以的棋類，或是目前這個旗子打開
 */
-(BOOL)checkPlayer:(ChineseChess *)checkChess{
	if ([checkChess getOpenOrNot] == NO) {
		return FALSE;
	}
	if (recentPlayer.chessColor == ChessColorBlack ) {
		if ( checkChess.type%2 == 0 ) {
			return FALSE;
		}
		else{
			return TRUE;
		}
	}
	else{
		if ( checkChess.type%2 == 0 ) {
			return TRUE;
		}
		else{
			return FALSE;
		}
	}
}

-(void)selectOrOpenChess:(ChineseChess *)tempChess withRecentIndex:(int *)forwardTouchObjectIndex{
	
	CCLOG(@"START : gameBoard.recentTouchObjectIndex = %d" , [recentPlayer getRecentTouchObjectIndex] );
	if ( [tempChess getOpenOrNot] == NO ) {
		/* 將象棋翻開 */
		[tempChess setOpenOrNot:YES];
		if ( *forwardTouchObjectIndex != NOT_TOUCH_ANY_OBJECT ) {
			/* 之前選到的東西要把動作取消 */
			/* 測試 */
			CCLOG(@"1");
			[self testError:(*forwardTouchObjectIndex)];
			
			
			ChineseChess *forwardChess = [gameBoard.boardArray objectAtIndex:(*forwardTouchObjectIndex)];
			[forwardChess unSelectedAction];
			CCLOG(@"有選到東西");
		}
		[recentPlayer setRecentTouchObjectIndex: NOT_TOUCH_ANY_OBJECT withType:NOT_TOUCH_ANY_OBJECT];
		*forwardTouchObjectIndex = NOT_TOUCH_ANY_OBJECT;
        /*
         這裡是 stub
         */
        
        if ( firstStep ) {
            [self sendAllChessToGameboardAndMoveChess:tempChess];
            firstStep = NO;
        }
        else{
            [self sendOpenChess:tempChess];
        }
        //[self sendMoveActionWithOriginal:[gameBoard.boardArray objectAtIndex:[recentPlayer getRecentTouchObjectIndex]] withEatChess:nil withMove:nil];
		[self changePlayer];
		CCLOG(@"，且翻開象棋");
	}
	else{
		if ( *forwardTouchObjectIndex == NOT_TOUCH_ANY_OBJECT) {
			/* 之前沒有選到東西 */
			if ( [self checkPlayer:tempChess] == TRUE ) {
				[tempChess selectedAction];
				[recentPlayer setRecentTouchObjectIndex:[gameBoard.boardArray indexOfObject:tempChess] withType:tempChess.type];
				CCLOG(@"之前沒有選到東西");
			}
		}
		else{
			/* 之前有選到東西 */
			if ( *forwardTouchObjectIndex == [recentPlayer getRecentTouchObjectIndex] ) {
				return;
			}
			if ( [self checkPlayer:tempChess] == TRUE ) {
				[tempChess selectedAction];
				/* 測試 */
				CCLOG(@"2");
				[self testError:(*forwardTouchObjectIndex)];
				
				
				[recentPlayer setRecentTouchObjectIndex:[gameBoard.boardArray indexOfObject:tempChess] withType:tempChess.type];
				/* 讓之前選的取消動作，並且選新的東西 */
				/* 測試 */
				CCLOG(@"3");
				[self testError:(*forwardTouchObjectIndex)];
				
				
				ChineseChess *forwardChess = [gameBoard.boardArray objectAtIndex:(*forwardTouchObjectIndex)];
				[forwardChess unSelectedAction];
				CCLOG(@"有選到東西");
			}
		}
	}
	CCLOG(@"END : gameBoard.recentTouchObjectIndex = %d" , [recentPlayer getRecentTouchObjectIndex] );
}

-(BOOL)checkCannonCanEatOrNot:(int)recentTouch with:(int)beforeTouch{
	BOOL checkCannon = NO;
	int countNonZeroChess = 0;
	int recentX = recentTouch%8;
	int recentY = recentTouch/8;
	int beforeX = beforeTouch%8;
	int beforeY = beforeTouch/8;
	int i = 0 , j = 0 ;
	if ( recentX == beforeX ) {
		if ( recentY < beforeY ) {
			i = recentY + 1;
			j = beforeY;
		}
		else if( beforeY < recentY ){
			i = beforeY + 1;
			j = recentY;
		}
		else{
			checkCannon = NO;
		}
		while ( i < j ) {
			if ( logicalGameboard[i][recentX] != 0 ) {
				countNonZeroChess++;
				CCLOG(@"之間有棋子!!!!");
			}
			i++;
		}
	}
	else if( recentY == beforeY ){
		if ( recentX < beforeX ) {
			i = recentX + 1;
			j = beforeX;
		}
		else if( beforeX < recentX ){
			i = beforeX + 1;
			j = recentX;
		}
		else{
			checkCannon = NO;
		}
		while ( i < j ) {
			if ( logicalGameboard[recentY][i] != 0 ) {
				countNonZeroChess++;
				CCLOG(@"之間有棋子!!!!");
			}
			i++;
		}
	}
	if (countNonZeroChess == 1) {
		checkCannon = YES;
	}
	else{
		checkCannon = NO;
	}
	CCLOG(@"計算和砲之間有幾個棋子：%d" , countNonZeroChess);
	return checkCannon;
}

#pragma mark -
#pragma mark Move Chess

-(void)moveTwoChess:(ChineseChess *)recentChess withBeforeChess:(ChineseChess *)beforeChess{
    if ( recentPlayer.chessColor == firstPlayer.chessColor ) {
        secondPlayer.deadChessArrayCount++;
    }
    else{
        firstPlayer.deadChessArrayCount++;
    }
    recentPlayer.deadChessArrayCount++;
	[recentChess unSelectedAction];
	[beforeChess unSelectedAction];
	[beforeChess moveAction];
	[self reorderChild:recentChess z:ZOrderChessMoving];
	[self reorderChild:beforeChess z:ZOrderChessMoving];
	id moveAction = [CCMoveTo actionWithDuration:MOVE_ACTION_TIME position:recentChess.position];
	[beforeChess runAction:moveAction];
	id scaleAction = [CCScaleTo actionWithDuration:MOVE_ACTION_TIME scale:0.5f];
	id removeAction;
	if (recentChess.type%2 == 0) {
		removeAction = [CCMoveTo actionWithDuration:MOVE_ACTION_TIME position:ccp(20+60*firstPlayer.deadChessArrayCount, 550)];
	}
	else{
		removeAction = [CCMoveTo actionWithDuration:MOVE_ACTION_TIME position:ccp(20+60*secondPlayer.deadChessArrayCount, 620)];
	}
	
	[recentChess runAction:scaleAction];
	[recentChess runAction:removeAction];
	[recentChess setDeadOrNot:YES];
	[self changeLogicalGameBoard:recentChess withBefore:beforeChess];
	[self reorderChild:beforeChess z:ZOrderChess];
}

-(BOOL)isCloseOrNot:(int)recentPosition withBefore:(int)beforePosition {
	BOOL checkBool = NO;
	int recentX = recentPosition%8;
	int recentY = recentPosition/8;
	int beforeX = beforePosition%8;
	int beforeY = beforePosition/8;
	if ( recentX == beforeX ) {
		int checkPosition = recentY - beforeY;
		if ( checkPosition == 1 || checkPosition == -1) {
			checkBool = YES;
		}
		else{
			checkBool = NO;
		}
	}
	else if( recentY == beforeY ){
		int checkPosition = recentX - beforeX;
		if ( checkPosition == 1 || checkPosition == -1) {
			checkBool = YES;
		}
		else{
			checkBool = NO;
		}
	}
	return checkBool;
}

#pragma mark -
#pragma mark Handle Logical GameBoard

-(void)setChessLogicalGameboardPosition{
	for ( ChineseChess *tempChess in gameBoard.boardArray ) {
		logicalGameboard[tempChess.gameBoardPosition /8][tempChess.gameBoardPosition %8] = tempChess.type;
	}
	for (int i = 3; i >= 0 ; i--) {
		for (int j = 0 ; j < 8 ; j++) {
			printf(" %2d " , logicalGameboard[i][j]);
			if (j!=7) {
				printf(",");
			}
		}
		printf("\n");
	}
}

-(void)changeLogicalGameBoard:(ChineseChess *)recentChess withBefore:(ChineseChess *)beforeChess{
	int recentX = recentChess.gameBoardPosition%8;
	int recentY = recentChess.gameBoardPosition/8;
	int beforeX = beforeChess.gameBoardPosition%8;
	int beforeY = beforeChess.gameBoardPosition/8;
	logicalGameboard[recentY][recentX] = logicalGameboard[beforeY][beforeX];
	logicalGameboard[beforeY][beforeX] = 0;
	beforeChess.gameBoardPosition = recentChess.gameBoardPosition;
	recentChess.gameBoardPosition = -1;
}

#pragma mark -
#pragma mark Chess Delegate


-(void)moveChess:(id)moveChess withX:(int)x withY:(int)y{
	if ([moveChess isKindOfClass:[ChineseChess class]]) {
		
		int chessX = ((ChineseChess *)moveChess).gameBoardPosition%8;
		int chessY = ((ChineseChess *)moveChess).gameBoardPosition/8;
		
		[((ChineseChess *)moveChess) unSelectedAction];
		id moveAction = [CCMoveTo actionWithDuration:MOVE_ACTION_TIME position:ccp(80 + 120*x, 80+120*y)];
		[moveChess runAction:moveAction];
		((ChineseChess *)moveChess).gameBoardPosition = 8*y+x;
		logicalGameboard[y][x] = ((ChineseChess *)moveChess).type;
		logicalGameboard[chessY][chessX] = 0;
		
		
		
		/*
		int chessX = ((ChineseChess *)moveChess).gameBoardPosition%8;
		int chessY = ((ChineseChess *)moveChess).gameBoardPosition/8;
		if ( chessX == x) {
			int check = chessY - y;
			if ( check == 1 || check == -1 ) {
				[((ChineseChess *)moveChess) unSelectedAction];
				id moveAction = [CCMoveTo actionWithDuration:0.5 position:ccp(80 + 120*x, 80+120*y)];
				[moveChess runAction:moveAction];
				((ChineseChess *)moveChess).gameBoardPosition = 8*y+x;
				logicalGameboard[y][x] = ((ChineseChess *)moveChess).type;
				logicalGameboard[chessY][chessX] = 0;
			}
			else{
				return;
			}
		}*/
	}
	else{
		CCLOG(@"發生錯誤！！Class類別有誤！！！！");
	}
}

#pragma mark -
#pragma mark GameBoard Delegate

-(void)createChess{
	for ( int i = 0 ; i < 32 ; i++ ) {
		ChineseChessType tempChessTypeName;
		switch (i) {
			case 0:
			case 1:
			case 2:
			case 3:
			case 4:
				tempChessTypeName = 1;
				break;
			case 5:
			case 6:
			case 7:
			case 8:
			case 9:
				tempChessTypeName = 2;
				break;
			case 10:
			case 11:
				tempChessTypeName = 3;
				break;
			case 12:
			case 13:
				tempChessTypeName = 4;
				break;
			case 14:
			case 15:
				tempChessTypeName = 5;
				break;
			case 16:
			case 17:
				tempChessTypeName = 6;
				break;
			case 18:
			case 19:
				tempChessTypeName = 7;
				break;
			case 20:
			case 21:
				tempChessTypeName = 8;
				break;
			case 22:
			case 23:
				tempChessTypeName = 9;
				break;
			case 24:
			case 25:
				tempChessTypeName = 10;
				break;
			case 26:
			case 27:
				tempChessTypeName = 11;
				break;
			case 28:
			case 29:
				tempChessTypeName = 12;
				break;
			case 30:
				tempChessTypeName = 13;
				break;
			case 31:
				tempChessTypeName = 14;
				break;
			default:
				break;
		}
		ChineseChess *tempChess = [[ChineseChess alloc]initWithFile:@"Close.png"];
		tempChess.gameBoardPosition = i;
		tempChess.type = tempChessTypeName;
		[gameBoard.boardArray addObject:tempChess];
		tempChess.delegate = self;
		[tempChess release];
	}
	
}

-(BOOL)gameRuleWithRecentTouch:(int)recentTouch withBeforeTouch:(int)beforeTouch{
	BOOL canMoveOrNot = NO;
	int recentX = recentTouch%8;
	int recentY = recentTouch/8;
	int beforeX = beforeTouch%8;
	int beforeY = beforeTouch/8;
	int recentChessType = logicalGameboard[recentY][recentX];
	int beforeChessType = logicalGameboard[beforeY][beforeX];
	
	if ( recentChessType%2 == beforeChessType %2 ) {
		canMoveOrNot = NO;
	}
	else{
		if (recentChessType%2 != 0) {
			recentChessType = recentChessType + 1 ;
		}
		else{
			beforeChessType = beforeChessType + 1 ;
		}
		CCLOG(@"recentChessType = %d , beforeChessType = %d " , recentChessType , beforeChessType );
		if ( beforeChessType == ChineseChessCannonR ) {
			CCLOG(@"我是砲");
			canMoveOrNot = [self checkCannonCanEatOrNot:recentTouch with:beforeTouch];
		}
		else{
			if ( [self isCloseOrNot:recentTouch withBefore:beforeTouch] ) {
				CCLOG(@"在旁邊可以判斷可不可以吃!!!");
				canMoveOrNot = [self checkTwoChessCanEatOrNot:recentChessType withBefore:beforeChessType];
			}
			else{
				CCLOG(@"不再旁邊!!!!");
				canMoveOrNot = NO;
			}
		}
	}
	return canMoveOrNot;
}

-(BOOL)checkTwoChessCanEatOrNot:(int)recentType withBefore:(int)beforeType{
	if ( beforeType >= recentType ) {
		if ( beforeType == ChineseChessGeneralR && recentType == ChineseChessSoldierR ) {
			CCLOG(@"將不可以吃兵!!!!!");
			return NO;
		}
		else{
			return YES;
		}
	}
	else{
		if ( beforeType == ChineseChessSoldierR && recentType == ChineseChessGeneralR) {
			CCLOG(@"兵可以吃將!!!!");
			return YES;
		}
		else{
			return NO;
		}
	}
}

-(void)setChessPosition{
	for (int i = 0 ; i < 32 ; i++ ) {
		ChineseChess *tempChess = [gameBoard.boardArray objectAtIndex:i];
		int x = tempChess.gameBoardPosition / 8;
		int y = tempChess.gameBoardPosition % 8;
		[tempChess setPosition:ccp(80+120*y, 80+120*x)];
        [self addChild:tempChess z:ZOrderChess];
	}
}

-(void)changeChessPosition{
    for (int i = 0 ; i < 32 ; i++ ) {
		ChineseChess *tempChess = [gameBoard.boardArray objectAtIndex:i];
		int x = tempChess.gameBoardPosition / 8;
		int y = tempChess.gameBoardPosition % 8;
		[tempChess setPosition:ccp(80+120*y, 80+120*x)];
	}
}

-(void)changeNote:(id)player{
	[self reorderChild:gameBoard.noteSprite z:100];
    if ( whoIsPlaying.visible == NO ) {
        [whoIsPlaying setVisible:YES];
    }
    else{
        [whoIsPlaying setVisible:NO];
    }
	if (((Player*)player).chessColor == ChessColorBlack ) {
        
		UIImage *changeImage = [UIImage imageNamed:@"NoteBlack.png"];
		CCTexture2D *temp = [[CCTextureCache sharedTextureCache] addCGImage:changeImage.CGImage forKey:nil];
		[gameBoard.noteSprite setTexture:temp];
		//[gameBoard.noteSprite setScale:0];
	}
	else{
		UIImage *changeImage = [UIImage imageNamed:@"NoteRed.png"];
		CCTexture2D *temp = [[CCTextureCache sharedTextureCache] addCGImage:changeImage.CGImage forKey:nil];
		[gameBoard.noteSprite setTexture:temp];
		//[gameBoard.noteSprite setScale:0];
	}
	id bigAction = [CCFadeIn actionWithDuration:0.5];
	id easeBigAction = [CCEaseIn actionWithAction:bigAction rate:2];
	id smallAction = [CCFadeOut actionWithDuration:0.5];
	id easeSmallAction = [CCEaseOut actionWithAction:smallAction rate:0.5];
	id allAction = [CCSequence actionOne:easeBigAction two:easeSmallAction];
	[gameBoard.noteSprite runAction:allAction];
    
//  [self sendFirstString];
//  [[GameManager sharedGameManager] stream:[GameManager sharedGameManager].iStream handleEvent:NSStreamEventHasBytesAvailable];
}

#pragma mark -
#pragma mark ccTouches..Methods
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	/*
	UITouch *myTouch = [touches anyObject];
	CGPoint touchLocation = [myTouch locationInView:[myTouch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
	for ( ChineseChess *tempChess in gameBoard.boardArray ) {
		CGRect tempChessLoaction = CGRectMake(tempChess.position.x - tempChess.contentSize.width*0.5,
											  tempChess.position.y - tempChess.contentSize.height*0.5 ,
											  tempChess.contentSize.width,
											  tempChess.contentSize.height);
		if (CGRectContainsPoint( tempChessLoaction, touchLocation)) {
		}
	}
	 */
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	int forwardTouchObjectIndex = [recentPlayer getRecentTouchObjectIndex];
	UITouch *myTouch = [touches anyObject];
	CGPoint touchLocation = [myTouch locationInView:[myTouch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
	for ( ChineseChess *tempChess in gameBoard.boardArray ) {
		if (tempChess.deadOrNot == YES) {
			continue;
		}
		CGRect tempChessLocation = CGRectMake( tempChess.position.x - tempChess.contentSize.width*0.5 ,
										   tempChess.position.y - tempChess.contentSize.height*0.5,
										   tempChess.contentSize.width ,
										   tempChess.contentSize.height);
		
		if (CGRectContainsPoint( tempChessLocation , touchLocation )) {
			/* 設定骰子顏色 */
			if ( firstStep ) {
				firstPlayer.chessColor = tempChess.type%2;
                secondPlayer.chessColor = (tempChess.type+1)%2;
			}
            /*
             把玩家現在碰到的是哪個旗子在陣列裡面的 index 取出，並且儲存他是哪種棋子。
             */
			[recentPlayer setRecentTouchObjectIndex:[gameBoard.boardArray indexOfObject:tempChess] withType:tempChess.type];
			CCLOG(@"test = %d" , [recentPlayer getRecentTouchObjectIndex]);
            
			if ( forwardTouchObjectIndex == NOT_TOUCH_ANY_OBJECT ) {
				CCLOG(@"之前沒有碰過骰子");
                //判斷要選取還是要打開棋子
				[self selectOrOpenChess:tempChess withRecentIndex:&forwardTouchObjectIndex];
			}
			else{
				CCLOG(@"目前觸碰到: %d , 之前觸碰到: %d" ,[recentPlayer getRecentTouchObjectIndex],forwardTouchObjectIndex );
				ChineseChess *beforeTouchChess = [gameBoard.boardArray objectAtIndex:forwardTouchObjectIndex];
				if ( [tempChess getOpenOrNot] && [self gameRuleWithRecentTouch:tempChess.gameBoardPosition
								  withBeforeTouch:beforeTouchChess.gameBoardPosition] ) {
					CCLOG(@"遊戲判斷邏輯");
                    /*
                     這裡是 stub
                     */
                    //[self STUB_testSendString];
                    [self sendOpenChess:tempChess x:(tempChess.gameBoardPosition/8) y:(tempChess.gameBoardPosition%8) andRecentChess:beforeTouchChess x:(beforeTouchChess.gameBoardPosition/8) y:(beforeTouchChess.gameBoardPosition%8)];
                    [self moveTwoChess:tempChess withBeforeChess:beforeTouchChess];
                    [recentPlayer setRecentTouchObjectIndex:NOT_TOUCH_ANY_OBJECT withType:ChineseChessERROR];
					forwardTouchObjectIndex = NOT_TOUCH_ANY_OBJECT;
					[self changePlayer];
				}
				else{
					ChineseChess *forwardChess = [gameBoard.boardArray objectAtIndex:forwardTouchObjectIndex];
					if (forwardChess.deadOrNot == NO) {
						[forwardChess unSelectedAction];
					}
					[recentPlayer setRecentTouchObjectIndex:NOT_TOUCH_ANY_OBJECT withType:ChineseChessERROR];
					forwardTouchObjectIndex = NOT_TOUCH_ANY_OBJECT;
					[self selectOrOpenChess:tempChess withRecentIndex:&forwardTouchObjectIndex];
				}
			}
		}
	}
	/* handle move chess */
	for (int i = 0;  i < 4 ; i++ ) {
		for (int j = 0 ; j < 8; j++ ) {
			CGRect touchNoChessLocation = CGRectMake( 25 + 120*j , 25 + 120*i, 110 , 110 );
			if (CGRectContainsPoint( touchNoChessLocation , touchLocation)) {
				
				if (forwardTouchObjectIndex == NOT_TOUCH_ANY_OBJECT) {
					CCLOG(@"選棋子！？？");
				}
				else{
					ChineseChess *beforeTouchChess = [gameBoard.boardArray objectAtIndex:forwardTouchObjectIndex];
					if ( [self isCloseOrNot:i*8+j withBefore:beforeTouchChess.gameBoardPosition] ) {
                        [self sendOpenChess:nil x:i y:j beforeChess:beforeTouchChess x:(beforeTouchChess.gameBoardPosition/8) y:(beforeTouchChess.gameBoardPosition%8)];
						[self moveChess:beforeTouchChess withX:j withY:i];
                        
						forwardTouchObjectIndex = NOT_TOUCH_ANY_OBJECT;
						[recentPlayer setRecentTouchObjectIndex:NOT_TOUCH_ANY_OBJECT withType:ChineseChessERROR];
						[self changePlayer];
					}
					else{
						
					}
				}
			}
		}
	}
	[self showGameBoard];
//    if( recentPlayer.chessColor == secondPlayer.chessColor ){
//        CCDelayTime *delaytime = [CCDelayTime actionWithDuration:1.0f];
//        int temp1 = arc4random()%[gameBoard.boardArray count];
//        
//        for ( ChineseChess *tempChess in gameBoard.boardArray ) {
//            if ( ![tempChess getOpenOrNot] ) {
//                
//            }
//        }
//    }
}

#pragma mark -
#pragma mark TestFunction

-(void)showGameBoard{
	for (int i = 3; i >= 0 ; i--) {
		for (int j = 0 ; j < 8 ; j++) {
			printf(" %2d " , logicalGameboard[i][j]);
			if (j!=7) {
				printf(",");
			}
		}
		printf("\n");
	}
}

-(void)testError:(int)check{
	if (check < 0) {
		CCLOG(@"ERROR!!!");
		exit(0);
	}
}

//-(void)sendFirstString{
//    NSString *str = [NSString stringWithFormat:@"{\"token\":\"%@\",\"gameID\":\"Coody\"}\n",[GameManager sharedGameManager].token];
//    //NSString *str = @"{\"token\":\"12312312314\",\"gameID\":\"Coody\"}\n";
//    //NSString *str = [[NSString alloc] initWithString:@"{\"token\":\"12312312314\",\"gameID\":\"Coody\"}"];
//    const uint8_t *nuit8Text;
//    nuit8Text = (uint8_t *)[str cStringUsingEncoding:NSASCIIStringEncoding];
//    NSUInteger buffLen = strlen((char *)nuit8Text);
//    CCLOG(@"test111 = %lu" , [oStream streamStatus]);
//    NSInteger writtenLength = [oStream write:nuit8Text maxLength:buffLen];
//    CCLOG(@"test222 = %lu" , [oStream streamStatus]);
//    CCLOG(@"str = %@ (%lu)" ,str,(unsigned long)buffLen);
//    
//    if (writtenLength != buffLen) {
//        [NSException raise:@"WriteFailure" format:@""];
//    }
//}

-(void)sendOpenChess:(ChineseChess *)tempChess{
    NSString *send = [NSString stringWithFormat:@"{\"data\":\"2,%d,%d,%d,MoveChessType,x,y\",\"PutItThere\":false}\n",tempChess.type,tempChess.gameBoardPosition/8,tempChess.gameBoardPosition%8];
    const uint8_t *unit8Text;
    unit8Text = (uint8_t *)[send cStringUsingEncoding:NSASCIIStringEncoding];
    NSInteger buffLen = strlen((char *)unit8Text);
    NSInteger writtenLength = [oStream write:unit8Text maxLength:buffLen];
    if (writtenLength != buffLen) {
        [NSException raise:@"WriteFailure" format:@""];
    }
}

-(void)receiveOpenChess:(NSString *)tempString{
    NSArray *openArray = [tempString componentsSeparatedByString:@","];
    CCLOG(@"openArray = %@" , openArray);
    NSMutableArray *openArrayMutable = [NSMutableArray arrayWithArray:openArray];
    [openArrayMutable removeObjectAtIndex:0];
    int x = [[openArrayMutable objectAtIndex:1] intValue];
    int y = [[openArrayMutable objectAtIndex:2] intValue];
    int position = x*8+y;
    for ( ChineseChess *tempChess in gameBoard.boardArray ) {
        if ( tempChess.gameBoardPosition == position ) {
            [tempChess setOpenOrNot:YES];
        }
    }
}



-(void)sendOpenChess:(ChineseChess *)tempChess x:(int)x1 y:(int)y1 andRecentChess:(ChineseChess *)tempRecentChess x:(int)x2 y:(int)y2{
    NSString *send = [NSString stringWithFormat:@"{\"data\":\"4,%d,%d,%d,%d,%d,%d\",\"PutItThere\":false}\n",tempChess.type,x1,y1,tempRecentChess.type,x2,y2];
    CCLOG(@"sendOpen and Rece = %@" , send);
    const uint8_t *unit8Text;
    unit8Text = (uint8_t *)[send cStringUsingEncoding:NSASCIIStringEncoding];
    NSInteger buffLen = strlen((char *)unit8Text);
    NSInteger writtenLength = [oStream write:unit8Text maxLength:buffLen];
    if (writtenLength != buffLen) {
        [NSException raise:@"WriteFailure" format:@""];
    }
}

-(void)receiveMoveChess:(NSString *)tempString{
    NSArray *openArray = [tempString componentsSeparatedByString:@","];
    CCLOG(@"openArray = %@" , openArray);
    NSMutableArray *openArrayMutable = [NSMutableArray arrayWithArray:openArray];
    [openArrayMutable removeObjectAtIndex:0];
    int x1 = [[openArrayMutable objectAtIndex:1] intValue];
    int y1 = [[openArrayMutable objectAtIndex:2] intValue];
    int x2 = [[openArrayMutable objectAtIndex:4] intValue];
    int y2 = [[openArrayMutable objectAtIndex:5] intValue];
    ChineseChess *touchChess;
    int touchPos = x1*8+y1;
    ChineseChess *recentChess;
    int recentPos = x2*8+y2;
    for ( ChineseChess *tempChess in gameBoard.boardArray ) {
        if ( tempChess.gameBoardPosition == touchPos ) {
            touchChess = tempChess;
        }
        if ( tempChess.gameBoardPosition == recentPos ) {
            recentChess = tempChess;
        }
    }
    [self moveTwoChess:touchChess withBeforeChess:recentChess];
}

-(void)sendOpenChess:(ChineseChess *)tempChess x:(int)x1 y:(int)y1 beforeChess:(ChineseChess *)beforeChess x:(int)x2 y:(int)y2{
    NSString *send = [NSString stringWithFormat:@"{\"data\":\"3,-1,%d,%d,%d,%d,%d\",\"PutItThere\":false}\n",x1,y1,beforeChess.type,x2,y2];
    CCLOG(@"sendOpen and Rece = %@" , send);
    const uint8_t *unit8Text;
    unit8Text = (uint8_t *)[send cStringUsingEncoding:NSASCIIStringEncoding];
    NSInteger buffLen = strlen((char *)unit8Text);
    NSInteger writtenLength = [oStream write:unit8Text maxLength:buffLen];
    if (writtenLength != buffLen) {
        [NSException raise:@"WriteFailure" format:@""];
    }
}

-(void)receiveMoveToNoChess:(NSString *)tempString{
    NSArray *openArray = [tempString componentsSeparatedByString:@","];
    CCLOG(@"openArray = %@" , openArray);
    NSMutableArray *openArrayMutable = [NSMutableArray arrayWithArray:openArray];
    [openArrayMutable removeObjectAtIndex:0];
    int x1 = [[openArrayMutable objectAtIndex:1] intValue];
    int y1 = [[openArrayMutable objectAtIndex:2] intValue];
    int x2 = [[openArrayMutable objectAtIndex:4] intValue];
    int y2 = [[openArrayMutable objectAtIndex:5] intValue];
    ChineseChess *touchChess;
    int touchPos = x2*8+y2;
    for ( ChineseChess *tempChess in gameBoard.boardArray ) {
        if ( tempChess.gameBoardPosition == touchPos ) {
            touchChess = tempChess;
        }
    }
    [self moveChess:touchChess withX:y1 withY:x1];
}



-(void)STUB_testSendString{
    NSString *str = @"{\"data\":\"2,TouchChessType,x,y,MoveChessType,x,y,1,2,3,4,5,6,76,7,3,2,1\",\"PutItThere\":false}\n";
    const uint8_t *unit8Text;
    unit8Text = (uint8_t *)[str cStringUsingEncoding:NSASCIIStringEncoding];
    NSInteger buffLen = strlen((char *)unit8Text);
    NSInteger writtenLength = [oStream write:unit8Text maxLength:buffLen];
    if (writtenLength != buffLen) {
        [NSException raise:@"WriteFailure" format:@""];
    }
    //NSString *str = [NSString stringWithFormat:@"{\"token\":\"%@\",\"gameID\":\"Coody\"}\n",[GameManager sharedGameManager].token];
    //    //NSString *str = @"{\"token\":\"12312312314\",\"gameID\":\"Coody\"}\n";
    //    //NSString *str = [[NSString alloc] initWithString:@"{\"token\":\"12312312314\",\"gameID\":\"Coody\"}"];
    //    const uint8_t *nuit8Text;
    //    nuit8Text = (uint8_t *)[str cStringUsingEncoding:NSASCIIStringEncoding];
    //    NSUInteger buffLen = strlen((char *)nuit8Text);
    //    CCLOG(@"test111 = %lu" , [oStream streamStatus]);
    //    NSInteger writtenLength = [oStream write:nuit8Text maxLength:buffLen];
    //    CCLOG(@"test222 = %lu" , [oStream streamStatus]);
    //    CCLOG(@"str = %@ (%lu)" ,str,(unsigned long)buffLen);
    //
    //    if (writtenLength != buffLen) {
    //        [NSException raise:@"WriteFailure" format:@""];
    //    }
}

-(void)sendAllChessToGameboardAndMoveChess:(ChineseChess *)tempChess{
    int array[32];
    for ( int i = 0 ; i < 32 ; i++ ) {
        ChineseChess *tempPosition = [gameBoard.boardArray objectAtIndex:i];
        array[i] = tempPosition.gameBoardPosition;
    }
    NSString *str = [NSString stringWithFormat:@"{\"data\":\"1,%d,%d,%d,MoveChessType,x,y,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\",\"PutItThere\":false}\n",tempChess.type,tempChess.gameBoardPosition/8,tempChess.gameBoardPosition%8,array[0],array[1],array[2],array[3],array[4],array[5],array[6],array[7],array[8],array[9],array[10],array[11],array[12],array[13],array[14],array[15],array[16],array[17],array[18],array[19],array[20],array[21],array[22],array[23],array[24],array[25],array[26],array[27],array[28],array[29],array[30],array[31]];
    //NSString *str = @"{\"data\":\"1,TouchChessType,x,y,MoveChessType,x,y,1,2,3,4,5,6,76,7,3,2,1\",\"PutItThere\":false}\n";
    CCLOG(@"str = %@" , str);
    const uint8_t *unit8Text;
    unit8Text = (uint8_t *)[str cStringUsingEncoding:NSASCIIStringEncoding];
    NSInteger buffLen = strlen((char *)unit8Text);
    NSInteger writtenLength = [oStream write:unit8Text maxLength:buffLen];
    if (writtenLength != buffLen) {
        [NSException raise:@"WriteFailure" format:@""];
    }
}

-(void)receiveAllChessToGameboard{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:messageArray];
    for (int i = 0; i < 7; i++) {
        if ( i == 1 ) {
            recentPlayer.chessColor =([[tempArray objectAtIndex:0] intValue]+1)%2;
            if ( recentPlayer == firstPlayer ) {
                secondPlayer.chessColor = (recentPlayer.chessColor+1)%2;
            }
            else{
                firstPlayer.chessColor = (recentPlayer.chessColor+1)%2;
            }
        }
        [tempArray removeObjectAtIndex:0];
    }
    CCLOG(@"tempArray = %@" , tempArray);
    for ( int i = 0 ; i < 32 ; i++ ) {
        ChineseChess *tempChess = [gameBoard.boardArray objectAtIndex:i];
        tempChess.gameBoardPosition = [[tempArray objectAtIndex:i] intValue];
    }
    [self setChessLogicalGameboardPosition];
    [self changeChessPosition];
    
}

-(void)receiveMessage:(NSString *)tempString{
    messageArray = [tempString componentsSeparatedByString:@","];
    CCLOG(@"tempData = %@" , tempString);
    if ( [[messageArray objectAtIndex:0] isEqualToString:@"1"] ) {
        CCLOG(@"翻開棋子，且輸入棋盤");
        [self receiveAllChessToGameboard];
        [self receiveOpenChess:tempString];
    }
    else if( [[messageArray objectAtIndex:0] isEqualToString:@"2"] ){
        [self receiveOpenChess:tempString];
        CCLOG(@"翻開棋子");
    }
    else if( [[messageArray objectAtIndex:0] isEqualToString:@"3"] ){
        [self receiveMoveToNoChess:tempString];
        CCLOG(@"移動棋子");
    }
    else if( [[messageArray objectAtIndex:0] isEqualToString:@"4"] ){
        [self receiveMoveChess:tempString];
        CCLOG(@"移動旗子且吃");
    }
    else{
        CCLOG(@"MessageArray error!");
    }
}

/*
 這裡要寫一下second Player如果確認後，
 當第一個玩家翻開旗子，那麼這裡收到以後要把 second player 的 chessColor 設定進去，
 避免在cctouches裡面又設定一次
 */
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    if ( eventCode == NSStreamEventHasBytesAvailable) {
        NSMutableData *tempData = [[NSMutableData alloc] init];
        
        uint8_t buf[1024];
        bzero(buf, sizeof(buf));
        NSInteger readLength = [iStream read:buf maxLength:sizeof(buf) - 1];
        buf[readLength] = '\0';
        [tempData appendBytes:(const void *)buf length:readLength];
        
//        NSMutableData *data = [[NSMutableData alloc] init];
//        uint8_t buf[1024];
//        bzero(buf, sizeof(buf));
//        NSInteger readLength = [iStream read:buf maxLength:sizeof(buf) - 1];
//        buf[readLength] = '\0';
//        [data appendBytes:(const void *)buf length:readLength];
//        CCLOG(@"tempData = %@" , tempData);
        NSError *error;
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:tempData options:NSJSONReadingMutableLeaves error:&error];
        NSString *checkResultID = [resultDic objectForKey:@"result"];
        NSString *checkData = [resultDic objectForKey:@"data"];
//        CCLOG(@"收到訊息：%@" , checkData);
//        CCLOG(@"result:%@" , checkResultID);
        if ( checkData != NULL ) {
            /*
             這裡是玩家棋步的資訊！
             {
                "data":[situationNumber,TouchChessType,x,y,MoveChessType,x,y],
                "PutItThere": (boolean)
             }
             */
            [self changePlayer];
            if ( recentPlayer.chessColor == ChessColorUnknown ) {
                recentPlayer.chessColor = (firstPlayer.chessColor+1)%2;
                firstPlayer.chessColor = (firstPlayer.chessColor);
            }
            CCLOG(@"check Data = %@" , checkData);
            [self receiveMessage:checkData];
        }
        else if( checkResultID != NULL ){
            /*
             這裡就是遊戲結束時。
             */
            BOOL resultWinner = [checkResultID boolValue];
            if ( resultWinner ) {
                CCLOG(@"贏了！");
            }
            else{
                CCLOG(@"輸了！");
            }
        }
        else{
            
        }
        
    }
    else{
        CCLOG(@"eventCode = %u" , eventCode);
        //[self sendFirstString];
    }
}



@end
