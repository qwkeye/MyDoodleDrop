//
//  LoadingScene.m
//  MyDoodleDrop
//
//  Created by yzw on 3/11/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "LoadingScene.h"
#import "MainScreen.h"
#import "LevelA01.h"
#import "MultiLayerScene.h"

@implementation LoadingScene
+(id)sceneWithTargetScene:(TargetSceneTypes)sceneType
{
    return [[self alloc] initWithTargetScene:sceneType];
}
-(id)initWithTargetScene:(TargetSceneTypes)sceneType
{
    if(self=[self init]){
        //记录需要加载的场景类型
        targetScene=sceneType;
        //显示信息标签
        CCLabelTTF* label=[CCLabelTTF labelWithString:@"Loading ......"
                                             fontName:@"Marker Felt"
                                             fontSize:64];
        CGSize size=[CCDirector sharedDirector].winSize;
        label.position=CGPointMake(size.width/2, size.height/2);
        [self addChild:label];
        
        //设定下一帧才开始加载真正的场景
        [self scheduleOnce:@selector(loadScene:) delay:0.0f];
    }
    return self;
}
-(void)loadScene:(ccTime)delta
{
    //根据场景类型加载真正的场景
    switch (targetScene) {
        case TargetSceneMain:
            //加载主界面
            [[CCDirector sharedDirector] replaceScene:[MainScreen scene]];
            break;
        case TargetSceneGameLevelA01:
            //加载游戏：第一关
            [[CCDirector sharedDirector] replaceScene:[MultiLayerScene sceneWithLevel:@"A01"]];
            break;
        case TargetSceneGameLevelA02:
            //加载游戏：第二关
            [[CCDirector sharedDirector] replaceScene:[MultiLayerScene sceneWithLevel:@"A02"]];
            break;
        case TargetSceneAbout:
            CCLOG(@"show about screen!");
            break;
        default:
            NSAssert2(nil, @"%@: unsupported TargetScene %i", NSStringFromSelector(_cmd), targetScene);
            break;
    }
}
@end
