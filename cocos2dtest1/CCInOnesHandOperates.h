//
//  CCInOnesHandOperates.h
//  cocos2dtest1
//
//  Created by 林 波 on 12-9-23.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "card.h"
#import "CCSendACard.h"
#import "CCInOnesHand.h"

@interface CCInOnesHandOperates : NSObject<CCSendACardDelegate>{
//    CCMenu *cmenu;
//    CCMenuItem *item1,*item2;
    CCInOnesHand *hand1,*hand2,*hand3,*hand4;
    
    
}
@property (nonatomic ,retain) CCInOnesHand *hand1;
@property (nonatomic ,retain) CCInOnesHand *hand2;
@property (nonatomic ,retain) CCInOnesHand *hand3;
@property (nonatomic ,retain) CCInOnesHand *hand4;
@property (nonatomic ,assign) CCNode *parentNode;

/**
 *初始化发牌动作
 */

+(id)SpiderWithParentNode:(CCNode *)t_parentNode;
-(id)initWithParentNode:(CCNode *)t_parentNode;
/*
 * 发牌
 */
-(void)send;

@end
