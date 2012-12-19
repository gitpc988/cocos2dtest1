//
//  card.h
//  cocos2dtest1
//
//  Created by 林 波 on 12-9-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//联机模式 4人局
#define LOCATION_UP 1
#define LOCATION_DOWN 2
#define LOCATION_LEFT 3
#define LOCATION_RIGHT 4


//单机模式  庄家发牌
#define LOCATION_ZERO 10
#define LOCATION_ONE 11
#define LOCATION_TWO 12
#define LOCATION_THREE 13
#define LOCATION_FORE 14

@protocol CCCardDelegate <NSObject>

@end

@interface CCCard : NSObject {
    int _cardValue;
    CCNode * _parentNode;
    CCSprite *card;
    Boolean _large;
    Boolean _highLight;
    CGPoint startPos;
    int location_y;
}
@property(nonatomic ,assign) int cardValue;
@property(nonatomic ,assign) Boolean large;
@property(nonatomic,assign) CCNode *parentNode;
/** 
 * 实例化纸牌精灵
 * @param int  t_cardValue 纸牌的数值大小      1-13    为红桃 A 2 3 4 5 6 7 8 9 10 J Q K
 *                                          14-26   为方块 A 2 3 4 5 6 7 8 9 10 J Q K
 *                                          27-39   为草花 A 2 3 4 5 6 7 8 9 10 J Q K
 *                                          40－52   为黑桃 A 2 3 4 5 6 7 8 9 10 J Q K 
 *                                          53       小王     54 大王
 * @param Boolean t  true:正面描绘   false:反面描绘
 * @param Boolean large_value   true:显示大图   false:显示小图
 * @param CCNode ParentNode 父节点
 * @return 初始化后的纸牌精灵
 */
+(id)cardWithParentNode:(int)t_cardValue frontality:(Boolean)t large:(Boolean)large_value ParentNode:(CCNode *)parentNode;
-(id)initWithParentNode:(int)t_cardValue frontality:(Boolean)t large:(Boolean)large_value ParentNode:(CCNode *)parentNode;
/**
 *
 *设置精灵位置
 */
-(void)setPosition:(CGFloat)x Y:(CGFloat)y;
-(CGPoint)getPosition;
/**
 *近回当前纸牌类型
 *@return int 返回值 1:红桃 2:方块 3:草花 4:黑桃 5:小王 6:大王
 */
-(int)getCardKind;

/*
 *添加纸牌类型图标
 *
 */
-(void)addChildKind;

/*
 *
 *添加纸牌上的数字
 *
 */
-(void)addChildValue;

/*
 * 取回当前长高
 */
-(CGSize)getContentSize;

/*
 *设置Z
 */
-(void)setZ:(int)z;

/*
 *设角度
 */
-(void)setrotate:(float)rotate;

/*
 *取纸牌上的点数
 */
-(int)getcardNumber;
/*
 * 返回ＮＮ 点数
 */
-(int)getcardNumberNN;

/*
 *高亮显示
 */
-(Boolean)highLight;

/*
 *重设高度
 */
-(void)restY;
/*
 让卡片显示
 */
-(void)setDisplay:(BOOL)frontality;

-(void)clean;

@end
