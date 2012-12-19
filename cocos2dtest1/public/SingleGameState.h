//
//  SingleGameState.h
//  cocos2dtest1
//
//  Created by plllp on 12-12-12.
//  Copyright (c) 2012年 Architectures. All rights reserved.
//

#import <Foundation/Foundation.h>
enum CowTag{
	goldCow = 2,
    silverCow =1,
    normalCow = 0,
};
@interface SingleGameState : NSObject{
    int deskTotalCash;
}


+(SingleGameState *)sharedSingleGameState;

@property(nonatomic,assign)int deskTotalCash;
@end
