//
//  HelloWorldLayer.m
//  cocos2dtest1
//
//  Created by 林 波 on 12-9-20.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#define cardCountTotal 20                       //发牌的总数量
// Import the interfaces
#import "PlayGameLayer.h"
#import "CCSendACard.h"
#import "SimpleAudioEngine.h"
#import "public/SingleGameState.h"
// HelloWorldLayer implementation
@implementation PlayGameLayer
//@synthesize operates1;
//
@synthesize hand1;
@synthesize hand2;
@synthesize hand3;
@synthesize hand4;
@synthesize card_count;
@synthesize bankerTag;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PlayGameLayer  *layer = [PlayGameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        [[SimpleAudioEngine sharedEngine] setEnabled:false];
        self.card_count=1;
        startGameTime=2;
        isSendCardsEnd=false;
        self.isTouchEnabled=true;
        cardNumArray = [[NSMutableArray alloc] init];              //初始扑克数组
        CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [cache addSpriteFramesWithFile:@"card.plist" textureFile:@"card.png"];
        
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sendcard.wav"];
        
        size = [[CCDirector sharedDirector] winSize];
        CCSprite *background=[CCSprite spriteWithFile:@"background.png"];
        [background setPosition:ccp(size.width/2 ,size.height/2)];
        [self addChild:background z:-1];
         
        item2=[CCMenuItemFont itemFromString:@"开始" target:self selector:@selector(sendMessage)];
        item2.position=ccp(size.width/2,size.height/2);
        
        promptmenu=[CCMenuItemFont itemFromString:@"提示" target:self selector:@selector(promptmenu_function)];
        promptmenu.position=ccp(size.width/6* 5 ,size.height/10);
        
        resend=[CCMenuItemFont itemFromString:@"重发" target:self selector:@selector(resend_function)];
        resend.position=ccp(size.width/6,size.height/10);
        
        nextRound = [CCMenuItemFont itemFromString:@"下一轮" target:self selector:@selector(action_NextRound)];
        nextRound.position=ccp(size.width/2,size.height/2);
        nextRound.visible = false;
        
        cmenu=[CCMenu menuWithItems:item2, promptmenu,resend,nextRound,nil];
        cmenu.position=ccp(0,0);
        [self addChild:cmenu];
//        
        self.hand1 =[CCInOnesHand SpiderWithParentNode];
        self.hand2 =[CCInOnesHand SpiderWithParentNode];
        self.hand3 =[CCInOnesHand SpiderWithParentNode];
        self.hand4 =[CCInOnesHand SpiderWithParentNode];
        
        
        [self loadCashLab];
        [self loadRandomBanker];
        
        
        messageLabel1=[CCLabelTTF   labelWithString:@"准备.." fontName:@"Arial" fontSize:16];
        [messageLabel1 setPosition:ccp(size.width/2, size.height/8)];
        [messageLabel1 setVisible:false];
        [self addChild:messageLabel1];
     
//     前景音乐
        if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying])
        {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Welcome.mp3" loop:YES];
        }

        
	}
	return self;
}
/*
 *加载当前现金Label  Start
 */
-(void)loadCashLab{
    //把本金显示在界面   start
    labCashP1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",self.hand1.cashCount] fontName:@"Arial" fontSize:15];              //down
    labCashP1.color= ccBLACK;
    labCashP1.position = ccp(size.width/2,labCashP1.contentSize.height);
    labCashP2 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",self.hand2.cashCount] fontName:@"Arial" fontSize:15];              //left
    labCashP2.color= ccBLACK;
    labCashP2.rotation = 90;
    labCashP2.position = ccp(labCashP2.contentSize.width/2,size.height/2);
    
    labCashP3 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",self.hand3.cashCount] fontName:@"Arial" fontSize:15];              //up
    labCashP3.color= ccBLACK;
    labCashP3.rotation = 180;
    labCashP3.position = ccp(size.width/2,size.height-labCashP3.contentSize.height);
    
    labCashP4 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",self.hand4.cashCount] fontName:@"Arial" fontSize:15];              //right
    labCashP4.color= ccBLACK;
    labCashP4.rotation = -90;
    labCashP4.position = ccp(size.width - labCashP2.contentSize.width/2,size.height/2);
    //把本金显示在界面   end
    [self addChild:labCashP1 z:50];
    [self addChild:labCashP2 z:50];
    [self addChild:labCashP3 z:50];
    [self addChild:labCashP4 z:50];
    
    labBanker = [CCLabelTTF labelWithString:@"庄家" fontName:@"Arial" fontSize:15];              //left
    labBanker.color= ccRED;
    [self addChild:labBanker z:50];
}
/*
//加载当前现金Label  end
*/
/*
 开场在四个玩家中随机出一个庄家出来      start
 */
-(void)loadRandomBanker{
    int randomBankerTag = arc4random()%4+1;
    randomBankerTag = 1;
    [self changeLabBankerPos:randomBankerTag];
}
/*
 开场在四个玩家中随机出一个庄家出来      end
 */

/*
 更改庄家的位置  Start
*/
-(void)changeLabBankerPos:(int)randomNum{
    bankerTag = randomNum;
    switch (randomNum) {
        case 1:                     //down
        {
            labBanker.rotation = 0;
            labBanker.position = ccp(size.width/4-labBanker.contentSize.width, size.height/3-labBanker.contentSize.height);
        }
            break;
        case 2:                     //left
        {
            labBanker.rotation = 90;
            labBanker.position = ccp(size.width/6-labBanker.contentSize.width, size.height*2/3+labBanker.contentSize.height);
        }
            break;
        case 3:                     //up
        {
            labBanker.rotation = 180;
            labBanker.position = ccp(size.width*2/3+labBanker.contentSize.width, size.height*3/4+labBanker.contentSize.height);
        }
            break;
        case 4:                     //right
        {
            labBanker.rotation = -90;
            labBanker.position = ccp(size.width*5/6+labBanker.contentSize.width, size.height/3-labBanker.contentSize.height);
        }
            break;
    }
}

/*
 更改庄家的位置  End
 */

/*
 显示点数 Start
 */
-(void)showPointInWindow{
    [self removePointLab];
    CCLabelTTF *downPointLab = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"牛%d",[hand1 getCardPoint]] fontName:@"Arial" fontSize:25];
    downPointLab.color = ccRED;
    downPointLab.position = ccp(size.width/2, size.height/3);
    
    CCLabelTTF *leftPointLab = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"牛%d",[hand2 getCardPoint]] fontName:@"Arial" fontSize:25];
    leftPointLab.rotation = 90;
    leftPointLab.color = ccRED;
    leftPointLab.position = ccp(size.width/5, size.height/2);
    
    CCLabelTTF *upPointLab = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"牛%d",[hand3 getCardPoint]] fontName:@"Arial" fontSize:25];
    upPointLab.rotation = 180;
    upPointLab.color = ccRED;
    upPointLab.position = ccp(size.width/2, size.height*3/4);
    
    
    CCLabelTTF *rightPointLab = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"牛%d",[hand4 getCardPoint]] fontName:@"Arial" fontSize:25];
    rightPointLab.rotation = -90;
    rightPointLab.color = ccRED;
    rightPointLab.position = ccp(size.width*4/5, size.height/2);
    
    
    
    [self addChild:downPointLab z:50 tag:330];
    [self addChild:leftPointLab z:50 tag:331];
    [self addChild:upPointLab z:50 tag:332];
    [self addChild:rightPointLab z:50 tag:333];
    
    [self performSelector:@selector(removePointLab) withObject:self afterDelay:3];
    
}
-(void)removePointLab{
    if ([self getChildByTag:330]) {
        [self removeChildByTag:330 cleanup:YES];
    }
    if ([self getChildByTag:331]) {
        [self removeChildByTag:331 cleanup:YES];
    }
    if ([self getChildByTag:332]) {
        [self removeChildByTag:332 cleanup:YES];
    }
    if ([self getChildByTag:333]) {
        [self removeChildByTag:333 cleanup:YES];
    }
}
/*
 显示点数 End
 */
-(void)promptmenu_function
{
    if (isSendCardsEnd) {
        [self.hand1 prompt];
        [self showPointInWindow];
        nextRound.visible = true;
    }
    
//    for(CCCard *cc in [self.hand1 cards]){
//        CCLOG(@"cccard value ==%d",[cc getcardNumberNN]);
//    }
    
}

-(void)connectToHost
{
    asyncSocket=[[AsyncSocket alloc] initWithDelegate:self];
    NSError *err=nil;
    if (![asyncSocket connectToHost:@"127.0.0.1"  onPort:802 error:&err]) {
        NSLog(@"Error : %@",err);
    }else
    {
        NSLog(@"ok!111111ok!111111ok!111111ok!111111ok!111111ok!111111ok!111111ok!111111");
    }
}


-(void)sendMessage{
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
    [item2 setVisible:false];
    [messageLabel1 setVisible:true];
    startGameTime=1;
    [self schedule:@selector(startGame) interval:1];
}
-(void)startGame
{
    startGameTime--;
    [messageLabel1 setString:[NSString stringWithFormat:@"准备...%d",startGameTime ]];
    if (startGameTime==0) {
        [self unschedule:@selector(startGame)];
        CCSendACard *c =[CCSendACard  SpiderWithParentNode:self];
        [c setSendACardDelegate:self];
        [c action_right];
    }
    
}

/*
 重新发牌 Start
 */
-(void)resend_function{
    if (!isSendCardsEnd) {
        return;
    }
    [hand1 cleancard];
    [hand2 cleancard];
    [hand3 cleancard];
    [hand4 cleancard];
    self.card_count=1;
    [self loadRandomBanker];
    [self sendMessage];
    isSendCardsEnd = false;
    
}
/*
 重新发牌 Start
 */

#pragma mark common method
-(CCInOnesHand *)getHandByTag:(int)playID{
    CCInOnesHand *tempHands;
    switch (playID) {
        case 1:
            tempHands = hand1;
            break;
        case 2:
            tempHands = hand2;
            break;
        case 3:
            tempHands = hand3;
            break;
        case 4:
            tempHands = hand4;
            break;
    }
    return tempHands;
}
#pragma mark fiveLittleCow
-(Boolean)isFiveLittleCow:(int)playerTag{
    BOOL isTrue = false;
    
    int total =0;           //五小牛必须5张牌相加小于 10点
    CCInOnesHand *tempHands = [self getHandByTag:playerTag];
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
-(BOOL)isBombCards:(int)playerTag{
    BOOL isTrue = false;
    CCInOnesHand *tempHands = [self getHandByTag:playerTag];
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
-(int)isBombCardsBigerCard:(int)playerTag{
    int bombCardNum=0;
    CCInOnesHand *tempHands = [self getHandByTag:playerTag];
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
-(enum CowTag)isSilverOrGoldCow:(int)playerTag{
    int silverCowCount =0;
    int goldCowCount =0;
    CCInOnesHand *tempHands = [self getHandByTag:playerTag];
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

#pragma mark 一轮结束  进入结算
/*
 获取玩家获得的点数  start
 @param playerTag   玩家的标识
 */
-(int)getPlayerPoint:(int)playerTag{
    int bankerPointTemp;
    
    CCInOnesHand *tempHands = [self getHandByTag:playerTag];
    bankerPointTemp = [tempHands getCardPoint];
    
    return bankerPointTemp;
}
/*
 获取玩家获得的点数  end
 */
/*
 计算筹码  start
 @param addOrSub 标识是加筹码还是减筹码  true:加筹码  false:减筹码
 @param playTag  玩家标识
 */
-(void)caculateChip:(BOOL)addOrSub playTag:(int)playTag subChipNum:(int)subChipNum{
    
    CCInOnesHand *tempHands = [self getHandByTag:playTag];
    addOrSub?[tempHands addCashCount:subChipNum]:[tempHands subCashCount:subChipNum];
    [self refleshShowLabel];
}
/*
 计算筹码  end
 */
/*
 计算是否需要翻倍  start
 @param bigPointTag  较大玩家的标识
 
 当牌面是
 牛牛  X3
 银牛  X4
 金牛  X5
 炸弹  X6
 五小牛 X10
 */
-(int)isNeedMultiple:(int)bigPointTag{
    int multipleNumber = 1;
    
    CCInOnesHand *tempHands = [self getHandByTag:bigPointTag];
    int playerPointTemp = [self getPlayerPoint:bigPointTag];
    if (playerPointTemp > 6 && playerPointTemp !=10) {
        multipleNumber = 2;
    }
    
    
    return multipleNumber;
}
/*
 计算是否需要翻倍  end
 */
/*
 比较玩家与庄家的大小     start
 @param playerTag  闲家标识
 */
-(void)compareWithPoint:(int)playerTag{
    int mixBaseChip = 5;            //下注的基础大小  5元
    int multipleNumber =1;          //翻倍的初始大小
    
    
    //五小牛  Start
    if([self isFiveLittleCow:bankerTag]){       //如果庄家为五小牛
        //如果闲家也为五小牛  庄吃闲
        multipleNumber = 10;                //五小牛 翻倍
        mixBaseChip *= multipleNumber;
        [self caculateChip:true playTag:bankerTag subChipNum:mixBaseChip];
        [self caculateChip:false playTag:playerTag subChipNum:mixBaseChip];
        return;
    }else if ([self isFiveLittleCow:playerTag]){        //闲家是 五小牛时
        multipleNumber = 10;                //五小牛 翻倍
        mixBaseChip *= multipleNumber;
        [self caculateChip:false playTag:bankerTag subChipNum:mixBaseChip];
        [self caculateChip:true playTag:playerTag subChipNum:mixBaseChip];
        return;
    }
    //五小牛  end
    
    //炸弹  Start
    if ([self isBombCards:bankerTag] && [self isBombCards:playerTag] ) {            //当庄家和闲家同为炸弹时候  比较炸弹大小
        multipleNumber = 6;                //炸弹 翻倍
        mixBaseChip *= multipleNumber;
        if ([self isBombCardsBigerCard:bankerTag] > [self isBombCardsBigerCard:playerTag]) {
            [self caculateChip:true playTag:bankerTag subChipNum:mixBaseChip];
            [self caculateChip:false playTag:playerTag subChipNum:mixBaseChip];
        }else{
            [self caculateChip:false playTag:bankerTag subChipNum:mixBaseChip];
            [self caculateChip:true playTag:playerTag subChipNum:mixBaseChip];
        }
        return;
    }
    if ([self isBombCards:bankerTag]) {
        multipleNumber = 6;                //炸弹 翻倍
        mixBaseChip *= multipleNumber;
        [self caculateChip:true playTag:bankerTag subChipNum:mixBaseChip];
        [self caculateChip:false playTag:playerTag subChipNum:mixBaseChip];
        return;
    }else if([self isBombCards:playerTag]){
        multipleNumber = 6;                //炸弹 翻倍
        mixBaseChip *= multipleNumber;
        [self caculateChip:false playTag:bankerTag subChipNum:mixBaseChip];
        [self caculateChip:true playTag:playerTag subChipNum:mixBaseChip];
        return;
    }
    
    //炸弹  End
    
    //
    
    //正常情况
    int bankerPointTemp = [self getPlayerPoint:bankerTag];
    int playerPointTemp = [self getPlayerPoint:playerTag];
    
    
    //判断是否上档   大于6点就上档
    if (bankerPointTemp>6||playerPointTemp >6) {
        multipleNumber = 2;                //上档翻倍
        CCLOG(@"上档");
    }
    
    
    //判断是不是有 金牛银牛  start
    if (bankerPointTemp == 10 || playerPointTemp == 10) {
        for (int i = 0; i<2; i++) {
            int tempTag = 0;
            if (i == 0) {
                tempTag = playerTag;
            }else{
                tempTag = bankerTag;
            }
            
            switch ([self isSilverOrGoldCow:tempTag]) {
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
        [self caculateChip:true playTag:bankerTag subChipNum:mixBaseChip];
        [self caculateChip:false playTag:playerTag subChipNum:mixBaseChip];
        return;
    }
    if (bankerPointTemp == playerPointTemp) {
        CCLOG(@"同样大");
        for (int i=0; i<5; i++) {
            CCLOG(@"%d",[self getMaxCardNum:bankerTag maxNum:i]);
            CCLOG(@"%d",[self getMaxCardNum:playerTag maxNum:i]);
            if([self getMaxCardNum:bankerTag maxNum:i] > [self getMaxCardNum:playerTag maxNum:i]){
                [self caculateChip:true playTag:bankerTag subChipNum:mixBaseChip];
                [self caculateChip:false playTag:playerTag subChipNum:mixBaseChip];
                break;
            }
            if([self getMaxCardNum:bankerTag maxNum:i] < [self getMaxCardNum:playerTag maxNum:i]){
                [self caculateChip:false playTag:bankerTag subChipNum:mixBaseChip];
                [self caculateChip:true playTag:playerTag subChipNum:mixBaseChip];
                break;
            }
        }
        return;
    }
    if (bankerPointTemp < playerPointTemp) {
        [self caculateChip:false playTag:bankerTag subChipNum:mixBaseChip];
        [self caculateChip:true playTag:playerTag subChipNum:mixBaseChip];
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
-(int)getMaxCardNum:(int)playID maxNum:(int)maxNum{
    int cardNumTemp=0;
    CCInOnesHand *tempHands = [self getHandByTag:playID];
    CCLOG(@"%d",[[[tempHands getCardNumArray] objectAtIndex:maxNum] intValue]);
    cardNumTemp =[[[tempHands getCardNumArray] objectAtIndex:maxNum] intValue];
    
    return cardNumTemp;
}
/*
 返回手中最大的牌 end
 */
/*
 结算  进入下一轮Start
 */
-(void)settleAccounts{
    for (int i=1; i<=4; i++) {
        if (i != bankerTag) {
            [self compareWithPoint:i];
        }
    }
    
}
/*
 结算  进入下一轮Start
 */
-(void)action_NextRound{
    if (!isSendCardsEnd) {
        return;
    }
    [self settleAccounts];
    [hand1 cleancard];
    [hand2 cleancard];
    [hand3 cleancard];
    [hand4 cleancard];
    self.card_count=1;
    [self changeLabBankerPos:bankerTag];
    [self sendMessage];
    
    nextRound.visible = false;
    isSendCardsEnd = false;
}
/*
 结算  进入下一轮  end
 */

-(void)action_Complete:(int)type_value
{
    //从剩余扑克 牌中取出随机发得的牌  并从剩余牌中移出该扑克  start
    int randCardNum=  (arc4random() % (cardNumArray.count-1));
    int card_value = [[cardNumArray objectAtIndex:randCardNum] intValue];
    [cardNumArray removeObjectAtIndex:randCardNum];
    
//    NSLog(@"%d====%d",card_value,cardNumArray.count);
    //从剩余扑克 牌中取出随机发得的牌  并从剩余牌中移出该扑克  start
    
    self.card_count++;
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"sendcard.wav"];
    
    switch (type_value) {
        case LOCATION_DOWN:
        {
            [hand1 setLocation:LOCATION_DOWN];
            [hand1 addCard:self cardValue:card_value frontality:true large:true];
            [hand1 cardDisplay:true];
//             NSLog(@"hand1===%d",[hand1 count]);
//            if ([hand1 count] >=6) {
//                NSLog(@"hand1 return");
//                return;
//            }
            //改  2012－10－18
            CCLOG(@"LOCATION_DOWN===%d",card_value);
            if (self.card_count >cardCountTotal) {
                return;
            }
            
            CCSendACard *c =[CCSendACard  SpiderWithParentNode:self];
            [c setSendACardDelegate:self];
            [c action_left];
           
            
        }
            break;
        case LOCATION_LEFT:
        {
            [hand2 setLocation:LOCATION_LEFT];
            [hand2 addCard:self cardValue:card_value frontality:true large:false];
            [hand2 cardDisplay:true];
//             NSLog(@"hand2===%d",[hand2 count]);
//            if ([hand2 count] >=6) {
//                NSLog(@"hand2 return");
//                return;
//            }
            //改  2012－10－18
            if (self.card_count >cardCountTotal) {
                return;
            }
            
            CCSendACard *c =[CCSendACard  SpiderWithParentNode:self];
            [c setSendACardDelegate:self];
            [c action_up];
        }
            break;
        case LOCATION_UP:
        {
//           NSLog(@"hand3===%d",[hand3 count]);
            [hand3 setLocation:LOCATION_UP];
            [hand3 addCard:self cardValue:card_value frontality:true large:false];
            [hand3 cardDisplay:true];
//            NSLog(@"hand3===%d====card_value===%d",[hand3 count],card_value);
//            if ([hand3 count] >=5) {
//                 NSLog(@"hand3 return");
//                return;
//            }
            //改  2012－10－18
            if (self.card_count >cardCountTotal) {
                isSendCardsEnd= true;
                return;
            }
            
            CCSendACard *c =[CCSendACard  SpiderWithParentNode:self];
            [c setSendACardDelegate:self];
            [c action_right];
        }
            break;
        case LOCATION_RIGHT:
        {
            
            [hand4 setLocation:LOCATION_RIGHT];
            [hand4 addCard:self cardValue:card_value frontality:true large:false];
            [hand4 cardDisplay:true];
//             NSLog(@"hand4===%d",[hand4 count]);
//            if ([hand4 count] >=6) {
//                NSLog(@"hand4 return");
//                return;
//            }
            //改  2012－10－18
            if (self.card_count >cardCountTotal) {
                return;
            }
            
            CCSendACard *c =[CCSendACard  SpiderWithParentNode:self];
            [c setSendACardDelegate:self];
            [c action_down];
            
        }
            break;
    }
//    if (self.card_count>=cardCountTotal)
//        isSendCardsEnd=true;
//    CCLOG(@"%d",self.card_count);
}

#pragma mark delegateWithCCInOnesHand    Start
-(void)refleshShowLabel{
    [labCashP1 setString:[NSString stringWithFormat:@"%d",self.hand1.cashCount]];
    
    [labCashP2 setString:[NSString stringWithFormat:@"%d",self.hand2.cashCount]];
    
    [labCashP3 setString:[NSString stringWithFormat:@"%d",self.hand3.cashCount]];
    
    [labCashP4 setString:[NSString stringWithFormat:@"%d",self.hand4.cashCount]];
}
#pragma mark delegateWithCCInOnesHand    End
#pragma mark thouch event


-(void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                     priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
	return YES;
}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
}


-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touch locationInView: [touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    if (isSendCardsEnd) {
        [self.hand1 selectit:touchLocation];
    }
}



// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    [cardNumArray release];
	[super dealloc];
}
@end
