//
//  GameSocket.m
//  cocos2dtest1
//
//  Created by 林 波 on 12-9-20.
//
//

#import "GameSocket.h"

@implementation GameSocket

-(void) send:(NSString *)nsdata
{
    NSData* aData= [nsdata dataUsingEncoding: NSUTF8StringEncoding];
    
    [asyncSocket writeData:aData withTimeout:-1 tag:0];
    [asyncSocket readDataWithTimeout:-1 tag:0];
}
-(void) connect:(NSString *)host onPort:(int)port
{
    asyncSocket=[[AsyncSocket alloc] initWithDelegate:self];
    NSError *err=nil;
    if (![asyncSocket connectToHost:host  onPort:port error:&err]) {
        NSLog(@"Error : %@",err);
    }else
    {
        [asyncSocket readDataWithTimeout:-1 tag:0];
        NSLog(@"connecting ... OK");
    }
}


- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"thread(%@),onSocket:%p didConnectToHost:%@ port:%hu", [[NSThread currentThread] name], sock, host, port);
    
    // 等待数据接收
    [asyncSocket readDataWithTimeout:-1 tag:0];
}

- (void)onSocketDidSecure:(AsyncSocket *)sock
{
    NSLog(@"thread(%@),onSocketDidSecure:%p", [[NSThread currentThread] name], sock);
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"thread(%@),onSocket:%p willDisconnectWithError:%@", [[NSThread currentThread] name], sock, err);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"thread(%@),onSocketDidDisconnect:%p", [[NSThread currentThread] name], sock);
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"thread(%@),onSocket:%p, %ld, %@", [[NSThread currentThread] name], sock, tag, data);
    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"===%@",aStr);
}


@end
