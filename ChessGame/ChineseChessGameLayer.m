//
//  ChineseChessGameLayer.m
//  ChessGame
//
//  Created by CoodyChou on 12/10/31.
//
//

#import "ChineseChessGameLayer.h"
#import "Constant.h"
#import "ChineseChess.h"

@implementation ChineseChessGameLayer

-(id)init{
	self = [super initWithColor:ccc4(255, 255, 255, 255)];
	if (self != nil) {
		gameBoard = [[ChineseChessGameBoard alloc]init];
		[self addChild:gameBoard];
		firstPlayer =[[Player alloc]init];
		secondPlayer = [[Player alloc]init];
		gameBoard.delegate = self;
		[gameBoard createAllChess];
		[gameBoard initialChessPosition];
	}
	return self;
}

-(void)dealloc{
	[gameBoard release];
	[firstPlayer release];
	[secondPlayer release];
	[super dealloc];
}

#pragma mark -
#pragma mark GameBoardDelegate

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
		[tempChess setScale:0.65f];
		[gameBoard.boardArray addObject:tempChess];
		tempChess.delegate = self;
		[tempChess setOpenOrNot:YES];
		[tempChess release];
	}
}
-(BOOL)gameRuleWithRecentTouch:(int)recentTouch withBeforeTouch:(int)beforeTouch{
	return NO;
}
-(void)setChessPosition{
	CCLOG(@"Create Chess!!!!!!!!!!!");
	int countSoldierB = 0; /* have 5 solders */
	int countSoldierR = 0;
	
	int countCannonB = 0;  /* have two , 3 and 4 is 炮 */
	int countCannonR = 0;
	int countHorseB = 0;
	int countHorseR = 0;
	int countChariotB = 0;
	int countChariotR = 0;
	int countElephantB = 0;
	int countElephantR = 0;
	int countAdvisorB = 0;
	int countAdvisorR = 0;
	for ( ChineseChess *tempChess in gameBoard.boardArray ) {
		switch (tempChess.type) {
			case ChineseChessSoldierB:
				[tempChess setPosition:ccp(629, 72+78*countSoldierB)];
				
				countSoldierB = countSoldierB + 2;
				CCLOG(@"Create Chess!!!!!!!!!!!");
				break;
			case ChineseChessSoldierR:
				[tempChess setPosition:ccp(395, 72+78*countSoldierR)];
				countSoldierR = countSoldierR + 2;
				break;
			case ChineseChessCannonB:
				[tempChess setPosition:ccp(707, 150+468*countCannonB)];
				countCannonB++;
				break;
			case ChineseChessCannonR:
				[tempChess setPosition:ccp(317, 150+468*countCannonR)];
				countCannonR++;
				break;
			case ChineseChessHorseB:
				[tempChess setPosition:ccp(863, 150+468*countHorseB)];
				countHorseB++;
				break;
			case ChineseChessHorseR:
				[tempChess setPosition:ccp(161, 150+468*countHorseR)];
				countHorseR++;
				break;
			case ChineseChessChariotB:
				[tempChess setPosition:ccp(863, 72+624*countChariotB)];
				countChariotB++;
				break;
			case ChineseChessChariotR:
				[tempChess setPosition:ccp(161, 72+624*countChariotR)];
				countChariotR++;
				break;
			case ChineseChessElephantB:
				[tempChess setPosition:ccp(863, 228+312*countElephantB)];
				countElephantB++;
				break;
			case ChineseChessElephantR:
				[tempChess setPosition:ccp(161, 228+312*countElephantR )];
				countElephantR++;
				break;
			case ChineseChessAdvisorB:
				[tempChess setPosition:ccp(863, 306+156*countAdvisorB)];
				countAdvisorB++;
				break;
			case ChineseChessAdvisorR:
				[tempChess setPosition:ccp(161, 306+156*countAdvisorR)];
				countAdvisorR++;
				break;
			case ChineseChessGeneralB:
				[tempChess setPosition:ccp(863, 384)];
				break;
			case ChineseChessGeneralR:
				[tempChess setPosition:ccp(161, 384)];
				break;
			default:
				break;
		}
		[self addChild:tempChess z:ZOrderChess];
		if (tempChess.type %2 == 0) {
			[tempChess setRotation:90];
		}
		else{
			[tempChess setRotation:270];
		}
	}
}
-(void)changeNote:(id)player{
	
}

-(void)moveChess:(id)moveChess withX:(int)x withY:(int)y{
	
}

@end
