//
//  LoginLayer.m
//  cocos2dtest1
//
//  Created by 林 波 on 12-9-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginLayer.h"


@implementation LoginLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LoginLayer *layer = [LoginLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id)init
{
    if (self=[super init]) {
      //  self.isTouchEnabled = YES;
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background=[CCSprite spriteWithFile:@"Default.png"];
        [background setRotation:-90];
        [background setPosition:ccp(size.width/2 ,size.height/2)];
        [self addChild:background z:-1];
        [self specifyStartLevel];
        
        
       CCMenuItem *loginGame=[CCMenuItemFont itemFromString:@"登陆" target:self selector:@selector(loginGame_Function)];
        loginGame.position=ccp(size.width/3,size.height/5*4);
        
        CCMenu *menu=[CCMenu menuWithItems:loginGame,  nil];
        [menu setPosition:ccp(0, 0)];
        [self addChild:menu];
        
    }
return self;
}

-(void)loginGame_Function{
    
}

-(void)specifyStartLevel {
    userLabel=[[UITextField alloc] initWithFrame:CGRectMake(20, 60, 40, 20)];
    [userLabel setText:@"用户:"];
    [userLabel setEnabled:false];
    [userLabel setTextColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1.0]];
    
    passwordLabel=[[UITextField alloc] initWithFrame:CGRectMake(20, 80, 40, 20)];
    [passwordLabel setEnabled:false];
    [passwordLabel setText:@"密码:"];
    [passwordLabel setTextColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1.0f]];
    
    passWordField=[[UITextField alloc] initWithFrame:CGRectMake(60, 80, 240, 160)];
    [passWordField setTextColor: [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0]];
    [passWordField setDelegate:self];
    
    userTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 60, 240, 160)];
    [userTextField setDelegate:self];
    [userTextField setText:@""];
    [userTextField setTextColor: [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0]];
    [[[CCDirector sharedDirector] openGLView] addSubview:userTextField];
    [[[CCDirector sharedDirector] openGLView] addSubview:userLabel  ];
    
    [[[CCDirector sharedDirector] openGLView] addSubview:passwordLabel  ];
    
    [[[CCDirector sharedDirector] openGLView] addSubview:passWordField  ];
    
    [userTextField becomeFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [userTextField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing: (UITextField *)textField {
    if(textField == userTextField) {
//        [userTextField endEditing:YES];
//        [userTextField removeFromSuperview];
        NSString *result = userTextField.text;
        NSLog(@"entered: %@", result);
    } else {
        NSLog(@"textField did not match myText");
    }
}

-(void)dealloc{
    [super dealloc];
}

@end
