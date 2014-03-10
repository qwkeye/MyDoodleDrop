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
    CGPoint playerVelocity; //玩家移动的速度
    NSMutableArray *spiders;//蜘蛛数组
    float spiderMoveDuration;//蜘蛛从顶端掉到底端的时间
    int numSpidersMoved;//移动的蜘蛛数
    
    int score;//玩家的分数
    CCNode<CCLabelProtocol>* scoreLabel;//用于显示分数的标签
}
+(id)scene;
@end
