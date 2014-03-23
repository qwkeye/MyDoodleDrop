//
//  UserInterfaceLayer.m
//  ScenesAndLayers
//
//  Created by Steffen Itterheim on 28.07.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "UserInterfaceLayer.h"
#import "MultiLayerScene.h"
#import "GameLayer.h"
#import "ScoreStore.h"
@implementation UserInterfaceLayer
-(id) init
{
	if ((self = [super init]))
	{
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
        //创建一个界面背景的精灵
		CCSprite* uiframe = [CCSprite spriteWithFile:@"ui-frame.png"];
        //居中放置
		uiframe.position = CGPointMake(screenSize.width/2, screenSize.height);
        //设置对齐方式
		uiframe.anchorPoint = CGPointMake(0.5f, 1);
		[self addChild:uiframe z:0 tag:UILayerTagFrameSprite];
        //创建一个菜单
		//设置菜单项的字体名称
        [CCMenuItemFont setFontName:@"Marker Felt"];
        //设置菜单项的字体大小
        [CCMenuItemFont setFontSize:24];
        //创建菜单项，并指定处理的方法
        itemPauseResume=[CCMenuItemFont itemWithString:@"Pause"
                                                            target:self
                                                          selector:@selector(menuItemPauseResumeTouched)];
        CCMenuItemFont* itemAbort=[CCMenuItemFont itemWithString:@"Abort"
                                                          target:self
                                                        selector:@selector(menuItemAbortTouched)];
        //创建菜单
        CCMenu* menu=[CCMenu menuWithItems:itemPauseResume,itemAbort, nil];
        //设置菜单位置
        menu.position=CGPointMake(
                                  screenSize.width/2, 
                                  screenSize.height-uiframe.texture.contentSize.height/2);
        //加入到场景
        [self addChild:menu];
        //设置菜单项的间隔
        [menu alignItemsHorizontallyWithPadding:10.0f];
        
        //创建分数标签
        scoreLabel=[CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:12];
        scoreLabel.color=ccWHITE;
        //分数标签放在屏幕右上角位置
        scoreLabel.position=CGPointMake(screenSize.width, screenSize.height);
        //让分数标签和屏幕右边对齐
        scoreLabel.anchorPoint=CGPointMake(1.0f, 1.0f);
        //将分数标签加入到场景
        [self addChild:scoreLabel z:-1];
        //可以接收触摸事件
		self.isTouchEnabled = YES;
        //开始更新
        [self scheduleUpdate];
    }
	return self;
}
-(void)menuItemAbortTouched
{
    //退出游戏
    [[MultiLayerScene sharedLayer] abortGame];
}
-(void)menuItemPauseResumeTouched
{
    if(isPausing){
        //恢复
        [[MultiLayerScene sharedLayer] resumeGame];
        isPausing=NO;
        [itemPauseResume setString:@"Pause"];
        
    }else{
        //尝试暂停
        isPausing= [[MultiLayerScene sharedLayer] pauseGame];
        if(isPausing)
            [itemPauseResume setString:@"Resume"];
    }
}
-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}

-(void) update:(ccTime)delta
{
    //显示分数
    [scoreLabel setString:[NSString stringWithFormat:@"%i",[ScoreStore sharedStore].score]];
}
@end
