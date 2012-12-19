//
//  GameSocket.h
//  cocos2dtest1
//
//  Created by 林 波 on 12-9-20.
//
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
@interface GameSocket : NSObject
{
    AsyncSocket *asyncSocket;
}

-(void)connect:(NSString *)host onPort:(int)port ;
-(void)send:(NSString *)nsdata;

@end
