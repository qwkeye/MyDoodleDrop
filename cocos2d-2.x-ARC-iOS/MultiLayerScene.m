//
//  MultiLayerScene.m
//  MyDoodleDrop
//
//  Created by rosen on 3/10/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "MultiLayerScene.h"
#import "LevelA.h"
#import "LevelA01.h"
#import "LevelA02.h"
#import "UserInterfaceLayer.h"
#import "LoadingScene.h"
#import "SelectLevel.h"
@implementation MultiLayerScene
//半单例模式：仅在MultiLayerScene是活动的场景时，才存取 MultiLayerScene。
static MultiLayerScene* sharedMultiLayerScene = nil;

+(MultiLayerScene*) sharedLayer
{
	NSAssert(sharedMultiLayerScene != nil, @"MultiLayerScene not available!");
    return sharedMultiLayerScene;
}

+(id) sceneWithLevel:(NSString *)level
{
	CCScene* scene = [CCScene node];
	MultiLayerScene* layer = [[MultiLayerScene alloc] initWithLevel:level];
	[scene addChild:layer];
	return scene;
}

-(id) initWithLevel:(NSString *)level
{
	if ((self = [super init]))
	{
		NSAssert(sharedMultiLayerScene == nil, @"another MultiLayerScene is already in use!");
		sharedMultiLayerScene = self;
        gameLevel=level;
        //创建游戏层
        if([level isEqual:@"A02"]){
            LevelA* gameLayer = [LevelA initWithLevelId:level moveDuration:2.0];
            [self addChild:gameLayer z:1 tag:LayerTagGameLayer];
        }else{
            LevelA* gameLayer = [LevelA initWithLevelId:level moveDuration:5.0];
            [self addChild:gameLayer z:1 tag:LayerTagGameLayer];
        }
		//创建用户界面层
		// The UserInterfaceLayer remains static and relative to the screen area.
		UserInterfaceLayer* uiLayer = [UserInterfaceLayer node];
		[self addChild:uiLayer z:2 tag:LayerTagUILayer];
	}
	return self;
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
    [[CCDirector sharedDirector] replaceScene:[SelectLevel scene]];
}
-(BOOL)pauseGame
{
    //获得游戏层
    CCNode* layer1=[self getChildByTag:LayerTagGameLayer];
    //转换对象
    id<LevelAProtocol> gameLayer=(id<LevelAProtocol>)layer1;
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
    //转换对象
    id<LevelAProtocol> gameLayer=(id<LevelAProtocol>)layer1;
    [gameLayer resumeGame];
}
-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    //层即将销毁，为避免崩溃，将其设置为空
	sharedMultiLayerScene = nil;
}
@end
