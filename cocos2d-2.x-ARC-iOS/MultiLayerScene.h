//
//  MultiLayerScene.h
//  MyDoodleDrop
//
//  Created by rosen on 3/10/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
typedef enum
{
	LayerTagGameLayer,
	LayerTagUILayer,
} MultiLayerSceneTags;

typedef enum
{
	ActionTagGameLayerMovesBack,
	ActionTagGameLayerRotates,
} MultiLayerSceneActionTags;

@interface MultiLayerScene :CCLayer {
	BOOL isTouchForUserInterface;
    NSString* gameLevel;
}
/**
 *  将一个触摸事件转换为屏幕坐标？
 *
 *  @param touch UITouch对象
 *
 *  @return 一个CGPoint，代表屏幕坐标
 */
+(CGPoint) locationFromTouch:(UITouch*)touch;
/**
 *  将多个触摸事件转换为屏幕坐标
 *
 *  @param touches 多个UITouch对象
 *
 *  @return 一个CGPoint，代表屏幕坐标
 */
+(CGPoint) locationFromTouches:(NSSet *)touches;
/**
 *  Accessor methods to access the various layers of this scene
 *
 *  @return 共享对象
 */
+(MultiLayerScene*) sharedLayer;
/**
 *  以关卡名称来初始化
 *
 *  @param level 关卡名称
 *
 *  @return 初始化后的对象
 */
+(id) sceneWithLevel:(NSString*)level;
/**
 *  退出当前关卡，返回主菜单
 */
-(void)abortGame;
/**
 *  暂停游戏
 *
 *  @return 暂停是否成功
 */
-(BOOL)pauseGame;
/**
 *  恢复游戏
 */
-(void)resumeGame;
@end
