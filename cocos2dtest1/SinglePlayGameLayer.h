//
//  SinglePlayGameLayer.h
//  cocos2dtest1
//
//  Created by plllp on 12-12-8.
//  Copyright 2012年 Architectures. All rights reserved.
//
#define cardCountTotal 25                       //发牌的总数量

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCSendACard.h"
#import "CCInOnesHand.h"
#import "ChipElement.h"

@interface SinglePlayGameLayer : CCLayer<CCSendACardDelegate,ChipElementDelegate> {
    CCInOnesHand *bankPlayer,*playerOne,*playerTwo,*playerThree,*playerFour;
        
    NSMutableArray *cardNumArray;
    NSMutableArray *chipArray;
    
    bool isSendCardsEnd;
    bool isStopBet;          // 是否停止押注
    bool isStartAccounts;
    
    int card_count;
    
    CCMenu *menu;
    CCLabelTTF *userCashLab,*deskCashLab1,*deskCashLab2,*deskCashLab3,*deskCashLab4;
    
    int playerCountNum;
    
    ChipElement *tempCheckChip;         //保存当前选中的筹码
    
    int deskCash1,deskCash2,deskCash3,deskCash4;
    
    int bankerTag;
    
}
@property(nonatomic,assign) int card_count;
@property(nonatomic,retain) CCInOnesHand *bankPlayer;
@property(nonatomic,retain) CCInOnesHand *playerOne;
@property(nonatomic,retain) CCInOnesHand *playerTwo;
@property(nonatomic,retain) CCInOnesHand *playerThree;
@property(nonatomic,retain) CCInOnesHand *playerFour;

+(CCScene *)scene;
-(id)init;

@end
