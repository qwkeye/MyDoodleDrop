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
        //一个演示用的标签
		CCLabelTTF* label = [CCLabelTTF labelWithString:@"Here be your Game Scores etc" fontName:@"Courier" fontSize:12];
		label.color = ccBLACK;
		label.position = CGPointMake(screenSize.width / 2, screenSize.height);
		label.anchorPoint = CGPointMake(0.5f, 1);
		[self addChild:label];
		
		self.isTouchEnabled = YES;
		//增加一个显示进度的精灵，显示在右下角
        CCSprite* fireSprite = [CCSprite spriteWithFile:@"alien.png"];
		CCProgressTimer* timer = [CCProgressTimer progressWithSprite:fireSprite];
		timer.type = kCCProgressTimerTypeRadial;
		timer.position = CGPointMake([CCDirector sharedDirector].winSize.width, 0);
		timer.anchorPoint = CGPointMake(1, 0); // right-align and bottom-align timer
		timer.percentage = 0;
		timer.color = ccGRAY;
		//timer.scale = 1.7f;//精灵放大的倍数
		[self addChild:timer z:1 tag:UILayerTagProgressTimer];
        //增加了进度精灵，则需要定时更新
		[self scheduleUpdate];
	}
	return self;
}

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}

// Updates the progress timer
-(void) update:(ccTime)delta
{
	CCNode* node = [self getChildByTag:UILayerTagProgressTimer];
	NSAssert([node isKindOfClass:[CCProgressTimer class]], @"node is not a CCProgressTimer");
	//更新进度
	CCProgressTimer* timer = (CCProgressTimer*)node;
	timer.percentage += delta * 10;
	if (timer.percentage >= 100)
	{
        //复位
		timer.percentage = 0;
	}
}

-(void) registerWithTouchDispatcher
{
	[[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:-1 swallowsTouches:YES];
}

-(BOOL) isTouchForMe:(CGPoint)touchLocation
{
    //==============================
    //检查用户的触控点是否在本层需要处理的
    //范围之内
    //==============================
	CCNode* node = [self getChildByTag:UILayerTagFrameSprite];
	return CGRectContainsPoint([node boundingBox], touchLocation);
}

-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event
{
	CGPoint location = [MultiLayerScene locationFromTouch:touch];
	BOOL isTouchHandled = [self isTouchForMe:location];
	if (isTouchHandled)
	{
		// Simply highlight the UI layer's sprite to show that it received the touch.
        //设置精灵的背景色为红色，以通知用户收到了触摸事件
		CCNode* node = [self getChildByTag:UILayerTagFrameSprite];
		NSAssert([node isKindOfClass:[CCSprite class]], @"node is not a CCSprite");
		((CCSprite*)node).color = ccRED;
	}

	return isTouchHandled;
}

-(void) ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event
{
	CCNode* node = [self getChildByTag:UILayerTagFrameSprite];
	NSAssert([node isKindOfClass:[CCSprite class]], @"node is not a CCSprite");
    //触摸结束后，还原背景色
	((CCSprite*)node).color = ccWHITE;
}

@end
