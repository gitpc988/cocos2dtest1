//
//  CCSendACard.h
//  cocos2dtest1
//
//  Created by 林 波 on 12-9-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//  此类主要实现在发牌动作

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "card.h"

@protocol CCSendACardDelegate<NSObject>

/**
 *@param int type_value
 *                      LOCATION_UP   向上发动作完成
 *                      LOCATION_DOWN   向下发动作完成
 *                      LOCATION_LEFT   向左发动作完成
 *                      LOCATION_RIGHT   向右发动作完成
 */

-(void)action_Complete:(int)type_value;

@end


@interface CCSendACard : NSObject {
    id <CCSendACardDelegate> _sendACardDelegate;
    CCSprite * spiderSprite;
   // int action_value;
}
@property(nonatomic,assign)id <CCSendACardDelegate> sendACardDelegate;
@property(nonatomic,assign) int action_value;
/**
 *初始化发牌动作
 */

+(id)SpiderWithParentNode:(CCNode *)parentNode;
-(id)initWithParentNode:(CCNode *)parentNode;

/**
 *向上发牌
 */
-(void)action_up;

/**
 *向下发牌
 */
-(void)action_down;

/**
 *向左发牌
 */
-(void)action_left;

/**
 *向右发牌
 */
-(void)action_right;


-(void)action_zero;
-(void)action_one;
-(void)action_two;
-(void)action_three;
-(void)action_four;
/*
 *
 *动作完成后执行
 *
 */
-(void)action_Complete;
@end

/*
 类的使用方法
 在使用的父类中实现在协议action_Complete  下面是              1
                                                    2       4
                                                        3
                                        上面的发牌顺序
 -(void)action_Complete:(int)type_value
 {
 CCLOG(@"%d",type_value);
 switch (type_value) {
 case 1:
 {
 CCSendACard *c =[CCSendACard  SpiderWithParentNode:self];
 [c setSendACardDelegate:self];
 [c action_left];
 }
 break;
 case 2:
 {
 CCSendACard *c =[CCSendACard  SpiderWithParentNode:self];
 [c setSendACardDelegate:self];
 [c action_up];
 }
 break;
 case 3:
 {
 CCSendACard *c =[CCSendACard  SpiderWithParentNode:self];
 [c setSendACardDelegate:self];
 [c action_right];
 }
 break;
 case 4:
 {
 CCSendACard *c =[CCSendACard  SpiderWithParentNode:self];
 [c setSendACardDelegate:self];
 [c action_down];
 }
 break;
 
 default:
 break;
 }
 }
 */
