//
//  MainScreen.m
//  MyDoodleDrop
//
//  Created by yzw on 3/11/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "MainScreen.h"
#import "LoadingScene.h"

@implementation MainScreen
- (id)init
{
    self = [super init];
    if (self) {
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
        //创建菜单
        CCMenu* menu=[CCMenu menuWithItems:itemNewGame,itemAbout, nil];
        //设置菜单位置
        menu.position=CGPointMake(screenSize.width/2, screenSize.height/2);
        //加入到场景
        [self addChild:menu];
        //设置菜单项的间隔
        [menu alignItemsVerticallyWithPadding:40];
        
    }
    return self;
}
-(void)menuItemNewGameTouched
{
    [[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneGame]];
}
-(void)menuItemAboutTouched
{
    [[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneAbout]];
}
+(id)scene
{
    CCScene *scene=[CCScene node];
    CCLayer *layer=[MainScreen node];
    [scene addChild:layer];
    return scene;
}
@end
