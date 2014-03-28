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
	LevelIcon* level01=[[LevelIcon alloc] initWithLevel:1 locked:YES position:pos1 clickHandler:^(void){
        [[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneGameLevelA01]];
    }];
    [self addChild:level01];
    
    CGPoint pos2 = CGPointMake(screenSize.width / 3 * 2, screenSize.height / 2);
	LevelIcon* level02=[[LevelIcon alloc] initWithLevel:2 locked:NO position:pos2 clickHandler:^(void){
        [[CCDirector sharedDirector] replaceScene:[LoadingScene sceneWithTargetScene:TargetSceneGameLevelA02]];
    }];
    [self addChild:level02];
    
    //返回标签
    CCLabelTTF* labelBack=[CCLabelTTF labelWithString:@"Back" fontName:@"Marker Felt" fontSize:30];
    [labelBack setAnchorPoint:CGPointMake(0, 1)];
    labelBack.position=CGPointMake(0, screenSize.height);
    [self addChild:labelBack];
}
+(id)scene
{
    CCScene *scene=[CCScene node];
    CCLayer *layer=[SelectLevel node];
    [scene addChild:layer];
    return scene;
}
@end
