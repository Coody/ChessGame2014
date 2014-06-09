//
//  GameBoardDelegate.h
//  ChessGame
//
//  Created by CoodyChou on 12/10/25.
//
//

#import <Foundation/Foundation.h>

@protocol GameBoardDelegate <NSObject>

-(void)createChess;
-(BOOL)gameRuleWithRecentTouch:(int)recentTouch withBeforeTouch:(int)beforeTouch;
-(void)setChessPosition;
-(void)changeNote:(id)player;

@end
