//
//  LevelA.h
//  MyDoodleDrop
//
//  Created by rosen on 3/12/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "ScoreProcessor.h"
@interface LevelA : CCLayer <ScoreProcessor>   {
    Player *player;       //玩家对象
    CGPoint playerVelocity; //玩家移动的速度
    NSMutableArray *spiders;//蜘蛛数组
    float spiderMoveDuration;//蜘蛛从顶端掉到底端的时间
    int numSpidersMoved;//移动的蜘蛛数
    float playerMoveLeftBorderLimit;//玩家能够移动到最左边的地方
    float playerMoveRightBorderLimit;//玩家能够移动到最右边的地方
    /*===========================
     计分机制的说明
     躲过一只蜘蛛，则获得相应的分数，不同
     种类的蜘蛛，权重分不一样，比如简单的
     蜘蛛，则记1分，比较恐怖的蜘蛛，则记
     3分，等等
     ============================*/
}
@property (readonly) int score;
@property (readonly) BOOL isGameOver;
+(id)scene;
-(void)pauseGame;
-(void)resumeGame;
@end
