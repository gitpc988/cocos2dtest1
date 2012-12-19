//
//  SinglePlayGameLayer.m
//  cocos2dtest1
//
//  Created by plllp on 12-12-8.
//  Copyright 2012年 Architectures. All rights reserved.
//

#import "SinglePlayGameLayer.h"
#import "CCInOnesHand.h"
#import "CCSendACard.h"
#import "card.h"
#import "ChipElement.h"
#import "public/SingleGameState.h"

@implementation SinglePlayGameLayer
@synthesize bankPlayer;
@synthesize playerOne;
@synthesize playerTwo;
@synthesize playerThree;
@synthesize playerFour;

+(CCScene *)scene{
    CCScene *scene = [CCScene node];
    SinglePlayGameLayer *spg = [SinglePlayGameLayer node];
    [scene addChild:spg];
    return scene;
}
-(id)init{
    if (self =[super init]) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"card.plist" textureFilename:@"card.png"];
        self.isTouchEnabled = YES;
        
        CCSprite *backSprite = [CCSprite spriteWithFile:@"game_bg.jpg"];
        backSprite.position =ccp(ScreenSize.width/2, ScreenSize.height/2);
        [self addChild:backSprite z:-1];
        
        NSString *str = [NSString stringWithFormat:@"%.2f万",(float)[[[NSUserDefaults standardUserDefaults] objectForKey:@"UserCash"] intValue]/10000];
        userCashLab = [CCLabelTTF labelWithString:str fontName:@"Arial" fontSize:18];
        userCashLab.color = ccYELLOW;
        userCashLab.position = ccp(ScreenSize.width-userCashLab.contentSize.width*2/3, userCashLab.contentSize.height);
        [self addChild:userCashLab];
        
        cardNumArray = [[NSMutableArray alloc] init];
        chipArray = [[NSMutableArray alloc] init];
        playerCountNum = 0;                     //保存显示到哪个玩家的计数
        
        
        [self initChip];
        
        self.bankPlayer = [CCInOnesHand SpiderWithParentNode];
        self.playerOne = [CCInOnesHand SpiderWithParentNode];
        self.playerTwo = [CCInOnesHand SpiderWithParentNode];
        self.playerThree = [CCInOnesHand SpiderWithParentNode];
        self.playerFour = [CCInOnesHand SpiderWithParentNode];
       
        
        [self performSelector:@selector(startGame) withObject:self afterDelay:1];
    }
    return self;
}
-(void)startGame
{
    // 初始化原始扑克      start
    if (cardNumArray.count >0) {
        [cardNumArray removeAllObjects];
    }
    for (int i=1; i<=54; i++) {
        //        int xi = arc4random()%4+1;
        [cardNumArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    // 初始化原始扑克      end
    
    isSendCardsEnd=false;
    isStopBet = true;       //是否能继续押注
    
    CCSendACard *c =[CCSendACard  SpiderWithParentNode:self];
    [c setSendACardDelegate:self];
    [c action_zero];
}

#pragma mark 初始化筹码

-(void)initChip{
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:@"chip.plist" textureFilename:@"chip.pvr.ccz"];

    for (int i = 0; i<8; i++) {
        ChipElement *chip = [ChipElement initWithScene:self iconNum:i];
        chip.position = ccp(80+((chip.contentSize.width*0.8)*i), (chip.contentSize.height*0.8)/2);
        [chipArray addObject:chip];
    }
    
    
    //初始化桌面钱币的计数
    deskCash1 =0;
    deskCash2 =0;
    deskCash3 =0;
    deskCash4 =0;
    [SingleGameState sharedSingleGameState].deskTotalCash =0;
}


-(void)action_Complete:(int)type_value{
    //从剩余扑克 牌中取出随机发得的牌  并从剩余牌中移出该扑克  start
    int randCardNum=  (arc4random() % (cardNumArray.count-1));
    int card_value = [[cardNumArray objectAtIndex:randCardNum] intValue];
    [cardNumArray removeObjectAtIndex:randCardNum];
    //从剩余扑克 牌中取出随机发得的牌  并从剩余牌中移出该扑克  start
    
    self.card_count++;
    
    
    switch (type_value) {
        case LOCATION_ZERO:{
            [bankPlayer setLocation:LOCATION_ZERO];
            [bankPlayer addCard:self cardValue:card_value frontality:false large:true];
            [bankPlayer cardDisplay:true];
            
            CCLOG(@"LOCATION_DOWN===%d",card_value);
            if (self.card_count >cardCountTotal) {
                return;
            }

            
            CCSendACard *c =[CCSendACard  SpiderWithParentNode:self];
            [c setSendACardDelegate:self];
            [c action_one];
        }
            break;
        case LOCATION_ONE:{
            [playerOne setLocation:LOCATION_ONE];
            [playerOne addCard:self cardValue:card_value frontality:false large:true];
            [playerOne cardDisplay:true];
            
            if (self.card_count >cardCountTotal) {
                return;
            }
            
            
            
            CCSendACard *c =[CCSendACard  SpiderWithParentNode:self];
            [c setSendACardDelegate:self];
            [c action_two];
        }
            break;
        case LOCATION_TWO:{
            [playerTwo setLocation:LOCATION_TWO];
            [playerTwo addCard:self cardValue:card_value frontality:false large:true];
            [playerTwo cardDisplay:true];
            
            if (self.card_count >cardCountTotal) {
                return;
            }
            
            
            
            CCSendACard *c =[CCSendACard  SpiderWithParentNode:self];
            [c setSendACardDelegate:self];
            [c action_three];
        }
            break;
        case LOCATION_THREE:{
            [playerThree setLocation:LOCATION_THREE];
            [playerThree addCard:self cardValue:card_value frontality:false large:true];
            [playerThree cardDisplay:true];
            if (self.card_count >cardCountTotal) {
                return;
            }
            
            
            
            CCSendACard *c =[CCSendACard  SpiderWithParentNode:self];
            [c setSendACardDelegate:self];
            [c action_four];
        }
            break;
        case LOCATION_FORE:{
            [playerFour setLocation:LOCATION_FORE];
            [playerFour addCard:self cardValue:card_value frontality:false large:true];
            [playerFour cardDisplay:true];
            
            if (self.card_count >=cardCountTotal) {
                [self performSelector:@selector(setShow) withObject:self afterDelay:1];
                return;
            }
            
            
            
            CCSendACard *c =[CCSendACard  SpiderWithParentNode:self];
            [c setSendACardDelegate:self];
            [c action_zero];
        }
            break;
    }
}
-(void)setShow{
    
    
    CCMenuItemImage *desk1 = [CCMenuItemImage itemWithNormalImage:@"deskTop.png" selectedImage:@"deskTop.png" target:self selector:@selector(clickDesk1:)];
    desk1.position = ccp(90,185);
    desk1.tag = 330;
    
    CCMenuItemImage *desk2 = [CCMenuItemImage itemWithNormalImage:@"deskTop.png" selectedImage:@"deskTop.png" target:self selector:@selector(clickDesk1:)];
    desk2.position = ccp(200,185);
    desk2.tag = 331;
    
    CCMenuItemImage *desk3 = [CCMenuItemImage itemWithNormalImage:@"deskTop.png" selectedImage:@"deskTop.png" target:self selector:@selector(clickDesk1:)];
    desk3.position = ccp(310,185);
    desk3.tag = 332;
    
    CCMenuItemImage *desk4 = [CCMenuItemImage itemWithNormalImage:@"deskTop.png" selectedImage:@"deskTop.png" target:self selector:@selector(clickDesk1:)];
    desk4.position = ccp(420,185);
    desk4.tag = 333;
    
    CCMenuItemFont *f1 = [CCMenuItemFont itemWithString:@"押注结束" target:self selector:@selector(show)];
    f1.position = ccp(ScreenSize.width*6/8, ScreenSize.height*3/4);
    f1.fontSize = 18;
    f1.tag = 334;
    f1.color = ccYELLOW;
    CCMenuItemFont *f2 = [CCMenuItemFont itemWithString:@"下一轮" target:self selector:@selector(closeS)];
    f2.position = ccp(ScreenSize.width*7/8, ScreenSize.height*5/6);
    f2.color = ccYELLOW;
    f2.tag = 335;
    f2.fontSize = 18;
    
    menu = [CCMenu menuWithItems:desk1,desk2,desk3,desk4,f1,f2, nil];
    menu.position=ccp(0, 0);
    [self addChild:menu];
    [self changeRunAction:0];
    
   
    deskCashLab1 = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:18];
    deskCashLab2 = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:18];
    deskCashLab3 = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:18];
    deskCashLab4 = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:18];
    
    deskCashLab1.position =  ccp(90,155);
    deskCashLab2.position =  ccp(200,155);
    deskCashLab3.position =  ccp(310,155);
    deskCashLab4.position =  ccp(420,155);
    
    deskCashLab1.color = ccRED;
    deskCashLab2.color = ccRED;
    deskCashLab3.color = ccRED;
    deskCashLab4.color = ccRED;
    
    [self addChild:deskCashLab1];
    [self addChild:deskCashLab2];
    [self addChild:deskCashLab3];
    [self addChild:deskCashLab4];
}


#pragma mark 点击 押注事件
/*
 台面押注的区域
 */
-(void)clickDesk1:(id)sender{
    if ([menu getChildByTag:[sender tag]]) {
        if (isStopBet || isStartAccounts) {
            return;
        }
        
        CCMenuItemImage *desk1 = (CCMenuItemImage *)[menu getChildByTag:[sender tag]];
       
        
        CCSprite *chipSprite = [CCSprite spriteWithSpriteFrameName:[self getCheckChipImageString:[tempCheckChip chipTag]]];
        chipSprite.scale = 0.5;
        
        
        int posX = arc4random()%((int)(desk1.contentSize.width-(chipSprite.contentSize.width/4)));
        int posY = arc4random()%((int)(desk1.contentSize.height-(chipSprite.contentSize.height/4)));
        
        if (posX<chipSprite.contentSize.width/4) {
            posX =chipSprite.contentSize.width/4;
        }
        if (posY<chipSprite.contentSize.height/4) {
            posY =chipSprite.contentSize.height/4;
        }
        
        
        chipSprite.position = ccp(posX, posY);
        [desk1 addChild:chipSprite];
        
        int tempCash =[tempCheckChip getResponseCash];
        [SingleGameState sharedSingleGameState].deskTotalCash +=tempCash;
        //把加注的金币纪录到 桌面纪录中
        switch ([sender tag]) {
            case 330:
                deskCash1 +=tempCash;
                [deskCashLab1 setString:[NSString stringWithFormat:@"%d",deskCash1]];
                break;
            case 331:
                deskCash2 +=tempCash;
                [deskCashLab2 setString:[NSString stringWithFormat:@"%d",deskCash2]];
                break;
            case 332:
                deskCash3 +=tempCash;
                [deskCashLab3 setString:[NSString stringWithFormat:@"%d",deskCash3]];
                break;
            case 333:
                deskCash4 +=tempCash;
                [deskCashLab4 setString:[NSString stringWithFormat:@"%d",deskCash4]];
                break;
        }
        
        
        
        
        /*如果押注之后  用户剩余金币数量得 1／10 小于当前选中得筹码
          便刷新筹码区  默认选中第一个
         当减去已经押注区域的金币 结果为零  就不能再押注  便取消选中状态
         */
        int cashNum = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserCash"] intValue]/10;
        cashNum -=[SingleGameState sharedSingleGameState].deskTotalCash;
        
        if (cashNum < [tempCheckChip getResponseCash]) {
            [self changeRunAction:0];
        }
        
        if (cashNum < 100) {
            [self changeChipRestAction];
        }
    }
    
}

-(NSString *)getCheckChipImageString:(int)chipTag{
    NSString *imageString ;
    switch (chipTag) {
        case 0:
            imageString = @"chip1_01.png";
            break;
        case 1:
            imageString = @"chip2_01.png";
            break;
        case 2:
            imageString = @"chip3_01.png";
            break;
        case 3:
            imageString = @"chip4_01.png";
            break;
        case 4:
            imageString = @"chip5_01.png";
            break;
        case 5:
            imageString = @"chip6_01.png";
            break;
        case 6:
            imageString = @"chip7_01.png";
            break;
        case 7:
            imageString = @"chip8_01.png";
            break;
    }
    return imageString;
}
//把桌面的全部筹码进行清理
-(void)cleanDesktop{
    deskCash1 = 0;
    deskCash2 = 0;
    deskCash3 = 0;
    deskCash4 = 0;
    [SingleGameState sharedSingleGameState].deskTotalCash =0;
    
    [deskCashLab1 setString:@""];
    [deskCashLab2 setString:@""];
    [deskCashLab3 setString:@""];
    [deskCashLab4 setString:@""];
    
    [menu removeAllChildrenWithCleanup:YES];
    for (int i=330; i<334; i++) {
        if ([menu getChildByTag:i]) {
            CCMenuItemImage *desk1 = (CCMenuItemImage *)[menu getChildByTag:i];
            [desk1 removeAllChildrenWithCleanup:YES];
        }
    }
    
}
#pragma 轮番显示牌面
-(void)show{
    CCMenuItemFont *cif = (CCMenuItemFont *)[menu getChildByTag:334];
    if (cif.visible) {
        cif.visible = false;
    }
    isStartAccounts = true;
    
    
    CCInOnesHand *tempPlayer;
    switch (playerCountNum) {
        case 0:
            tempPlayer = bankPlayer;
            break;
        case 1:
            tempPlayer = playerOne;
            break;
        case 2:
            tempPlayer = playerTwo;
            break;
        case 3:
            tempPlayer = playerThree;
            break;
        case 4:
            tempPlayer = playerFour;
            break;
        default:
            break;
    }
    if (playerCountNum == 0) {
        [tempPlayer showPointLab:SHOWLEFT];
    }else{
        
        [self compareWithPoint:playerCountNum];
        [tempPlayer showPointLab:SHOWDOWN];
    }
    
    for (CCCard *c in [tempPlayer cards]) {
        [c setDisplay:true];
    }
    
    playerCountNum++;
    if (playerCountNum<5) {
        [self performSelector:@selector(show) withObject:self afterDelay:3];
    }else{
        isSendCardsEnd = true;
        isStartAccounts = false;
    }
}

-(void)closeS{
    if (!isSendCardsEnd) {
        return;
    }
    
    [bankPlayer cleancard];
    [playerOne cleancard];
    [playerTwo cleancard];
    [playerThree cleancard];
    [playerFour cleancard];
    [self cleanDesktop];        //清理赌桌
    self.card_count=1;
    playerCountNum = 0;
    [self startGame];
    
}

/*
 当押注之后  剩余筹码已经为0 时候   把筹码区选中去除  
 */
-(void)changeChipRestAction{
    for (int i =0; i<[chipArray count]; i++) {
        ChipElement *ce = [chipArray objectAtIndex:i];
        [ce runChipRestAction];
    }
    isStopBet = true;
}

#pragma mark ChipElementDelegate
-(void)changeRunAction:(int)selfTag{
    isStopBet = false;
    for (int i =0; i<[chipArray count]; i++) {
        ChipElement *ce = [chipArray objectAtIndex:i];
        if (i == selfTag) {
            tempCheckChip = ce;
            [ce runChipCheckAction];
        }else{
            [ce runChipRestAction];
        }
    }
}
#pragma mark TouchDelegate
-(void) registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInView: [touch view]];
//    CCLOG(@"%f,%f",touchLocation.x,touchLocation.y);
    return YES;
}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInView: [touch view]];
}
-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    touchLocation = CGPointMake(touchLocation.x, ScreenSize.height - touchLocation.y);
//    CCLOG(@"%f,%f",touchLocation.x,ScreenSize.height-touchLocation.y);
    
    
}

#pragma mark  结算  进行比对操作
/*
 比较玩家与庄家的大小     start
 @param playerTag  闲家标识
 */
-(void)compareWithPoint:(int)playerTag{
    CCInOnesHand *tempPlayer;
    int mixBaseChip = 0;            //下注的基础大小  5元
    switch (playerTag) {
        case 1:
            tempPlayer = playerOne;
            mixBaseChip = deskCash1;
            break;
        case 2:
            tempPlayer = playerTwo;
            mixBaseChip = deskCash2;
            break;
        case 3:
            tempPlayer = playerThree;
            mixBaseChip = deskCash3;
            break;
        case 4:
            tempPlayer = playerFour;
            mixBaseChip = deskCash4;
            break;
    }
    
    
    int multipleNumber =1;          //翻倍的初始大小
    
    
    //五小牛  Start
    if([self isFiveLittleCow:bankPlayer]){       //如果庄家为五小牛
        //如果闲家也为五小牛  庄吃闲
        multipleNumber = 10;                //五小牛 翻倍
        mixBaseChip *= multipleNumber;
//        [self caculateChip:true tempHands:bankPlayer subChipNum:mixBaseChip];
        [self caculateChip:false tempHands:tempPlayer subChipNum:mixBaseChip];
        return;
    }else if ([self isFiveLittleCow:tempPlayer]){        //闲家是 五小牛时
        multipleNumber = 10;                //五小牛 翻倍
        mixBaseChip *= multipleNumber;
//        [self caculateChip:false tempHands:bankPlayer subChipNum:mixBaseChip];
        [self caculateChip:true tempHands:tempPlayer subChipNum:mixBaseChip];
        return;
    }
    //五小牛  end
    
    //炸弹  Start
    if ([self isBombCards:bankPlayer] && [self isBombCards:tempPlayer] ) {            //当庄家和闲家同为炸弹时候  比较炸弹大小
        multipleNumber = 6;                //炸弹 翻倍
        mixBaseChip *= multipleNumber;
        if ([self isBombCardsBigerCard:bankPlayer] > [self isBombCardsBigerCard:tempPlayer]) {
//            [self caculateChip:true tempHands:bankPlayer subChipNum:mixBaseChip];
            [self caculateChip:false tempHands:tempPlayer subChipNum:mixBaseChip];
        }else{
//            [self caculateChip:false tempHands:bankPlayer subChipNum:mixBaseChip];
            [self caculateChip:true tempHands:tempPlayer subChipNum:mixBaseChip];
        }
        return;
    }
    if ([self isBombCards:bankPlayer]) {
        multipleNumber = 6;                //炸弹 翻倍
        mixBaseChip *= multipleNumber;
//        [self caculateChip:true tempHands:bankPlayer subChipNum:mixBaseChip];
        [self caculateChip:false tempHands:tempPlayer subChipNum:mixBaseChip];
        return;
    }else if([self isBombCards:tempPlayer]){
        multipleNumber = 6;                //炸弹 翻倍
        mixBaseChip *= multipleNumber;
//        [self caculateChip:false tempHands:bankPlayer subChipNum:mixBaseChip];
        [self caculateChip:true tempHands:tempPlayer subChipNum:mixBaseChip];
        return;
    }
    
    //炸弹  End
    
    //
    
    //正常情况
    int bankerPointTemp = [bankPlayer getCardPoint]; //[self getPlayerPoint:bankerTag];
    int playerPointTemp = [tempPlayer getCardPoint];//[self getPlayerPoint:playerTag];
    
    
    //判断是否上档   大于6点就上档
    if (bankerPointTemp>6||playerPointTemp >6) {
        multipleNumber = 2;                //上档翻倍
        CCLOG(@"上档");
    }
    
    
    //判断是不是有 金牛银牛  start
    if (bankerPointTemp == 10 || playerPointTemp == 10) {
        for (int i = 0; i<2; i++) {
            CCInOnesHand *tempHand;
            if (i == 0) {
                tempHand = tempPlayer;
            }else{
                tempHand = bankPlayer;
            }
            
            switch ([self isSilverOrGoldCow:tempHand]) {
                case normalCow:
                    multipleNumber = 3;                //普通 翻倍
                    CCLOG(@"普通");
                    break;
                case silverCow:
                    multipleNumber = 4;                //银牛 翻倍
                    CCLOG(@"银牛");
                    break;
                case goldCow:
                    multipleNumber = 5;                //金牛 翻倍
                    CCLOG(@"金牛");
                    break;
            }
            
        }
    }
    //判断是不是金牛 end
    
    mixBaseChip *= multipleNumber;
    
    CCLOG(@"bankerPointTemp==%d",bankerPointTemp);
    if (bankerPointTemp > playerPointTemp) {
        CCLOG(@"庄家大");
//        [self caculateChip:true tempHands:bankPlayer subChipNum:mixBaseChip];
        [self caculateChip:false tempHands:tempPlayer subChipNum:mixBaseChip];
        return;
    }
    if (bankerPointTemp == playerPointTemp) {
        CCLOG(@"同样大");
        for (int i=0; i<5; i++) {
            CCLOG(@"%d",[self getMaxCardNum:bankPlayer maxNum:i]);
            CCLOG(@"%d",[self getMaxCardNum:tempPlayer maxNum:i]);
            if([self getMaxCardNum:bankPlayer maxNum:i] > [self getMaxCardNum:tempPlayer maxNum:i]){
//                [self caculateChip:true tempHands:bankPlayer subChipNum:mixBaseChip];
                [self caculateChip:false tempHands:tempPlayer subChipNum:mixBaseChip];
                break;
            }
            if([self getMaxCardNum:bankPlayer maxNum:i] < [self getMaxCardNum:tempPlayer maxNum:i]){
//                [self caculateChip:false tempHands:bankPlayer subChipNum:mixBaseChip];
                [self caculateChip:true tempHands:tempPlayer subChipNum:mixBaseChip];
                break;
            }
        }
        return;
    }
    if (bankerPointTemp < playerPointTemp) {
//        [self caculateChip:false tempHands:bankPlayer subChipNum:mixBaseChip];
        [self caculateChip:true tempHands:tempPlayer subChipNum:mixBaseChip];
        CCLOG(@"闲家大");
        return;
    }
}
/*
 比较玩家与庄家的大小     end
 */
/*
 返回手中最大的牌 start
 */
-(int)getMaxCardNum:(CCInOnesHand *)tempHands maxNum:(int)maxNum{
    int cardNumTemp=0;
//    CCInOnesHand *tempHands = [self getHandByTag:playID];
    CCLOG(@"%d",[[[tempHands getCardNumArray] objectAtIndex:maxNum] intValue]);
    cardNumTemp =[[[tempHands getCardNumArray] objectAtIndex:maxNum] intValue];
    
    return cardNumTemp;
}
/*
 返回手中最大的牌 end
 */
/*
 计算筹码  start
 @param addOrSub 标识是加筹码还是减筹码  true:加筹码  false:减筹码
 @param playTag  玩家标识
 */
-(void)caculateChip:(BOOL)addOrSub tempHands:(CCInOnesHand *)tempHands subChipNum:(int)subChipNum{
    if (subChipNum == 0) {
         [tempHands showAccounts:subChipNum isAdd:false];
        return;
    }
//    CCInOnesHand *tempHands = [self getHandByTag:playTag];
    int cashTotal = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserCash"] intValue];
    if (addOrSub) {
        cashTotal +=subChipNum;
    }else{
        cashTotal -= subChipNum;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:cashTotal forKey:@"UserCash"];
     NSString *str = [NSString stringWithFormat:@"%.2f万",(float)cashTotal/10000];
    [userCashLab setString:str];
    [tempHands showAccounts:subChipNum isAdd:addOrSub];
    
//    addOrSub?[tempHands addCashCount:subChipNum]:[tempHands subCashCount:subChipNum];
}
/*
 计算筹码  end
 */
#pragma mark fiveLittleCow
-(Boolean)isFiveLittleCow:(CCInOnesHand *)tempHands{
    BOOL isTrue = false;
    
    int total =0;           //五小牛必须5张牌相加小于 10点
//    CCInOnesHand *tempHands = [self getHandByTag:playerTag];
    for (CCCard *card in [tempHands cards]) {
        if ([card getcardNumber]<5) {              //是五小牛
            total +=[card getcardNumber];
        }else{
            return isTrue;                          //有任意一张 大于5 的 就返回false
        }
    }
    if (total <10) {
        isTrue = true;
    }
    
    return isTrue;
}

#pragma mark bomb  是否是炸弹  当牌面有4张点数相同 既为炸弹
-(BOOL)isBombCards:(CCInOnesHand *)tempHands{
    BOOL isTrue = false;
//    CCInOnesHand *tempHands = [self getHandByTag:playerTag];
    int temp1 = [[[tempHands cards] objectAtIndex:0] getcardNumber];
    int temp2;
    for (CCCard *ca  in [tempHands cards]) {
        if ([ca getcardNumber] != temp1) {
            temp2 = [[[tempHands cards] objectAtIndex:1] getcardNumber];
            break;
        }
    }
    
    int num1 = 0;
    int num2 = 0;
    for (CCCard *card in [tempHands cards]) {
        
        if ([card getcardNumber] == temp1) {
            num1++;
        }
        if ([card getcardNumber] == temp2) {
            num2++;
        }
    }
    if (num1>3 || num2>3) {     //检测牌面是否有4以上张相同的
        isTrue = true;
    }
    return isTrue;
}
/*
 当牌面为炸弹时  把炸弹牌的 牌面 返回
 */
-(int)isBombCardsBigerCard:(CCInOnesHand *)tempHands{
    int bombCardNum=0;
//    CCInOnesHand *tempHands = [self getHandByTag:playerTag];
    int temp1 = [[[tempHands cards] objectAtIndex:0] getcardNumber];
    int temp2 = [[[tempHands cards] objectAtIndex:1] getcardNumber];
    
    int num1,num2;
    for (CCCard *card in [tempHands cards]) {
        
        if ([card getcardNumber] == temp1) {
            num1++;
            if (num1 >=2) {
                bombCardNum = temp1;
                break;
            }
        }
        if ([card getcardNumber] == temp2) {
            num2++;
            
            if (num1 >=2) {
                bombCardNum = temp1;
                break;
            }
        }
    }
    
    return bombCardNum;
}
#pragma mark 判断是不是金牛 银牛
-(enum CowTag)isSilverOrGoldCow:(CCInOnesHand *)tempHands{
    int silverCowCount =0;
    int goldCowCount =0;
//    CCInOnesHand *tempHands = [self getHandByTag:playerTag];
    for (CCCard *card in [tempHands cards]) {
        if ([card getcardNumber]>=10) {
            if ([card getcardNumber] >10) { //计算10以上( 不包含10)的牌
                goldCowCount++;
            }else{                          //计算10以上(包含10)的牌
                silverCowCount++;
            }
        }else{              //如果有任意一张小于10 那就不是银牛
            return normalCow;
        }
    }
    
    if (goldCowCount == 5) {
        return goldCow;
    }else{
        return silverCow;
    }
}


-(void)dealloc{
    [chipArray release];
    [cardNumArray release];
    [super dealloc];
}
@end
