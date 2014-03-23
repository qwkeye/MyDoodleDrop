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
    CCLabelTTF* scoreLabel;//用于显示分数的标签
    CCMenuItemFont* itemPauseResume;//显示暂停、恢复的菜单
    BOOL isPausing;//是否暂停中
}
//玩家分数
@property int score;
@end
