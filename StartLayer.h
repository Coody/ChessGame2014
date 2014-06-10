//
//  StartLayer.h
//  ChessGame
//
//  Created by CoodyChou on 12/10/24.
//
//

#import "cocos2d.h"
#import "CCLayer.h"
#import "Constant.h"
#import <UIKit/UIKit.h>

@interface StartLayer : CCLayer <UIAlertViewDelegate>{
	CCMenu *mainMenu;
    
    UIAlertView *alertView;
}

@end
