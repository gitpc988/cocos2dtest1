//
//  CCInOnesHand.h
//  cocos2dtest1
//
//  Created by 林 波 on 12-9-22.
//
//  此类实现手中纸牌动作显示

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@protocol CCInOnesHandDelegate <NSObject>

//-(void)refleshShowLabel;                    //刷新界面显示的label

@end
enum{
    SHOWLEFT = 1,
    SHOWDOWN = 2,
};
@interface CCInOnesHand : NSObject
{
    NSMutableArray *cards;
    int location;
    int cashCount;
    
    id parent;
    CGPoint _point;
    
    CCLabelTTF *bankPoint,*settleAccounts;
    
    id <CCInOnesHandDelegate> *delegate;
}
@property(nonatomic,retain) NSMutableArray * cards;
@property(nonatomic,assign) int location;
@property(nonatomic,assign) int cashCount;
@property(nonatomic,assign) id<CCInOnesHandDelegate> *deleagete;
@property(nonatomic,retain) id parent;
/*
* 实例化纸牌精灵
* @param int  t_cardValue 纸牌的数值大小      1-13    为红桃 A 2 3 4 5 6 7 8 9 10 J Q K
*                                          14-26   为方块 A 2 3 4 5 6 7 8 9 10 J Q K
*                                          27-39   为草花 A 2 3 4 5 6 7 8 9 10 J Q K
*                                          40－52   为黑桃 A 2 3 4 5 6 7 8 9 10 J Q K
*                                          53       小王     54 大王
* @param Boolean t  true:正面描绘   false:反面描绘
* @param CCNode ParentNode 父节点
* @return 初始化后的纸牌精灵
*/
+(id)SpiderWithParentNode ;
-(id)initWithParentNode ;

/*
 获得排序后的号码
 */
-(NSMutableArray *)getCardNumArray;

/*
 *
 *添加纸牌 
 *
 */
-(void)addCard:(CCNode *)parentNode cardValue:(int)t_cardValue frontality:(Boolean)t large:(Boolean)t_large;

/*
 *显示纸牌
 *
 */
-(void)cardDisplay:(Boolean)range;

/**
 *当然有多少张牌
 */
-(int)count;

/**
 *返回该用户获得的点数
 */
-(int)getCardPoint;
/*
 *提示 5 张牌里三张组合为10 个倍数，
 */

-(void)prompt;

/*
 *取回三张牌的sum value    
 */

-(int)getPrompt:(int)a b:(int)b c:(int)c;


/*
 *选取纸牌 or 取消选取纸牌
 */
-(Boolean)selectit:(CGPoint) point;
/*
 *重设Ｙ
 */
-(void)restY;

/*
 *cleancard
 */
-(void)cleancard;

/*
 *输了，减掉输掉的金币数量
 */
-(void)subCashCount:(int)cash;


/*
 *赢了，加上赢的金币数量
 */
-(void)addCashCount:(int)cash;

/*
 显示点数 的label
 */
-(void)showPointLab:(int)showPos;
/*
 显示结算金币
 */
-(void)showAccounts:(int)cash isAdd:(BOOL)isAdd;
@end
