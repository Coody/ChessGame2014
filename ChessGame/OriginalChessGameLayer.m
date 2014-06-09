//
//  OriginalChessGameLayer.m
//  ChessGame
//
//  Created by CoodyChou on 12/10/31.
//
//

#import "OriginalChessGameLayer.h"
#import "Constant.h"
#import "ChineseChess.h"

@implementation OriginalChessGameLayer

-(id)init{
	self = [super initWithColor:ccc4(255, 255, 255, 255)];
	if (self != nil) {
		gameBoard = [[GameBoard alloc]init];
		firstPlayer =[[Player alloc]init];
		secondPlayer = [[Player alloc]init];
		[gameBoard createAllChess];
		[gameBoard initialChessPosition];
	}
	return self;
}

-(void)dealloc{
	[gameBoard release];
	[super dealloc];
}

#pragma mark -
#pragma mark GameBoardDelegate

-(void)createChess{
	
}
-(BOOL)gameRuleWithRecentTouch:(int)recentTouch withBeforeTouch:(int)beforeTouch{
	return NO;
}
-(void)setChessPosition{
	
}
-(void)changeNote:(id)player{
	
}

-(void)moveChess:(id)moveChess withX:(int)x withY:(int)y{
	
}

@end
