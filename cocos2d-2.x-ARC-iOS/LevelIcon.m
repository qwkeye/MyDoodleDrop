//
//  LevelIcon.m
//  SpidersDrop
//
//  Created by rosen on 3/28/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "LevelIcon.h"
#import "MultiLayerScene.h"
@implementation LevelIcon
-(id)initWithLevel:(NSString*)level locked:(BOOL)locked position:(CGPoint)pos clickHandler:(void (^)(void))callback
{
	if ((self = [super init]))
	{
        CCLOG(@"%@: %@",NSStringFromSelector(_cmd),self);
        //创建一个精灵，显示背景图标
        if(locked){
            backgroundSprite = [CCSprite spriteWithFile:@"level_icon_locked.png"];
        }else{
            backgroundSprite = [CCSprite spriteWithFile:@"level_icon.png"];
        }
		backgroundSprite.position = pos;
        
		[self addChild:backgroundSprite];
        //创建一个字符，显示第几关
        int fontSize=36;
        if([level length]>3)
            fontSize=24;
        CCLabelTTF* levelLabel = [CCLabelTTF labelWithString:level
                                                    fontName:@"Marker Felt"
                                                    fontSize:fontSize];
        levelLabel.position=pos;
        [self addChild:levelLabel];
        //可以接收触摸事件
        [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self
                                                                priority:-1
                                                         swallowsTouches:YES];
        //记录回调的block
        touchHandler=callback;
	}
	return self;
}
- (void)dealloc
{
    CCLOG(@"%@: %@",NSStringFromSelector(_cmd),self);
}
-(void) cleanup
{
    //手动注销触摸事件接收器
	[[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
    [super cleanup];
}
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchLocation = [MultiLayerScene locationFromTouch:touch];
	
	// Check if this touch is on the Spider's sprite.
	BOOL isTouchHandled = CGRectContainsPoint([backgroundSprite boundingBox], touchLocation);
	if (isTouchHandled)
	{
		//执行指定的block
        if(touchHandler!=nil)
            touchHandler();
	}
	return isTouchHandled;
}
@end
