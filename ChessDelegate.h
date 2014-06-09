//
//  ChessDelegate.h
//  ChessGame
//
//  Created by CoodyChou on 12/10/26.
//
//

#import <Foundation/Foundation.h>

@protocol ChessDelegate <NSObject>
@optional
-(void)moveChess:(id)moveChess withX:(int)x withY:(int)y;

@end
