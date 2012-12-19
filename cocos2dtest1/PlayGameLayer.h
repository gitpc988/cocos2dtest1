//
//  HelloWorldLayer.h
//  cocos2dtest1
//
//  Created by 林 波 on 12-9-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "AsyncSocket.h"
#import "card.h"
#import "CCSendACard.h"
#import "CCInOnesHand.h"

#import "CCInOnesHandOperates.h"

// HelloWorldLayer
@interface PlayGameLayer : CCLayer <CCSendACardDelegate,CCInOnesHandDelegate>
{
    AsyncSocket *asyncSocket;
    CCMenu *cmenu;
    CCMenuItem *item1,*item2,*promptmenu,*resend,*nextRound;
    CCInOnesHand *hand1,*hand2,*hand3,*hand4;
    
    CCLabelTTF *labCashP1,*labCashP2,*labCashP3,*labCashP4;             //显示玩家的金币数量
    
    int bankerTag;                                              //当前庄家的标识
    CCLabelTTF *labBanker;                                      //显示庄家的label
    
    CGSize size;                    //纪录屏幕大小
    
    CCLabelTTF *messageLabel1;
    int startGameTime;
    int card_count;
    
    Boolean isSendCardsEnd;
    
    NSMutableArray *cardNumArray;
//    CCInOnesHandOperates *operates1;
}
//@property(nonatomic,assign) CCInOnesHandOperates *operates1;
@property (nonatomic ,retain) CCInOnesHand *hand1;
@property (nonatomic ,retain) CCInOnesHand *hand2;
@property (nonatomic ,retain) CCInOnesHand *hand3;
@property (nonatomic ,retain) CCInOnesHand *hand4;
@property (nonatomic ,assign) int card_count;
@property (nonatomic,assign) int bankerTag;

//@property (nonatomic,retain) CCSendACard   *c;
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void) connectToHost;
-(void) sendMessage;

//加载当前现金的label
-(void)loadCashLab;

//从四个玩家中随机出庄家
-(void)loadRandomBanker;
-(void)changeLabBankerPos:(int)randomNum;
@end
