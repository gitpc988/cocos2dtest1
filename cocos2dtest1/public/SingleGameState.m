//
//  SingleGameState.m
//  cocos2dtest1
//
//  Created by plllp on 12-12-12.
//  Copyright (c) 2012年 Architectures. All rights reserved.
//

#import "SingleGameState.h"

@implementation SingleGameState
@synthesize deskTotalCash;
+(SingleGameState *)sharedSingleGameState{
    static SingleGameState *shared;
    @synchronized(shared)
    {
        if(!shared)
        {
            shared = [[SingleGameState alloc] init];
            //            shared.playerdai=NO;
        }
    }
    return shared;
}
-(id)init
{
    self=[super init];
    if (self) {
        deskTotalCash = 0;
    }
    return self;
}
@end
