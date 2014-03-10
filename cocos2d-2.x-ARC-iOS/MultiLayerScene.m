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
        
		LevelA01* gameLayer = [LevelA01 node];
		[self addChild:gameLayer z:1 tag:LayerTagGameLayer];
		
		// The UserInterfaceLayer remains static and relative to the screen area.
		UserInterfaceLayer* uiLayer = [UserInterfaceLayer node];
		[self addChild:uiLayer z:2 tag:LayerTagUILayer];
	}
	
	return self;
}
+(CGPoint) locationFromTouch:(UITouch*)touch
{
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
	
	// The Layer will be gone now, to avoid crashes on further access it needs to be nil.
    //层即将销毁，为避免崩溃，将其设置为空
	sharedMultiLayerScene = nil;
}

@end
