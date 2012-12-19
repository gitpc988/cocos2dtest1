//
//  CCInOnesHand.m
//  cocos2dtest1
//
//  Created by 林 波 on 12-9-22.
//
//

#import "CCInOnesHand.h"
#import "card.h"

@implementation CCInOnesHand
@synthesize cards;
@synthesize location;
@synthesize cashCount;
@synthesize deleagete;
@synthesize parent;
+(id)SpiderWithParentNode {
    return [[[self alloc] initWithParentNode ] autorelease];
}
-(id)initWithParentNode 
{
    if((self=[super init]))
    {
        self.cards= [NSMutableArray array];
        self.cashCount = 100;
    }
    return self;
}
-(void)addCard:(CCNode *)parentNode cardValue:(int)t_cardValue frontality:(Boolean)t large:(Boolean)t_large
{
    CCCard *_card=[CCCard cardWithParentNode:t_cardValue frontality:t large:t_large ParentNode:parentNode];
    self.parent = parentNode;
    [self.cards addObject:_card];
}

-(void)cardDisplay:(Boolean)range{
    CCCard *_a1;
    CGSize size = [[CCDirector sharedDirector] winSize];
    int _cout=cards.count;
    if([cards count]>=1)
    {
        _a1=[cards objectAtIndex:0];
    }
    else
    {
        return ;
    }
    switch (self.location) {
        case LOCATION_DOWN:
        {
            _point=ccp(size.width/2, _a1.getContentSize.height/2);
            for (int i=0; i<=cards.count-1; i++) {
                CCCard *_a;
                _a=[cards objectAtIndex:i];
                [_a setPosition:_point.x-i*30+_cout/2*30 Y:_point.y ];
                [_a setZ:(cards.count-i)];
            }
        }
            break;
        case LOCATION_UP:
        {
            _point=ccp(size.width/2, size.height-_a1.getContentSize.height/2);
            for (int i=0; i<=cards.count-1; i++) {
                CCCard *_a;
                _a=[cards objectAtIndex:i];
                [_a setPosition:_point.x-i*20 +_cout/2*20  Y:_point.y ];
               // [_a setZ:(cards.count-i)];
                 [_a setrotate:-180];
                
            }
        }
            break;
        case LOCATION_LEFT:
        {
            _point=ccp(_a1.getContentSize.width, size.height/2);
            for (int i=0; i<=cards.count-1; i++) {
                CCCard *_a;
                _a=[cards objectAtIndex:i];
                [_a setrotate:90];
                [_a setPosition:_point.x Y:_point.y-i*20 +_cout/2*20 ];
                
            }
        }
            break;
        case LOCATION_RIGHT:
        {
            _point=ccp(size.width- _a1.getContentSize.width, size.height/2);
            for (int i=0; i<=cards.count-1; i++) {
                CCCard *_a;
                _a=[cards objectAtIndex:i];
                [_a setPosition:_point.x Y:_point.y-i*20+_cout/2*20 ];
                [_a setrotate:-90];
                [_a setZ:(cards.count-i)];
            }
        }
            break;
        case LOCATION_ZERO:{
            _point=ccp(ScreenSize.width/3, ScreenSize.height*4/5);
            for (int i=0; i<=cards.count-1; i++) {
                CCCard *_a;
                _a=[cards objectAtIndex:i];
                [_a setPosition:_point.x+i*12 Y:_point.y ];
                [_a setZ:(cards.count+i)];
            }
        }break;
        case LOCATION_ONE:{
            _point=ccp(ScreenSize.width/7, ScreenSize.height*3/8);
            for (int i=0; i<=cards.count-1; i++) {
                CCCard *_a;
                _a=[cards objectAtIndex:i];
                [_a setPosition:_point.x+i*12 Y:_point.y ];
                [_a setZ:(cards.count+i)];
            }
        }break;
        case LOCATION_TWO:{
            _point=ccp(ScreenSize.width*3/8, ScreenSize.height*3/8);
            for (int i=0; i<=cards.count-1; i++) {
                CCCard *_a;
                _a=[cards objectAtIndex:i];
                [_a setPosition:_point.x+i*12 Y:_point.y ];
                [_a setZ:(cards.count+i)];
            }
        }break;
        case LOCATION_THREE:{
            _point=ccp(ScreenSize.width*5/8, ScreenSize.height*3/8);
            for (int i=0; i<=cards.count-1; i++) {
                CCCard *_a;
                _a=[cards objectAtIndex:i];
                [_a setPosition:_point.x+(i-1)*12 Y:_point.y ];
                [_a setZ:(cards.count+i)];
            }
        }break;
        case LOCATION_FORE:{
            _point=ccp(ScreenSize.width*5/6, ScreenSize.height*3/8);
            for (int i=0; i<=cards.count-1; i++) {
                CCCard *_a;
                _a=[cards objectAtIndex:i];
                [_a setPosition:_point.x+i*12 Y:_point.y ];
                [_a setZ:(cards.count+i)];
            }
        }break;
        default:
             NSAssert( false, @"Argument must be non-nil,this is  message in the CCInOnesHand class");
            break;
    }

    if (range)
    {
        
    }else
    {
        
    }
}
-(int)count{
    return [self.cards count];
}
/*
//提示用户 Start
 */
-(void)prompt{
    Boolean  tmp1;
    tmp1=false;
    //tmp1记录是否有3张组成10
    //tmp2记录是否是“牛牛”
    
    int r1=0,r2=0,r3=0;
    [self restY];
    /*
    //2012－10－29 改
    */
//    for(int a=0;a<=4;a++){
//        for(int b=0;b<=4;b++){
//            for(int c=0;c<=4;c++){
//                if(([self getPrompt:a b:b c:c])%10 == 0){
//                    if (!((a==b || (a==c) ||(b ==c))) ){
//                        r1=a,r2=b,r3=c;
//                        tmp1=true;
//                    }
//                }
//            }
//        }
//    
//    }
    
    for (int a = 0; a<=2; a++) {
        for (int b = a+1; b<=3; b++) {
            for (int c = b+1; c<=4; c++) {
//                CCLOG(@" %d  %d  %d ",a,b,c);
                if(([self getPrompt:a b:b c:c])%10 == 0){
                    r1=a,r2=b,r3=c;
                    tmp1=true;
                }
            }
        }
    }
    
    /*
     //2012－10－29 改
     */
    
    if (tmp1) {
//        CCLOG(@" %d  %d  %d ",r1,r2,r3);
        
        CCCard *_a,*_b,*_c;
        _a=[cards objectAtIndex:r1];
        _b=[cards objectAtIndex:r2];
        _c=[cards objectAtIndex:r3];
         [_a highLight ];
         [_b highLight ];
         [_c highLight ];
//        CCLOG(@"%d + %d + %d",[_a getcardNumberNN] ,[_b getcardNumberNN],[_c getcardNumberNN]);
    }
}

/*
 //提示用户 end
 */

-(int)getCardPoint{
    int totalPoint=0;               //获得的点数
    
    for (int a = 0; a<=2; a++) {
        for (int b = a+1; b<=3; b++) {
            for (int c = b+1; c<=4; c++) {
                if(([self getPrompt:a b:b c:c])%10 == 0){
                    int r4=0,r5=0;
                    bool tp=false;
                    CCCard *_d,*_e;
                    
                    /*
                     CCCard *_a,*_b,*_c;
                    _a=[cards objectAtIndex:a];
                    _b=[cards objectAtIndex:b];
                    _c=[cards objectAtIndex:c];
                    CCLOG(@"10=====%d + %d + %d",[_a getcardNumberNN] ,[_b getcardNumberNN],[_c getcardNumberNN]);
                    */
                    
//                    CCLOG(@" r1===%d  ------ r2=== %d  ------ r3=== %d ",a,b,c);
                    for (int i=0; i<=4; i++) {
                        if (i!=a && i!=b && i!=c) {
                            if (!tp) {
                                r4 = i;
                                tp = true;
                            }else{
                                r5 = i;
                            }
                        }
                    }
//                    CCLOG(@"r4====%d  ----  r5===%d",r4,r5);
                    _d = [cards objectAtIndex:r4];
                    _e = [cards objectAtIndex:r5];
                    
                    
                   totalPoint = ([_d getcardNumberNN]+[_e getcardNumberNN])%10;
                    if (totalPoint == 0) {
                        totalPoint=10;
                    }
                }
            }
        }
    }
    
    
    
    return totalPoint;
}

-(void)restY{
    for (int i=0; i<=[cards count]-1; i++) {
        CCCard *_a;
        _a=[cards objectAtIndex:i];
        [_a restY];
    }
}

-(int)getPrompt:(int)a b:(int)b c:(int)c {
    CCCard *_a,*_b,*_c;
    _a=[cards objectAtIndex:a];
    _b=[cards objectAtIndex:b];
    _c=[cards objectAtIndex:c];
//    CCLOG(@"%d + %d + %d",[_a getcardNumberNN] ,[_b getcardNumberNN],[_c getcardNumberNN]);
    return [_a getcardNumberNN] +[_b getcardNumberNN] + [_c getcardNumberNN];
}

-(Boolean)selectit:(CGPoint) point
{
    if (self.location==LOCATION_DOWN)
    {
        for (int i=0; i<=4; i++) {
            CCCard *_a;
            _a=[cards objectAtIndex:i];
            CGPoint _tempPoint=[_a getPosition];
//            CCLOG(@"%f ",(point.x-_tempPoint.x));
            if (i==0) {
                if (((point.x - _tempPoint.x) <(27) ) && (ABS(point.y-_tempPoint.y)<30) && (point.x-_tempPoint.x>=(-27))){
                    [_a highLight];
                }
            }else
            if (((point.x - _tempPoint.x) <(-3) ) && (ABS(point.y-_tempPoint.y)<30) && (point.x-_tempPoint.x>=(-27))){
                [_a highLight];
            }
        }
        
    }
    return true;
}

-(void)cleancard{
//    CCLOG(@"cards===%d",[cards count]);
    if ([cards count]>0) {
        for (int i=0; i<=[cards count]-1; i++) {
            CCCard *_a=[cards objectAtIndex:i];
            [_a clean];
        }
        [cards removeAllObjects];
    }
    [parent removeChild:bankPoint cleanup:YES];
    [parent removeChild:settleAccounts cleanup:YES];
}
-(NSMutableArray *)getCardNumArray{
    NSMutableArray *cardNumArray = [[NSMutableArray alloc] init];
    for (CCCard *tCard in cards) {
        [cardNumArray addObject:[NSString stringWithFormat:@"%d",[tCard cardValue]]];
    }
    //冒泡排序    把手中的牌按从大到小排序出来
    int tempC=0;
    for (int i=[cardNumArray count]-1; i>=0; i--) {
        for (int j =0; j<i; j++) {
//            CCLOG(@"%d ===%d",[[cardNumArray objectAtIndex:i] intValue],[[cardNumArray objectAtIndex:j] intValue]);
            if ([[cardNumArray objectAtIndex:i] intValue]  >[[cardNumArray objectAtIndex:j] intValue]) {
                
//                CCLOG(@"tempc====%d",tempC);
                tempC = [[cardNumArray objectAtIndex:i] intValue];
                
//                CCLOG(@"tempc====%d",tempC);
                [cardNumArray replaceObjectAtIndex:i withObject:[cardNumArray objectAtIndex:j]];
                [cardNumArray replaceObjectAtIndex:j withObject:[NSString stringWithFormat:@"%d",tempC]];
                
//                CCLOG(@"%d === %d",[[cardNumArray objectAtIndex:i] intValue],[[cardNumArray objectAtIndex:j] intValue]);
            }
        }
    }
    
//    for(int x =0 ;x<[cardNumArray count];x++){
//        CCLOG(@"%d",[[cardNumArray objectAtIndex:x] intValue]);
//    }
//    [cardNumArray release];
    return cardNumArray;
}
/*
 对筹码进行计算  start
 */
-(void)addCashCount:(int)cash{
    self.cashCount += cash;
}
-(void)subCashCount:(int)cash{
    self.cashCount -= cash;
}
/*
 对筹码进行计算  end
 */

-(void)showPointLab:(int)showPos{
    CGPoint tempPos = _point;
    
    switch (showPos) {
        case SHOWLEFT:
            tempPos = ccp(tempPos.x+100, tempPos.y);
            break;
        case SHOWDOWN:
            tempPos = ccp(tempPos.x+20, tempPos.y-30);
            break;
    }
    NSString *str;
    
    switch ([self getCardPoint]) {
        case 0:
            str = @"无牛";
            break;
        case 1:
            str = @"牛一";
            break;
        case 2:
            str = @"牛二";
            break;
        case 3:
            str = @"牛三";
            break;
        case 4:
            str = @"牛四";
            break;
        case 5:
            str = @"牛五";
            break;
        case 6:
            str = @"牛六";
            break;
        case 7:
            str = @"牛七";
            break;
        case 8:
            str = @"牛八";
            break;
        case 9:
            str = @"牛九";
            break;
        case 10:
            str = @"牛牛";
            break;
    }
    
    bankPoint= [CCLabelTTF labelWithString:str fontName:@"Arial" fontSize:18];
    bankPoint.position = tempPos;
    bankPoint.color = ccGREEN;
    [parent addChild:bankPoint z:100];
    
}
-(void)showAccounts:(int)cash isAdd:(BOOL)isAdd{
    NSString *str;
    if (cash == 0) {
        str = @"无成绩";
    }else{
       str = [NSString stringWithFormat:isAdd?@"+%d":@"-%d",cash];
    }
     
    
    settleAccounts = [CCLabelTTF labelWithString:str fontName:@"Arial" fontSize:18];
    settleAccounts.position = ccp(_point.x+20, _point.y-50);;
    settleAccounts.color = isAdd?ccRED:ccGREEN;
    [parent addChild:settleAccounts z:100];
}
-(void)dealloc
{
    [self.cards removeAllObjects];
    [self.cards release];
    [super dealloc  ];
}
@end
