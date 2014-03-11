//
//  UserInterfaceLayer.h
//  ScenesAndLayers
//
//  Created by Steffen Itterheim on 28.07.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
	UILayerTagFrameSprite,
	UILayerTagProgressTimer,
} UserInterfaceLayerTags;

@interface UserInterfaceLayer : CCLayer 
{
    CCNode<CCLabelProtocol>* scoreLabel;//用于显示分数的标签
}
//判断是否处理触控输入
-(BOOL) isTouchForMe:(CGPoint)touchLocation;
//玩家分数
@property int score;
@end
