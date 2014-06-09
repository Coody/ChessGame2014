//
//  Player.h
//  ChessGame
//
//  Created by CoodyChou on 12/10/27.
//
//

#import "GameBoard.h"
#import "cocos2d.h"

@interface Player : CCNode{
    NSString *name;
	int chessColor;
	int deadChessArrayCount;
	int recentTouchObjectIndex;
    
}

@property (nonatomic,retain) NSString *name;
@property (readwrite) int chessColor;
@property (readwrite) int deadChessArrayCount;

-(int)getRecentTouchObjectIndex;
-(void)setRecentTouchObjectIndex:(int)index withType:(int)type;

@end
