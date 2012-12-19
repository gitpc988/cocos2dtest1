//
//  ChipElement.m
//  cocos2dtest1
//
//  Created by plllp on 12-12-10.
//  Copyright 2012年 Architectures. All rights reserved.
//

#import "ChipElement.h"
#import "public/SingleGameState.h"

@implementation ChipElement

+initWithScene:(id)scene iconNum:(int)iconNum{
    NSString *tempImageName;
    //    int tempNum =  arc4random()%6;
    int cashNum = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserCash"] intValue]/10;
    int i =0;
    switch (iconNum) {
        case 0:{
            i = cashNum>=100?1:5;
            tempImageName = @"chip1_0%d.png";
        }break;
        case 1:{
            i = cashNum>=1000?1:5;
            tempImageName = @"chip2_0%d.png";
        }break;
        case 2:{
            i = cashNum>=10000?1:5;
            tempImageName = @"chip3_0%d.png";
        }break;
        case 3:{
            i = cashNum>=50000?1:5;
            tempImageName = @"chip4_0%d.png";
        } break;
        case 4:{
            i = cashNum>=100000?1:5;
            tempImageName = @"chip5_0%d.png";
        }break;
        case 5:{
            i = cashNum>=500000?1:5;
            tempImageName = @"chip6_0%d.png";
        }break;
        case 6:{
            i = cashNum>=1000000?1:5;
            tempImageName = @"chip7_0%d.png";
        }break;
        case 7:{
            i = cashNum>=5000000?1:5;
            tempImageName = @"chip8_0%d.png";
        }break;
        default:{
            i = cashNum>=100?1:5;
            tempImageName = @"chip1_0%d.png";
        }break;
    }
    id p =  [[self class] spriteWithSpriteFrameName:[NSString stringWithFormat:tempImageName,i]];
    if (p !=nil) {
        [p setScene:scene cTag:iconNum imageName:tempImageName];
    }else{
        NSAssert(NO, @"没有加载材质文件");
    }
    return p;
}


-(void)setScene:(id)scene  cTag:(int)cTag imageName:(NSString *)imageName{
    selfScene = scene;
    _chipTag = cTag;
    imageString = imageName;
    self.scale = 0.8;
    [scene addChild:self];
}
#pragma mark 获取chip 的状态
-(int)getChipStatus{
    int cashNum = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserCash"] intValue]/10;
    cashNum -=[SingleGameState sharedSingleGameState].deskTotalCash;
    int i =0;
    switch (_chipTag) {
        case 0:{
            i = cashNum>=100?1:5;
        }break;
        case 1:{
            i = cashNum>=1000?1:5;
        }break;
        case 2:{
            i = cashNum>=10000?1:5;
        }break;
        case 3:{
            i = cashNum>=50000?1:5;
        } break;
        case 4:{
            i = cashNum>=100000?1:5;
        }break;
        case 5:{
            i = cashNum>=500000?1:5;
        }break;
        case 6:{
            i = cashNum>=1000000?1:5;
        }break;
        case 7:{
            i = cashNum>=5000000?1:5;
        }break;
        default:{
            i = cashNum>=100?1:5;
        }break;
    }
    return i;
}
#pragma mark 获取chip代表的金币数量
-(int)getResponseCash{
    int tempCash = 0;
    switch (_chipTag) {
        case 0:
            tempCash = 100;
            CCLOG(@"一百");
            break;
        case 1:
            tempCash = 1000;
            CCLOG(@"一千");
            break;
        case 2:
            tempCash = 10000;
            CCLOG(@"一万");
            break;
        case 3:
            tempCash = 50000;
            CCLOG(@"5万");
            break;
        case 4:
            tempCash = 100000;
            CCLOG(@"10万");
            break;
        case 5:
            tempCash = 500000;
            CCLOG(@"50万");
            break;
        case 6:
            tempCash = 1000000;
            CCLOG(@"100万");
            break;
        case 7:
            tempCash = 5000000;
            CCLOG(@"500万");
            break;
    }
    return tempCash;
}
//获取小球的碰撞检测范围
-(CGRect)getChipRect{
    return CGRectMake(self.position.x-(self.contentSize.width/2), self.position.y-(self.contentSize.height/2), self.contentSize.width, self.contentSize.height);
}

-(void)runChipCheckAction{
    [self stopAllActions];
    
    NSMutableArray *actionArray = [[NSMutableArray alloc] init];
    
    for (int i=1; i<=5; i++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:imageString,i]];
//        CCLOG(@"%@",[NSString stringWithFormat:imageString,i]);
        [actionArray addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:actionArray];
    animation.delayPerUnit = 0.4f/5.0f;
    
    id repeat = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    id ac = [CCSequence actions:repeat, nil];
    
    [self runAction:ac];
    
    [actionArray release];
    

//    CCLOG(@"选中");
}
-(void)runChipRestAction{
    int i =[self getChipStatus];
    
    [self stopAllActions];
    NSMutableArray *actionArray = [[NSMutableArray alloc] init];
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:imageString,i]];
    [actionArray addObject:frame];
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:actionArray];
    animation.delayPerUnit = 0.1f/1.0f;
    
    id repeat = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    id ac = [CCSequence actions:repeat, nil];
    
    [self runAction:ac];
    
    [actionArray release];
//    CCLOG(@"休息");
}
#pragma mark CCTargetedTouchDelegate  
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self getChipStatus]>1) {
        return NO;
    }
    
	if ( ![self containsTouchLocation:touch] )
	{
		return NO;
	}
    CGPoint pooint = [self convertTouchToNodeSpaceAR:touch];
    
    
    [selfScene changeRunAction:_chipTag];
    
//    CCLOG(@"point===%f===%f",pooint.x,pooint.y);
	return YES;
}
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
//    
//	CGPoint touchPoint = [touch locationInView:[touch view]];
//	
//	touchPoint = [[CCDirector sharedDirector] convertToUI:CGPointMake(touchPoint.x, touchPoint.y)];
//	
//    
//	self.position = CGPointMake(touchPoint.x, touchPoint.y);
}
- (void) onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}
- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onExit];
}
- (CGRect)rect
{
    return CGRectMake(-(self.contentSize.width*0.8) / 2, -(self.contentSize.height*0.8) / 2, self.contentSize.width*0.8, self.contentSize.height*0.8);
}
- (BOOL)containsTouchLocation:(UITouch *)touch
{
    return CGRectContainsPoint(self.rect, [self convertTouchToNodeSpaceAR:touch]);
}
@end
