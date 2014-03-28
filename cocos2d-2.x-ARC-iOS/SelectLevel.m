//
//  SelectLevel.m
//  SpidersDrop
//
//  Created by rosen on 3/28/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "SelectLevel.h"
#import "LevelIcon.h"
#import "LoadingScene.h"
#import "MainScreen.h"
@implementation SelectLevel
- (id)init
{
    self = [super init];
    if (self) {
        [self listLevels];
    }
    return self;
}
-(void)listLevels
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
	CGPoint pos1 = CGPointMake(screenSize.width / 3, screenSize.height / 2);
	LevelIcon* level01=[[LevelIcon alloc] initWithLevel:@"1"
                                                 locked:NO
                                               position:pos1
                                           clickHandler:^(void){
                                               [[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneGameLevelA01]];
                                           }];
    [self addChild:level01];
    
    CGPoint pos2 = CGPointMake(screenSize.width / 3 * 2, screenSize.height / 2);
	LevelIcon* level02=[[LevelIcon alloc] initWithLevel:@"2"
                                                 locked:NO
                                               position:pos2
                                           clickHandler:^(void){
                                               [[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneGameLevelA02]];
                                           }];
    [self addChild:level02];
    
    //返回标签
    CGPoint pos3 = CGPointMake(screenSize.width / 2, screenSize.height / 3);
	LevelIcon* iconBack=[[LevelIcon alloc] initWithLevel:@"Back"
                                                  locked:NO
                                                position:pos3
                                            clickHandler:^(void){
                                                [[CCDirector sharedDirector] replaceScene:[MainScreen scene]];
                                            }];
    [self addChild:iconBack];
}
+(id)scene
{
    CCScene *scene=[CCScene node];
    CCLayer *layer=[SelectLevel node];
    [scene addChild:layer];
    return scene;
}
@end
