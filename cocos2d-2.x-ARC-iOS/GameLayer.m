//
//  GameLayer.m
//  MyDoodleDrop
//
//  Created by yzw on 3/7/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"


@implementation GameLayer
+(id)scene
{
    CCScene *scene=[CCScene node];
    CCLayer *layer=[GameLayer node];
    [scene addChild:layer];
    return scene;
}
- (id)init
{
    self = [super init];
    if (self) {
        CCLOG(@"%@: %@",NSStringFromSelector(_cmd),self);
    }
    return self;
}
- (void)dealloc
{
    CCLOG(@"%@: %@",NSStringFromSelector(_cmd),self);
}
@end
