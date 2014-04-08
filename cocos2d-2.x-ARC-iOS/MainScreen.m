//
//  MainScreen.m
//  MyDoodleDrop
//
//  Created by yzw on 3/11/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "MainScreen.h"
#import "LoadingScene.h"
#import "AppDelegate.h"
#import "GameKitHelper.h"
#import "SelectLevel.h"
#import "AboutScreen.h"

@implementation MainScreen
- (id)init
{
    self = [super init];
    if (self) {
        CCLOG(@"%@: %@",NSStringFromSelector(_cmd),self);
        //创建菜单
        CGSize screenSize=[CCDirector sharedDirector].winSize;
        //设置菜单项的字体名称
        [CCMenuItemFont setFontName:@"Marker Felt"];
        //设置菜单项的字体大小
        [CCMenuItemFont setFontSize:42];
        //创建菜单项，并指定处理的方法
        CCMenuItemFont* itemNewGame=[CCMenuItemFont itemWithString:@"New Game"
                                                            target:self
                                                          selector:@selector(menuItemNewGameTouched)];
        CCMenuItemFont* itemAbout=[CCMenuItemFont itemWithString:@"About"
                                                            target:self
                                                          selector:@selector(menuItemAboutTouched)];
        //菜单：领先榜
        CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard"
                                                              target:self
                                                            selector:@selector(menuItemLeaderboardTouched)];
        //创建菜单
        CCMenu* menu=[CCMenu menuWithItems:itemNewGame,itemLeaderboard,itemAbout, nil];
        //设置菜单位置
        menu.position=CGPointMake(screenSize.width/2, screenSize.height/2);
        //加入到场景
        [self addChild:menu];
        //设置菜单项的间隔
        [menu alignItemsVerticallyWithPadding:40];
        
        //添加过渡的背景色
        CCLayerGradient* gradient=[CCLayerGradient layerWithColor:ccc4(0,150,255,255)
                                                         fadingTo:ccc4(0255,150,50,255)];
        [self addChild:gradient z:-1];
    }
    return self;
}
+(id)scene
{
    CCScene *scene=[CCScene node];
    CCLayer *layer=[MainScreen node];
    [scene addChild:layer];
    return scene;
}
- (void)dealloc
{
    CCLOG(@"%@: %@",NSStringFromSelector(_cmd),self);
}
#pragma mark 菜单处理函数
-(void)menuItemNewGameTouched
{
    [[CCDirector sharedDirector] replaceScene:[SelectLevel scene]];
}
-(void)menuItemAboutTouched
{
    [[CCDirector sharedDirector] replaceScene:[AboutScreen scene]];
}
-(void)menuItemLeaderboardTouched
{
    GameKitHelper* gkHelper=[GameKitHelper sharedGameKitHelper];
    GKLocalPlayer* localPlayer = GKLocalPlayer.localPlayer;
	if (localPlayer.authenticated == NO)
        [gkHelper authenticateLocalPlayer:@"show_leaderboard"];
    else
        [gkHelper showLeaderboard];
}
#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
