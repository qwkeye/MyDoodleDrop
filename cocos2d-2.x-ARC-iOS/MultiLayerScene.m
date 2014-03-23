//
//  MultiLayerScene.m
//  MyDoodleDrop
//
//  Created by rosen on 3/10/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "MultiLayerScene.h"
#import "LevelA01.h"
#import "UserInterfaceLayer.h"
#import "LoadingScene.h"
@implementation MultiLayerScene
//半单例模式：仅在MultiLayerScene是活动的场景时，才存取 MultiLayerScene。
static MultiLayerScene* sharedMultiLayerScene = nil;

+(MultiLayerScene*) sharedLayer
{
	NSAssert(sharedMultiLayerScene != nil, @"MultiLayerScene not available!");
        return sharedMultiLayerScene;
}

+(id) scene
{
	CCScene* scene = [CCScene node];
	MultiLayerScene* layer = [MultiLayerScene node];
	[scene addChild:layer];
	return scene;
}

-(id) init
{
	if ((self = [super init]))
	{
		NSAssert(sharedMultiLayerScene == nil, @"another MultiLayerScene is already in use!");
		sharedMultiLayerScene = self;
        //创建游戏层
		LevelA01* gameLayer = [LevelA01 node];
		[self addChild:gameLayer z:1 tag:LayerTagGameLayer];
		//创建用户界面层
		// The UserInterfaceLayer remains static and relative to the screen area.
		UserInterfaceLayer* uiLayer = [UserInterfaceLayer node];
		[self addChild:uiLayer z:2 tag:LayerTagUILayer];
        //每0.1秒更新分数
        [self schedule:@selector(updateScore) interval:0.1f];
	}
	return self;
}
/**
 *  更新分数值
 */
-(void)updateScore
{
    //获得游戏层
    CCNode* layer1=[self getChildByTag:LayerTagGameLayer];
    NSAssert1([layer1 isKindOfClass:[LevelA01 class]], @"not a LevelA01", 
              NSStringFromSelector(_cmd));
    //转换对象
    LevelA01* gameLayer=(LevelA01*)layer1;
    //获得用户界面层
    CCNode* layer2=[self getChildByTag:LayerTagUILayer];
    NSAssert1([layer2 isKindOfClass:[UserInterfaceLayer class]], @"not a UserInterfaceLayer", 
              NSStringFromSelector(_cmd));
    UserInterfaceLayer* uiLayer=(UserInterfaceLayer*)layer2;
    //从游戏层获得分数，然后更新分数
    uiLayer.score=gameLayer.score;
}
/**
 *  将一个触摸事件转换为屏幕坐标？
 *
 *  @param touch UITouch对象
 *
 *  @return 一个CGPoint，代表屏幕坐标
 */
+(CGPoint) locationFromTouch:(UITouch*)touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}
/**
 *  将多个触摸事件转换为屏幕坐标
 *
 *  @param touches 多个UITouch对象
 *
 *  @return 一个CGPoint，代表屏幕坐标
 */
+(CGPoint) locationFromTouches:(NSSet*)touches
{
	return [self locationFromTouch:[touches anyObject]];
}
/**
 *  退出当前关卡，返回主菜单
 */
-(void)abortGame
{
    //停止所有更新
    [self unscheduleAllSelectors];
    //销毁各个子对象
    [self removeAllChildrenWithCleanup:YES];
    //指针置空
    sharedMultiLayerScene=nil;
    //返回主菜单
    [[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneMain]];
}
-(BOOL)pauseGame
{
    //获得游戏层
    CCNode* layer1=[self getChildByTag:LayerTagGameLayer];
    NSAssert1([layer1 isKindOfClass:[LevelA01 class]], @"not a LevelA01",
              NSStringFromSelector(_cmd));
    //转换对象
    LevelA01* gameLayer=(LevelA01*)layer1;
    if(gameLayer.isGameOver)
        return NO;
    else{
        [gameLayer pauseGame];
        return YES;
    }
}
-(void)resumeGame
{
    //获得游戏层
    CCNode* layer1=[self getChildByTag:LayerTagGameLayer];
    NSAssert1([layer1 isKindOfClass:[LevelA01 class]], @"not a LevelA01",
              NSStringFromSelector(_cmd));
    //转换对象
    LevelA01* gameLayer=(LevelA01*)layer1;
    [gameLayer resumeGame];
}
-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    //层即将销毁，为避免崩溃，将其设置为空
	sharedMultiLayerScene = nil;
}
@end
