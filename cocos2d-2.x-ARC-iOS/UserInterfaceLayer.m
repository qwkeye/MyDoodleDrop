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
@synthesize score;
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
        [CCMenuItemFont setFontSize:12];
        //创建菜单项，并指定处理的方法
        CCMenuItemFont* itemPauseResume=[CCMenuItemFont itemWithString:@"Pause"
                                                            target:self
                                                          selector:@selector(menuItemPauseResumeTouched)];
        CCMenuItemFont* itemAbort=[CCMenuItemFont itemWithString:@"Abort"
                                                          target:self
                                                        selector:@selector(menuItemAbortTouched)];
        //创建菜单
        CCMenu* menu=[CCMenu menuWithItems:itemPauseResume,itemAbort, nil];
        //设置菜单位置
        //menu.position=uiframe.position;
        //加入到场景
        [uiframe addChild:menu];
        //设置菜单项的间隔
        [menu alignItemsHorizontallyWithPadding:4.0f];
        
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

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}

// Updates the progress timer
-(void) update:(ccTime)delta
{
    //显示分数
    [scoreLabel setString:[NSString stringWithFormat:@"%i",score]];
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
