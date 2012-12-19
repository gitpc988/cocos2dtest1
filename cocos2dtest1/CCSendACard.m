//
//  CCSendACard.m
//  cocos2dtest1
//
//  Created by 林 波 on 12-9-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CCSendACard.h"
#import "cocos2d.h"
#import "defineCard.h"
#import "SimpleAudioEngine.h"
#define CCSENDACARDTIME 0.4f
@implementation CCSendACard
@synthesize sendACardDelegate=_sendACardDelegate;
@synthesize action_value;


+(id)SpiderWithParentNode:(CCNode *)parentNode;
{
    return [[[self alloc] initWithParentNode:parentNode] autorelease];
}
-(id)initWithParentNode:(CCNode *)parentNode;
{
    if ((self=[super init])) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        spiderSprite =[CCSprite spriteWithSpriteFrameName:backImageLargeFalse];
        [spiderSprite setPosition:ccp(size.width /2 , size.height/2 )];
        [parentNode addChild:spiderSprite z:40];
    }
    return self;
}
#pragma mark 庄家局模式 发牌
-(void)initPosition{
    spiderSprite.position = ccp(ScreenSize.width/8, ScreenSize.height*4/5);
}
-(void)action_zero{
    [self initPosition];
    id moveTo = [CCMoveTo actionWithDuration:CCSENDACARDTIME/2 position:ccp(ScreenSize.width/3, ScreenSize.height*4/5)];
    id rotate = [CCRotateTo actionWithDuration:CCSENDACARDTIME/2 angle:(360*2)];
    id spawn = [CCSpawn actions:moveTo,rotate, nil];
    id callBack = [CCCallFuncN actionWithTarget:self selector:@selector(action_Complete)];
    id se = [CCSequence actions:spawn,callBack, nil];
    [spiderSprite runAction:se];
    self.action_value = LOCATION_ZERO;
}
-(void)action_one{
    [self initPosition];
    id moveTo = [CCMoveTo actionWithDuration:CCSENDACARDTIME/2 position:ccp(ScreenSize.width/6, ScreenSize.height*3/8)];
    id rotate = [CCRotateTo actionWithDuration:CCSENDACARDTIME/2 angle:(360*2)];
    id spawn = [CCSpawn actions:moveTo,rotate, nil];
    id callBack = [CCCallFuncN actionWithTarget:self selector:@selector(action_Complete)];
    id se = [CCSequence actions:spawn,callBack, nil];
    [spiderSprite runAction:se];
    self.action_value = LOCATION_ONE;
}
-(void)action_two{
    [self initPosition];
    id moveTo = [CCMoveTo actionWithDuration:CCSENDACARDTIME/2 position:ccp(ScreenSize.width*3/8, ScreenSize.height*3/8)];
    id rotate = [CCRotateTo actionWithDuration:CCSENDACARDTIME/2 angle:(360*2)];
    id spawn = [CCSpawn actions:moveTo,rotate, nil];
    id callBack = [CCCallFuncN actionWithTarget:self selector:@selector(action_Complete)];
    id se = [CCSequence actions:spawn,callBack, nil];
    [spiderSprite runAction:se];
    self.action_value = LOCATION_TWO;
}
-(void)action_three{
    [self initPosition];
    id moveTo = [CCMoveTo actionWithDuration:CCSENDACARDTIME/2 position:ccp(ScreenSize.width*4/6, ScreenSize.height*3/8)];
    id rotate = [CCRotateTo actionWithDuration:CCSENDACARDTIME/2 angle:(360*2)];
    id spawn = [CCSpawn actions:moveTo,rotate, nil];
    id callBack = [CCCallFuncN actionWithTarget:self selector:@selector(action_Complete)];
    id se = [CCSequence actions:spawn,callBack, nil];
    [spiderSprite runAction:se];
    self.action_value = LOCATION_THREE;
}
-(void)action_four{
    [self initPosition];
    id moveTo = [CCMoveTo actionWithDuration:CCSENDACARDTIME/2 position:ccp(ScreenSize.width*5/6, ScreenSize.height*3/8)];
    id rotate = [CCRotateTo actionWithDuration:CCSENDACARDTIME/2 angle:(360*2)];
    id spawn = [CCSpawn actions:moveTo,rotate, nil];
    id callBack = [CCCallFuncN actionWithTarget:self selector:@selector(action_Complete)];
    id se = [CCSequence actions:spawn,callBack, nil];
    [spiderSprite runAction:se];
    self.action_value = LOCATION_FORE;
}
#pragma mark 四人局模式 发牌
/**
 *向上发牌
 */
-(void)action_up
{
    //  NSAssert(nil, @"Argument must be non-nil,this is  message in the card class");
    CGSize size = [[CCDirector sharedDirector] winSize];

    CCMoveBy* move = [CCMoveTo actionWithDuration:CCSENDACARDTIME
                                         position:ccp( size.width/2, size.height-spiderSprite.contentSize.height/2) ];
    CCCallFunc* callback = [CCCallFunc actionWithTarget:self selector:@selector(action_Complete)];
    
    [spiderSprite runAction:[CCSequence actions:move,callback, nil]];
    self.action_value=LOCATION_UP;
}


/**
 *向下发牌
 */
-(void)action_down
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCMoveBy* move = [CCMoveTo actionWithDuration:CCSENDACARDTIME
                                         position:ccp( size.width/2, spiderSprite.contentSize.height/2) ];
    CCCallFunc* callback = [CCCallFunc actionWithTarget:self selector:@selector(action_Complete)];
    
    [spiderSprite runAction:[CCSequence actions:move,callback, nil]];
    self.action_value=LOCATION_DOWN;
}

/**
 *向左发牌
 */
-(void)action_left
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCMoveBy* move = [CCMoveTo actionWithDuration:CCSENDACARDTIME
                                         position:ccp( spiderSprite.contentSize.width/2, size.height/2) ];
    CCCallFunc* callback = [CCCallFunc actionWithTarget:self selector:@selector(action_Complete)];
    
    [spiderSprite runAction:[CCSequence actions:move,callback, nil]];
    self.action_value=LOCATION_LEFT;
}

/**
 *向右发牌
 */
-(void)action_right
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCMoveBy* move = [CCMoveTo actionWithDuration:CCSENDACARDTIME
                                         position:ccp( size.width- spiderSprite.contentSize.width/2, size.height/2) ];
    CCCallFunc* callback = [CCCallFunc actionWithTarget:self selector:@selector(action_Complete)];
    
    [spiderSprite runAction:[CCSequence actions:move,callback, nil]];
    self.action_value=LOCATION_RIGHT;
}



-(void)action_Complete
{
//   CCLOG(@"动作已经完成");
    if(self.sendACardDelegate!=nil)
    {
        if ( [self.sendACardDelegate respondsToSelector:@selector(action_Complete:) ]) {
            [self.sendACardDelegate action_Complete:self.action_value];
        }
    }
    [spiderSprite removeFromParentAndCleanup:YES];
}

-(void) dealloc
{
  //   CCLOG(@"删除对像");
    [super dealloc];
}
@end
