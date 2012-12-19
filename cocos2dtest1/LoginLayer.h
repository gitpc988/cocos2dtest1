//
//  LoginLayer.h
//  cocos2dtest1
//
//  Created by 林 波 on 12-9-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "cocos2d.h"


@interface LoginLayer : CCLayer <UITextFieldDelegate> {
    UITextField *userTextField;
    UITextField *passWordField;
    UITextField *userLabel;
    UITextField *passwordLabel;
}
+(CCScene *) scene;
@end
