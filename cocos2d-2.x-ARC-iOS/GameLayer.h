//
//  GameLayer.h
//  MyDoodleDrop
//
//  Created by yzw on 3/7/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLayer : CCLayer {
    CCSprite *player;       //玩家对象
    CGPoint playerVelocity; //玩家的加速度？
    NSMutableArray *spiders;//蜘蛛数组
    float spiderMoveDuration;
    int numSpidersMoved;
}
+(id)scene;
@end
