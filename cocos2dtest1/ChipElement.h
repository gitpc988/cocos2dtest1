//
//  ChipElement.h
//  cocos2dtest1
//
//  Created by plllp on 12-12-10.
//  Copyright 2012年 Architectures. All rights reserved.
//
@protocol ChipElementDelegate <NSObject>

@optional
-(void)changeRunAction:(int)selfTag;
@end
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ChipElement : CCSprite<CCTargetedTouchDelegate> {
    id selfScene;
    int _chipTag;
    NSString *imageString;
}
@property(nonatomic,assign) int chipTag;

+initWithScene:(id)scene iconNum:(int)iconNum ;
-(void)setScene:(id)scene cTag:(int)cTag imageName:(NSString *)imageName;

-(void)runChipCheckAction;
-(void)runChipRestAction;

-(CGRect)getChipRect;  //获取小球的碰撞检测范围
-(int)getResponseCash;
@end
