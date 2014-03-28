//
//  LoadingScene.h
//  MyDoodleDrop
//
//  Created by yzw on 3/11/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

 
typedef enum{
    TargetSceneINVALID=0,
    TargetSceneGameLevelA01,
    TargetSceneGameLevelA02,
    TargetSceneMAX,
}TargetSceneTypes;

@interface LoadingScene : CCScene {
    TargetSceneTypes targetScene;   //保存需要装载的场景的类型
}
+(id)sceneWithTargetScene:(TargetSceneTypes)sceneType;
-(id)initWithTargetScene:(TargetSceneTypes)sceneType;
@end
