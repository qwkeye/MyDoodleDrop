//
//  Player.h
//  MyDoodleDrop
//
//  Created by rosen on 3/18/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@interface Player : CCNode {
    CCSprite* playerSprite;
    CGPoint spriteOriginalPos;   //记录精灵初始的位置
    BOOL isMoving;
}
/**
 *  通过父节点来创建新对象
 *
 *  @param parentNode 父节点
 *  @param pos        初始位置
 *
 *  @return 创建好的对象
 */
+(id) playerWithParentNode:(CCNode*)parentNode position:(CGPoint)pos;
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
 *  检查是否在运动
 *
 *  @return 真假
 */
-(BOOL) getIsMoving;
/**
 *  获得玩家的位置
 *
 *  @return 玩家位置
 */
-(CGPoint)getSpritePosition;
/**
 *  设置玩家位置
 *
 *  @param position 玩家新位置
 */
-(void)setSpritePosition:(CGPoint)position;
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
+(CGSize)getSize;
/**
 *  停止运动
 */
-(void)stop;
/**
 *  暂停游戏
 */
-(void)pauseGame;
/**
 *  恢复游戏
 */
-(void)resumeGame;
@end
