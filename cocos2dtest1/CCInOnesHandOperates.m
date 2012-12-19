//
//  CCInOnesHandOperates.m
//  cocos2dtest1
//
//  Created by 林 波 on 12-9-23.
//
//

#import "CCInOnesHandOperates.h"
#import "SimpleAudioEngine.h"
@implementation CCInOnesHandOperates
@synthesize hand1;
@synthesize hand2;
@synthesize hand3;
@synthesize hand4;

+(id)SpiderWithParentNode:(CCNode *)t_parentNode
{
    return [[[self alloc] initWithParentNode:t_parentNode] autorelease];
}
-(id)initWithParentNode:(CCNode *)t_parentNode
{
    if ((self=[super init])) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        self.hand1 =[CCInOnesHand SpiderWithParentNode];
        self.hand2 =[CCInOnesHand SpiderWithParentNode];
        self.hand3 =[CCInOnesHand SpiderWithParentNode];
        self.hand4 =[CCInOnesHand SpiderWithParentNode];
        
        CCCard * card=[CCCard cardWithParentNode:17 frontality:false large:false ParentNode:t_parentNode];
        [card setPosition:size.width/2 Y:size.height/2];
        [card setZ:30];
        self.parentNode=t_parentNode;
    }
    return self;
}

-(void)action_Complete:(int)type_value
{
    
    float rand=CCRANDOM_0_1();
    
    //    CCLOG(@"%d",self.card_count);
    
    int card_value=rand * 54+1;
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"sendcard.wav"];
    
    switch (type_value) {
        case LOCATION_DOWN:
        {
            [hand1 setLocation:LOCATION_DOWN];
            [hand1 addCard:self.parentNode cardValue:card_value frontality:true large:true];
            [hand1 cardDisplay:true];
            
            if ([self.hand1 count] >=5) {
                return;
            }
            
            CCSendACard *c =[CCSendACard  SpiderWithParentNode:self.parentNode];
            [c setSendACardDelegate:self];
            [c action_left];
            
            
        }
            break;
        case LOCATION_LEFT:
        {
            
            [hand2 setLocation:LOCATION_LEFT];
            [hand2 addCard:self.parentNode cardValue:card_value frontality:true large:false];
            [hand2 cardDisplay:true];
            
            if ([self.hand2 count] >=5) {
                return;
            }
            CCSendACard *c =[CCSendACard  SpiderWithParentNode:self.parentNode];
            [c setSendACardDelegate:self];
            [c action_up];
        }
            break;
        case LOCATION_UP:
        {
            
            [hand3 setLocation:LOCATION_UP];
            [hand3 addCard:self.parentNode cardValue:card_value frontality:true large:false];
            [hand3 cardDisplay:true];
            
            if ([self.hand3 count] >=5) {
                return;
            }
            CCSendACard *c =[CCSendACard  SpiderWithParentNode:self.parentNode];
            [c setSendACardDelegate:self];
            [c action_right];
        }
            break;
        case LOCATION_RIGHT:
        {
            
            [hand4 setLocation:LOCATION_RIGHT];
            [hand4 addCard:self.parentNode cardValue:card_value frontality:true large:false];
            [hand4 cardDisplay:true];
            
            if ([self.hand4 count] >=5) {
                return;
            }
            CCSendACard *c =[CCSendACard  SpiderWithParentNode:self.parentNode];
            [c setSendACardDelegate:self];
            [c action_down];
            
        }
            break;
        default:
            break;
    }
}
-(void)send{
    CCSendACard *c =[CCSendACard  SpiderWithParentNode:self.parentNode];
    [c setSendACardDelegate:self];
    [c action_right];
}

-(void)dealloc
{
    [self.hand1 release];
    [self.hand2 release];
    [self.hand3 release];
    [self.hand4 release];
    [super dealloc];
}
@end
