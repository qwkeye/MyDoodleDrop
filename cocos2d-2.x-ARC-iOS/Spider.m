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
@synthesize scoreProcessor;
// Static initializer, mimics cocos2d's memory allocation scheme.
+(id) spiderWithParentNode:(CCNode*)parentNode position:(CGPoint)pos
{
	return [[self alloc] initWithParentNode:parentNode position:pos];
}

-(id) initWithParentNode:(CCNode*)parentNode position:(CGPoint)pos
{
	if ((self = [super init]))
	{
        CCLOG(@"%@: %@",NSStringFromSelector(_cmd),self);
		// 将自己添加到父节点
		[parentNode addChild:self];
		spiderSprite = [CCSprite spriteWithFile:@"spider.png"];
		spiderSprite.position = pos;
        //记录原始位置
        spriteOriginalPos=pos;
        //添加一个精灵对象
		[self addChild:spiderSprite];
		[self scheduleUpdate];
        //可以接收触摸事件
        [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self
                                                                priority:-1
                                                         swallowsTouches:YES];
	}
	
	return self;
}
- (void)dealloc
{
    CCLOG(@"%@: %@",NSStringFromSelector(_cmd),self);
}
-(void)stop
{
    [spiderSprite stopAllActions];
    isMoving=NO;
}
-(void)pauseGame
{
    [self pauseSchedulerAndActions];
    [spiderSprite pauseSchedulerAndActions];
    isPausing=YES;
}
-(void)resumeGame
{
    [self resumeSchedulerAndActions];
    [spiderSprite resumeSchedulerAndActions];
    isPausing=NO;
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
 *  让蜘蛛偏离到某一点，然后继续下坠
 *
 *  @param duration 偏离运动的时间
 *  @param moveTo   偏离目的地坐标
 */
-(void) moveAway:(float)duration position:(CGPoint)moveTo
{
    //停止当前运动
	[spiderSprite stopAllActions];
    //蜘蛛飘到一个位置，注意这个是偏移到一个相对位置
	CCMoveBy* move = [CCMoveBy actionWithDuration:duration position:moveTo];
    //计算蜘蛛掉到屏幕下面的位置（绝对位置）
    CGPoint belowScreenPosition=CGPointMake(spiderSprite.position.x+moveTo.x, -spiderSprite.texture.contentSize.height);
    //创建一个运动：从偏移的位置继续掉下来，注意时间是选取全局变量dropToBottom
    CCMoveTo* drop=[CCMoveTo actionWithDuration:dropToBottom position:belowScreenPosition];
    //创建一个回调块：掉到屏幕底部后，重新将蜘蛛放在屏幕的顶端
    CCCallBlock* callDidDrop=[CCCallBlock actionWithBlock:^void() {
        spiderSprite.position=spriteOriginalPos;
        isMoving=NO;
    }];
    //创建一个动作序列：掉下来，然后重置位置
    CCSequence* sequence=[CCSequence actions:move,drop,callDidDrop,nil];
    //蜘蛛执行动作
    [spiderSprite runAction:sequence];
}

-(void) update:(ccTime)delta
{
    if(isDroping && dropToBottom>0){
        //记录还有多少时间掉到底下
        dropToBottom-=delta;
    }
}
-(void)startDrop:(float)duration
{
    dropToBottom=duration;
    //计算蜘蛛掉到屏幕下面的位置
    CGPoint belowScreenPosition=CGPointMake(spiderSprite.position.x, -spiderSprite.texture.contentSize.height);
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    //创建一个运动：从屏幕顶部悬停到一个随机的位置
    CGPoint hangInTherePosition = CGPointMake(spiderSprite.position.x, screenSize.height
                                              - (3 * CCRANDOM_0_1() +1) * spiderSprite.texture.contentSize.height);
    CCMoveTo* moveHang = [CCMoveTo actionWithDuration:2 position:hangInTherePosition];
	CCEaseElasticOut* easeHang = [CCEaseElasticOut actionWithAction:moveHang period:0.8f];
    //创建一个运动：从屏幕顶部掉下来
	CCMoveTo* moveEnd = [CCMoveTo actionWithDuration:duration position:belowScreenPosition];
	CCEaseBackInOut* easeEnd = [CCEaseBackInOut actionWithAction:moveEnd];
    //创建一个回调块：掉到屏幕底部后，重新将蜘蛛放在屏幕的顶端
    CCCallBlock* callDidDrop=[CCCallBlock actionWithBlock:^void() {
        spiderSprite.position=spriteOriginalPos;
        isMoving=NO;
        isDroping=NO;
        //获得一分！
        [scoreProcessor addScoreInLevel:0 earnedScore:1];
        //[CCLOG(@"spider at x drop to ")];
    }];
    //回调快：标记蜘蛛正在下坠
    CCCallBlock* callStartDrop=[CCCallBlock actionWithBlock:^void() {
        isHanging= NO;
        isDroping=YES;
    }];

    //创建一个动作序列
    CCSequence* sequence=[CCSequence actions:easeHang,callStartDrop, easeEnd, callDidDrop, nil];
    //蜘蛛执行动作
    [spiderSprite runAction:sequence];
    //设置全局标志
    isMoving=YES;
    isHanging=YES;
    isDroping=NO;
}
-(CGPoint)getSpritePosition
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
    //暂停时不接收触摸事件
    if(isPausing)
        return NO;
    //蜘蛛在静止时不接收触摸事件
    if (isDroping==NO) {
        return NO;
    }
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
-(CGSize)getSize
{
    return spiderSprite.texture.contentSize;
}
-(void) draw
{
	[super draw];
#if DEBUG
    //调试模式下，给蜘蛛描绘一个展示碰撞范围的圈
    float radius = spiderSprite.texture.contentSize.width * 0.4f;
    float angle = 0;
    int numSegments = 10;
    bool drawLineToCenter = NO;
    ccDrawCircle(spiderSprite.position, radius, angle, numSegments, drawLineToCenter);
#endif
	
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	//仅当蜘蛛在悬挂才画线
    if (isHanging)
    {
        // vary thread position a little so it looks a bit more dynamic
        float threadX = spiderSprite.position.x + (CCRANDOM_0_1() * 2.0f - 1.0f);
        ccDrawColor4F(0.5f, 0.5f, 0.5f, 1.0f);
        ccDrawLine(spiderSprite.position, CGPointMake(threadX, screenSize.height));
    }
}
@end

