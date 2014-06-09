//
//  ChineseChess.m
//  ChessGame
//
//  Created by CoodyChou on 12/10/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ChineseChess.h"

@interface ChineseChess ()
-(NSString *)changeChessTypeToString:(ChineseChessType)chessType;
@end
@implementation ChineseChess
@synthesize deadOrNot;
@synthesize type;

-(id)initWithFile:(NSString *)filename{
	self = [super initWithFile:filename];
	[self setScale:0.8];
	if (self != nil) {
		type = ChineseChessERROR;
		openOrNot = NO;
		deadOrNot = NO;
	}
	return self;
}

-(BOOL)getOpenOrNot{
	return openOrNot;
}
-(void)setOpenOrNot:(BOOL)tempBool{
	openOrNot = tempBool;
	if (openOrNot == YES) {
		self.canMoveOrNot = YES;
		UIImage *tempChangeImage = [UIImage imageNamed:[self changeChessTypeToString:self.type]];
		CCTexture2D  *newTexture=[[CCTextureCache sharedTextureCache]  addCGImage:tempChangeImage.CGImage forKey:nil];
		[self setTexture:newTexture];
	}
	else{
		self.canMoveOrNot = NO;
	}
}

-(NSString *)changeChessTypeToString:(ChineseChessType)chessType{
	NSString *tempChessTypeString ;
	switch (chessType) {
		case ChineseChessSoldierB:
			tempChessTypeString = [NSString stringWithFormat:@"SoldierB.png"];
			break;
		case ChineseChessSoldierR:
			tempChessTypeString = [NSString stringWithFormat:@"SoldierR.png"];
			break;
		case ChineseChessHorseB:
			tempChessTypeString = [NSString stringWithFormat:@"HorseB.png"];
			break;
		case ChineseChessHorseR:
			tempChessTypeString = [NSString stringWithFormat:@"HorseR.png"];
			break;
		case ChineseChessCannonB:
			tempChessTypeString = [NSString stringWithFormat:@"CannonB.png"];
			break;
		case ChineseChessCannonR:
			tempChessTypeString = [NSString stringWithFormat:@"CannonR.png"];
			break;
		case ChineseChessChariotB:
			tempChessTypeString = [NSString stringWithFormat:@"ChariotB.png"];
			break;
		case ChineseChessChariotR:
			tempChessTypeString = [NSString stringWithFormat:@"ChariotR.png"];
			break;
		case ChineseChessElephantB:
			tempChessTypeString = [NSString stringWithFormat:@"ElephantB.png"];
			break;
		case ChineseChessElephantR:
			tempChessTypeString = [NSString stringWithFormat:@"ElephantR.png"];
			break;
		case ChineseChessAdvisorB:
			tempChessTypeString = [NSString stringWithFormat:@"AdvisorB.png"];
			break;
		case ChineseChessAdvisorR:
			tempChessTypeString = [NSString stringWithFormat:@"AdvisorR.png"];
			break;
		case ChineseChessGeneralB:
			tempChessTypeString = [NSString stringWithFormat:@"GeneralB.png"];
			break;
		case ChineseChessGeneralR:
			tempChessTypeString = [NSString stringWithFormat:@"GeneralR.png"];
			break;
		default:
			tempChessTypeString = [NSString stringWithFormat:@"Close.png"];
			break;
	}
	return tempChessTypeString;
}

@end
