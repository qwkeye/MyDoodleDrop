//
//  Spider.m
//  ScenesAndLayers
//
//  Created by Steffen Itterheim on 29.07.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "Spider.h"
#import "MultiLayerScene.h"

@implementation Spider
// Static initializer, mimics cocos2d's memory allocation scheme.
+(id) spiderWithParentNode:(CCNode*)parentNode position:(CGPoint)pos
{
	return [[self alloc] initWithParentNode:parentNode position:pos];
}

-(id) initWithParentNode:(CCNode*)parentNode position:(CGPoint)pos
{
	if ((self = [super init]))
	{
		// 将自己添加到父节点
		[parentNode addChild:self];
		
		CGSize screenSize = [CCDirector sharedDirector].winSize;

		spiderSprite = [CCSprite spriteWithFile:@"spider.png"];
		spiderSprite.position = pos;
        //记录原始位置
        spriteOriginalPos=pos;
        //添加一个精灵对象
		[self addChild:spiderSprite];
		[self scheduleUpdate];
		//可以接收触摸事件
        [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:-1 swallowsTouches:YES];
	}
	
	return self;
}
-(void)reset
{
    [spiderSprite stopAllActions];
    spiderSprite.position=spriteOriginalPos;
}
-(void) cleanup
{
    //手动注销触摸事件接收器
	[[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
    [super cleanup];
}

/**
 *  Extract common logic into a separate method accepting parameters.
 *
 *  @param duration <#duration description#>
 *  @param moveTo   <#moveTo description#>
 */
-(void) moveAway:(float)duration position:(CGPoint)moveTo
{
	[spiderSprite stopAllActions];
	CCMoveBy* move = [CCMoveBy actionWithDuration:duration position:moveTo];
	[spiderSprite runAction:move];
}

-(void) update:(ccTime)delta
{
    /*
	numUpdates++;
	if (numUpdates > 60)
	{
		numUpdates = 0;
		// Move at regular speed.
		CGPoint moveTo = CGPointMake(CCRANDOM_0_1() * 200 - 100, CCRANDOM_0_1() * 100 - 50);
		[self moveAway:2 position:moveTo];
	}
     */
}
-(void)startDrop:(float)duration
{
    //计算蜘蛛掉到屏幕下面的位置
    CGPoint belowScreenPosition=CGPointMake(spiderSprite.position.x, -spiderSprite.texture.contentSize.height);
    //创建一个运动：从屏幕顶部掉下来
    CCMoveTo* move=[CCMoveTo actionWithDuration:duration position:belowScreenPosition];
    //创建一个回调块：掉到屏幕底部后，重新将蜘蛛放在屏幕的顶端
    CCCallBlock* callDidDrop=[CCCallBlock actionWithBlock:^void() {
        spiderSprite.position=spriteOriginalPos;
        isMoving=NO;
    }];
    //创建一个动作序列：掉下来，然后重置位置
    CCSequence* sequence=[CCSequence actions:move,callDidDrop,nil];
    //蜘蛛执行动作
    [spiderSprite runAction:sequence];
    isMoving=YES;
}
-(CGPoint)getPosition
{
    return spiderSprite.position;
}
-(float)getCollisionRadius
{
    //获得蜘蛛精灵图像的宽度
    float spiderImageSize=spiderSprite.texture.contentSize.width;
    //设定碰撞半径
    return spiderImageSize*0.4f;
}
-(BOOL)getIsMoving{
    return isMoving;
}
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchLocation = [MultiLayerScene locationFromTouch:touch];
	
	// Check if this touch is on the Spider's sprite.
	BOOL isTouchHandled = CGRectContainsPoint([spiderSprite boundingBox], touchLocation);
	if (isTouchHandled)
	{
		// Reset move counter.
		numUpdates = 0;
		
		// Move away from touch loation rapidly.
		CGPoint moveTo;
		float moveDistance = 40;
		float rand = CCRANDOM_0_1();
		
		// Randomly pick one of four corners to move away to.
		if (rand < 0.25f)
			moveTo = CGPointMake(moveDistance, moveDistance);
		else if (rand < 0.5f)
			moveTo = CGPointMake(-moveDistance, moveDistance);
		else if (rand < 0.75f)
			moveTo = CGPointMake(moveDistance, -moveDistance);
		else
			moveTo = CGPointMake(-moveDistance, -moveDistance);
		
		[self moveAway:0.1f position:moveTo];
	}
	
	return isTouchHandled;
}


@end
