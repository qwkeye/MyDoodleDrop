//
//  Spider.h
//  ScenesAndLayers
//
//  Created by Steffen Itterheim on 29.07.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "cocos2d.h"


@interface Spider : CCNode <CCTargetedTouchDelegate>
{
	// Adding a CCSprite as member variable instead of subclassing from it.
	// This is called composition or aggregation of objects, in contrast to subclassing or inheritance.
	CCSprite* spiderSprite;
	int numUpdates;
    float dropToBottom;//蜘蛛掉到屏幕底部剩余的时间
    CGPoint spriteOriginalPos;   //记录蜘蛛精灵初始的位置
    BOOL isMoving;
    BOOL isHanging;
    BOOL isDroping;
}
/**
 *  通过父节点来创建新对象
 *
 *  @param parentNode 父节点
 *  @param pos        初始位置
 *
 *  @return 创建好的对象
 */
+(id) spiderWithParentNode:(CCNode*)parentNode position:(CGPoint)pos;
/**
 *  通过父节点进行初始化
 *
 *  @param parentNode 父节点对象
 *  @param pos        初始位置
 *
 *  @return 初始化后的对象
 */
-(id) initWithParentNode:(CCNode*)parentNode position:(CGPoint)pos;
/**
 *  重置蜘蛛
 */
-(void)reset;
/**
 *  让蜘蛛开始掉下啦
 *
 *  @param duration 落下的时间，时间越短则速度越快
 */
-(void)startDrop:(float)duration;
/**
 *  检查蜘蛛是否在运动
 *
 *  @return 真假
 */
-(BOOL) getIsMoving;
/**
 *  获得蜘蛛的位置
 *
 *  @return 位置
 */
-(CGPoint)getSpritePosition;
/**
 *  获得碰撞的半径
 *
 *  @return 碰撞半径
 */
-(float)getCollisionRadius;
/**
 *  获得一个大致的尺寸，通常是精灵图像的尺寸
 *
 *  @return 对象的尺寸
 */
-(CGSize)getSize;
/**
 *  停止运动
 */
-(void)stop;
@end
