//
//  card.m
//  cocos2dtest1
//
//  Created by 林 波 on 12-9-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "card.h"
#import "defineCard.h"


@implementation CCCard
@synthesize cardValue=_cardValue;
@synthesize large=_large;
@synthesize parentNode=_parentNode;

/**
 * 实例化纸牌精灵
 * @param int  t_cardValue 纸牌的数值大小      1-13    为方块 A 2 3 4 5 6 7 8 9 10 J Q K
 *                                          14-26   为草花 A 2 3 4 5 6 7 8 9 10 J Q K
 *                                          27-39   为红桃 A 2 3 4 5 6 7 8 9 10 J Q K
 *                                          40－52   为黑桃 A 2 3 4 5 6 7 8 9 10 J Q K
 *                                          53       小王     54 大王
 * @param Boolean t  true:正面描绘   false:反面描绘
 * @param Boolean large_value   true:显示大图   false:显示小图
 * @return 初始化后的纸牌精灵
 */

+(id)cardWithParentNode:(int)t_cardValue frontality:(Boolean)t large:(Boolean)large_value ParentNode:(CCNode *)parentNode
{
    return [[[self alloc] initWithParentNode:t_cardValue frontality:t large:large_value ParentNode:parentNode] autorelease];
}
-(id)initWithParentNode:(int)t_cardValue frontality:(Boolean)t large:(Boolean)large_value ParentNode:(CCNode *)parentNode
{
    if ((self=[super init])) {
        _highLight=false;
        [self setLarge:large_value];
        [self setCardValue:t_cardValue];
        if (t)
        {
            if (large_value)
            {
                card=[CCSprite spriteWithSpriteFrameName:frontalityImageLargeTrue];
            }else
            {
                card=[CCSprite spriteWithSpriteFrameName:frontalityImageLargeFalse];
            }
            [self addChildKind];
            [self addChildValue];
            
        }else
        {
            if (large_value)
            {
                card=[CCSprite spriteWithSpriteFrameName:backImageLargeTrue];
            }else
            {
                card=[CCSprite spriteWithSpriteFrameName:backImageLargeFalse];
            }
        }
        _parentNode = parentNode;
        NSAssert( card != nil, @"Argument must be non-nil,this is  message in the card class");
        [parentNode addChild:card];
        
    }
    return self;

}
-(void)setDisplay:(BOOL)frontality{
    [self.parentNode removeChild:card cleanup:YES];
    card = nil;
    
    [self setLarge:self.large];
    [self setCardValue:self.cardValue];
   
    if (frontality)
    {
        if (self.large)
        {
            card=[CCSprite spriteWithSpriteFrameName:frontalityImageLargeTrue];
        }else
        {
            card=[CCSprite spriteWithSpriteFrameName:frontalityImageLargeFalse];
        }
        [self addChildKind];
        [self addChildValue];
        
    }else
    {
        if (self.large)
        {
            card=[CCSprite spriteWithSpriteFrameName:backImageLargeTrue];
        }else
        {
            card=[CCSprite spriteWithSpriteFrameName:backImageLargeFalse];
        }
    }
    
    card.position =startPos;
    
    [self.parentNode addChild:card];
}
/**
 *近回当前约牌类型
 *@return int 返回值 1:方块 2:草花 3:红桃 4:黑桃 5:小王 6:大王
 */
-(int)getCardKind
{
    int temp_kind=0;
    if (_cardValue >=1 && _cardValue<= 13)
         temp_kind=  1;
    else if (_cardValue >=14 && _cardValue<= 26)
         temp_kind=  2;
    else if (_cardValue >=27 && _cardValue<= 39)
         temp_kind=  3;
    else if (_cardValue >=40 && _cardValue<= 52)
         temp_kind=  4;
    else if (_cardValue==53)
    {
        temp_kind= 5;
    }else if (_cardValue==54)
    {
        temp_kind=6;
    }
    return temp_kind;
}

/*
 *添加纸牌类型图标
 *
 */
-(void)addChildKind
{
    int temp_Kind;
    temp_Kind=[self getCardKind];
    switch (temp_Kind) {
        case 1:             //方块
        {
            CCSprite *temp_Kind_Sprite1=[CCSprite spriteWithSpriteFrameName:(self.large ? cardImageKind_F1 : cardImageKind_F2)];
            temp_Kind_Sprite1.Position=ccp(temp_Kind_Sprite1.contentSize.width*1.8,card.contentSize.height-temp_Kind_Sprite1.contentSize.height);
            [card addChild:temp_Kind_Sprite1 ];
            
            CCSprite *temp_Kind_Sprite2=[CCSprite spriteWithSpriteFrameName:(self.large ? cardImageKind_F1 : cardImageKind_F2)];
            temp_Kind_Sprite2.Position=ccp(card.contentSize.width-temp_Kind_Sprite1.contentSize.width*1.8,temp_Kind_Sprite2.contentSize.height);
            [card addChild:temp_Kind_Sprite2 ];
        }
            break;
        case 2:             //草花
        {
            CCSprite *temp_Kind_Sprite1=[CCSprite spriteWithSpriteFrameName:(self.large ? cardImageKind_H1 : cardImageKind_H2)];
            temp_Kind_Sprite1.Position=ccp(temp_Kind_Sprite1.contentSize.width*1.8,card.contentSize.height-temp_Kind_Sprite1.contentSize.height);
            [card addChild:temp_Kind_Sprite1 ];
            
            CCSprite *temp_Kind_Sprite2=[CCSprite spriteWithSpriteFrameName:(self.large ? cardImageKind_H1 : cardImageKind_H2)];
            temp_Kind_Sprite2.Position=ccp(card.contentSize.width-temp_Kind_Sprite1.contentSize.width*1.8,temp_Kind_Sprite2.contentSize.height);
            [card addChild:temp_Kind_Sprite2 ];
        }
            break;
        case 3:             //红桃
        {
            CCSprite *temp_Kind_Sprite1=[CCSprite spriteWithSpriteFrameName:(self.large ? cardImageKind_X1 : cardImageKind_X2)];
            temp_Kind_Sprite1.Position=ccp(temp_Kind_Sprite1.contentSize.width*1.8,card.contentSize.height-temp_Kind_Sprite1.contentSize.height);
            [card addChild:temp_Kind_Sprite1 ];
            
            CCSprite *temp_Kind_Sprite2=[CCSprite spriteWithSpriteFrameName:(self.large ? cardImageKind_X1 : cardImageKind_X2)];
            temp_Kind_Sprite2.Position=ccp(card.contentSize.width-temp_Kind_Sprite1.contentSize.width*1.8,temp_Kind_Sprite2.contentSize.height);
            [card addChild:temp_Kind_Sprite2 ];
        }
            break;
        case 4:             //黑桃
        {
            CCSprite *temp_Kind_Sprite1=[CCSprite spriteWithSpriteFrameName:(self.large ? cardImageKind_T1 : cardImageKind_T2)];
            temp_Kind_Sprite1.Position=ccp(temp_Kind_Sprite1.contentSize.width*1.8,card.contentSize.height-temp_Kind_Sprite1.contentSize.height);
            [card addChild:temp_Kind_Sprite1 ];
            
            CCSprite *temp_Kind_Sprite2=[CCSprite spriteWithSpriteFrameName:(self.large ? cardImageKind_T1 : cardImageKind_T2)];
            temp_Kind_Sprite2.Position=ccp(card.contentSize.width-temp_Kind_Sprite1.contentSize.width*1.8,temp_Kind_Sprite2.contentSize.height);
            [card addChild:temp_Kind_Sprite2 ];
        }
            break;
        case 5:
            
            break;
        case 6:
            break;
        default:
            CCLOG(@"error in function addChildKind in the CCCard class ");
            return;
            break;
    }
   
}

/*
 *
 *添加纸牌上的数字
 *
 */
-(void)addChildValue
{
    int temp_value,temp_Kind;
    temp_Kind=[self getCardKind];
    temp_value  =_cardValue- (temp_Kind-1)*13;
    
    
    NSString * temp_image_filename;
    if (temp_Kind==5)
    {
        temp_image_filename=(self.large ? cardJoker_14A : cardJoker_14B);
    }else if  (temp_Kind ==6)
    {
        temp_image_filename=(self.large ?  cardJoker_15A : cardJoker_15B);;
    }else
    {
        if (temp_Kind == 1 || temp_Kind==3) {
            temp_image_filename=[NSString stringWithFormat:(self.large ? cardImageValue_b : cardImageValue_d),temp_value];
        }else
        {
            temp_image_filename=[NSString stringWithFormat:(self.large ? cardImageValue_a : cardImageValue_c),temp_value];
        }
    }
    CCSprite *temp_Value_Sprite1=[CCSprite spriteWithSpriteFrameName:temp_image_filename];
    temp_Value_Sprite1.Position=ccp(temp_Value_Sprite1.contentSize.width*(4.0/5.0),card.contentSize.height-temp_Value_Sprite1.contentSize.height*(4.0/5.0));
    [card addChild:temp_Value_Sprite1 ];
    
    CCSprite *temp_Value_Sprite2=[CCSprite spriteWithSpriteFrameName:temp_image_filename];
    temp_Value_Sprite2.Position=ccp(card.contentSize.width-temp_Value_Sprite2.contentSize.width*(4.0/5.0),temp_Value_Sprite2.contentSize.height*(4.0/5.0));
    temp_Value_Sprite2.rotation=180;
    [card addChild:temp_Value_Sprite2 ];
}

-(void)setPosition:(CGFloat)x Y:(CGFloat)y{
    card.position=ccp(x,y);
    startPos = card.position;
    location_y =y;
}
-(void)restY
{
    [self setPosition:card.position.x Y:location_y];
}
-(CGPoint)getPosition
{
    return card.position;
}

-(CGSize)getContentSize
{
    return card.contentSize;
}


-(void)setZ:(int)z
{
    [card setZOrder:z];
}

-(void)setrotate:(float)rotate{
    [card setRotation:rotate];
}
//获得牌面上的数字 1－13
-(int)getcardNumber
{
    int i,n;
    
    
    if (self.cardValue==53) {
        return 14;
    }else if (self.cardValue==54)
    {
        return 15;
    }
    i=self.cardValue/13;
    n=  (self.cardValue<13 )? self.cardValue :self.cardValue-i*13;
    if (n==0) n=13;
    return n;
}
//获得牌面上 牌所代表的点数 1-10  (J Q K 代表10)
-(int)getcardNumberNN{
    int n;
    n=[self getcardNumber];
    if (n>10) {
        n=10;
    }
    return n;
}
-(Boolean)highLight
{
    if (_highLight) {
        [card setPosition:ccp(card.position.x,location_y)];
    }else
    {
        [card setPosition:ccp(card.position.x,location_y+20)];
    }
    _highLight =!_highLight;
    return _highLight;
}

-(void)clean{
    [card removeFromParentAndCleanup:YES];
}
-(void)dealloc{
    [super dealloc];
}
@end
