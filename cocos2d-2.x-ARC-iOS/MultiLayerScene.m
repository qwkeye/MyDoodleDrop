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
        //每0.5秒更新分数
        [self schedule:@selector(updateScore) interval:0.5f];
	}
	
	return self;
}
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
    //更新分数
    uiLayer.score=gameLayer.score;
}
+(CGPoint) locationFromTouch:(UITouch*)touch
{
    //==============================
    //将触摸事件转换为屏幕坐标？
    //==============================
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

+(CGPoint) locationFromTouches:(NSSet*)touches
{
	return [self locationFromTouch:[touches anyObject]];
}
-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    //层即将销毁，为避免崩溃，将其设置为空
	sharedMultiLayerScene = nil;
}
@end
