//
//  ChineseChess.h
//  ChessGame
//
//  Created by CoodyChou on 12/10/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chess.h"
#import "Constant.h"

@interface ChineseChess : Chess {
    ChineseChessType type;
	BOOL openOrNot;
	BOOL deadOrNot;
}

@property (readwrite) ChineseChessType type;
@property (readwrite) BOOL deadOrNot;

-(BOOL)getOpenOrNot;
-(void)setOpenOrNot:(BOOL)tempBool;

@end
