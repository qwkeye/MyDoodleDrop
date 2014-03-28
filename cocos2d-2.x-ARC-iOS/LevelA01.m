//
//  LevelA01.m
//  MyDoodleDrop
//
//  Created by rosen on 3/10/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "LevelA01.h"

@implementation LevelA01
- (id)init
{
    self = [super init];
    if (self) {
        //初始化：蜘蛛从顶端掉到底端的时间
        spiderMoveDuration=5.0f;
        levelId=@"A01";
    }
    return self;
}
@end
