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
+(CGPoint) locationFromTouch:(UITouch*)touch;
+(CGPoint) locationFromTouches:(NSSet *)touches;
// Accessor methods to access the various layers of this scene
+(MultiLayerScene*) sharedLayer;
+(id) sceneWithLevel:(NSString*)level;
-(void)abortGame;
/**
 *  暂停游戏
 *
 *  @return 暂停是否成功
 */
-(BOOL)pauseGame;
-(void)resumeGame;
@end
