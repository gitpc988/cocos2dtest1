//
//  loadView.m
//  cocos2dtest1
//
//  Created by 林 波 on 12-9-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "loadView.h"
#import "LoginLayer.h"
#import "PlayGameLayer.h"
#import "SinglePlayGameLayer.h"
@implementation loadView

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	loadView *layer = [loadView node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
-(id)init{
    if( (self=[super init])) {
        
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"UserCash"] intValue] < 200000) {
            [[NSUserDefaults standardUserDefaults] setInteger:200000 forKey:@"UserCash"];
        }
        
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background=[CCSprite spriteWithFile:@"Default.png"];
        [background setRotation:-90];
        [background setPosition:ccp(size.width/2 ,size.height/2)];
        [self addChild:background z:-1];
        
        
        singlePlayer=[CCMenuItemFont itemFromString:@"单机游戏" target:self selector:@selector(singlePlayer_Function)];
        singlePlayer.position=ccp(size.width/6*5,size.height/10 *8);
        
        netWorkPlayer=[CCMenuItemFont itemFromString:@"联机游戏" target:self selector:@selector(netWorkPlayer_Function)];
        netWorkPlayer.position=ccp(size.width/6*5,size.height/10 *5);
        
        settingGame=[CCMenuItemFont itemFromString:@"游戏设置" target:self selector:@selector(settingGame_Function)];
        settingGame.position=ccp(size.width/6*5,size.height/10 *2);

        CCMenu *menu=[CCMenu menuWithItems:singlePlayer ,netWorkPlayer,settingGame, nil];
        [menu setPosition:ccp(0, 0)];
        [self addChild:menu];
        
    }
    return self;
}
-(void)singlePlayer_Function{
    [[CCDirector sharedDirector] replaceScene:[SinglePlayGameLayer scene]];
}
-(void)netWorkPlayer_Function
{
     [[CCDirector sharedDirector] replaceScene:[PlayGameLayer scene]];
}
-(void)settingGame_Function{
    
}
-(void)dealloc
{
    [super dealloc];
}

@end
