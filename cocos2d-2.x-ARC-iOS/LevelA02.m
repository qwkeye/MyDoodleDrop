//
//  LevelA02.m
//  SpidersDrop
//
//  Created by rosen on 3/28/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "LevelA02.h"


@implementation LevelA02
- (id)init
{
    self = [super init];
    if (self) {
        //初始化：蜘蛛从顶端掉到底端的时间
        spiderMoveDuration=2.0f;
        levelId=@"A02";
    }
    return self;
}
@end
