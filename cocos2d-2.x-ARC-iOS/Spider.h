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
}
/**
 *  通过父节点来创建新对象
 *
 *  @param parentNode 父节点
 *
 *  @return 创建好的对象
 */
+(id) spiderWithParentNode:(CCNode*)parentNode;
/**
 *  通过父节点进行初始化
 *
 *  @param parentNode 父节点对象
 *
 *  @return 初始化后的对象
 */
-(id) initWithParentNode:(CCNode*)parentNode;

@end
