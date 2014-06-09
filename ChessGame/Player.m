//
//  Player.m
//  ChessGame
//
//  Created by CoodyChou on 12/10/27.
//
//

#import "Player.h"
#import "Constant.h"

#import <CoreFoundation/CoreFoundation.h>

@implementation Player
@synthesize chessColor;
@synthesize deadChessArrayCount;
@synthesize name;

-(id)init{
	self = [super init];
	if (self != nil) {
        name = @"none";
		deadChessArrayCount = 0;
		recentTouchObjectIndex = -1;
		chessColor = ChessColorUnknown;
	}
	return self;
}

-(int)getRecentTouchObjectIndex{
	return recentTouchObjectIndex;
}

-(void)setRecentTouchObjectIndex:(int)index withType:(int)type{
	if ( chessColor != type%2 ) {
		CCLOG(@"顏色不同：%d" , chessColor);
		return;
	}
	else{
		CCLOG(@"顏色相同!!!");
		recentTouchObjectIndex = index;
	}
}


@end
