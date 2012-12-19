//
//  loadView.h
//  cocos2dtest1
//
//  Created by 林 波 on 12-9-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface loadView : CCLayer {
    CCMenuItem *singlePlayer,*netWorkPlayer,*settingGame;
}

+(CCScene *) scene;

@end
