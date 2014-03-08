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
        //允许加速器
        self.isAccelerometerEnabled=YES;
        //创建玩家对象
        player=[CCSprite spriteWithFile:@"alien.png"];
        //添加玩家对象
        [self addChild:player z:0 tag:1];
        //将玩家对象摆放在屏幕底部中间位置
        CGSize screenSize=[CCDirector sharedDirector].winSize;
        float imageHeight=player.texture.contentSize.height;
        player.position=CGPointMake(screenSize.width/2, imageHeight/2);
        //开始自动更新
        [self scheduleUpdate];
        [self initSpiders];
    }
    return self;
}
- (void)dealloc
{
    CCLOG(@"%@: %@",NSStringFromSelector(_cmd),self);
}
-(void)initSpiders
{
    //获得屏幕的尺寸
    CGSize screenSize=[CCDirector sharedDirector].winSize;
    //创建一个临时的蜘蛛
    CCSprite *tempSpider=[CCSprite spriteWithFile:@"spider.png"];
    //获得蜘蛛的宽度
    float imageWidth=tempSpider.texture.contentSize.width;
    //计算屏幕可以摆下几个蜘蛛
    int numSpiders=screenSize.width/imageWidth;
    //创建蜘蛛数组
    spiders=[NSMutableArray arrayWithCapacity:numSpiders];
    //初始化每个蜘蛛
    for (int i=0; i<numSpiders; i++) {
        //创建蜘蛛精灵
        CCSprite *spider=[CCSprite spriteWithFile:@"spider.png"];
        //蜘蛛加入到场景中
        [self addChild:spider z:0 tag:2];
        //蜘蛛精灵放到数组中
        [spiders addObject:spider];
    }
    //重新摆放蜘蛛位置
    [self resetSpiders];
}
-(void)resetSpiders
{
    CGSize screenSize=[CCDirector sharedDirector].winSize;
    CCSprite *tempSpider=[spiders lastObject];
    CGSize size=tempSpider.texture.contentSize;
    int numSpiders=[spiders count];
    for (int i=0; i<numSpiders; i++) {
        CCSprite *spider=[spiders objectAtIndex:i];
        spider.position=CGPointMake(size.width*i+size.width*0.5f, screenSize.height+size.height);
        [spider stopAllActions];
    }
    [self schedule:@selector(spidersUpdate:) interval:0.7f];
    numSpidersMoved=0;
    spiderMoveDuration=4.0f;
}
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    //控制减速的快慢
    float deceleration=0.4f;
    //控制加速计的灵敏度
    float sensitiviy=6.0f;
    //控制最大的速度
    float maxVelocity=100;
    //根据加速度，计算玩家的速度
    playerVelocity.x=playerVelocity.x * deceleration + acceleration.x * sensitiviy;
    //控制速度不能太高，注意要控制正负2个方向
    if(playerVelocity.x>maxVelocity){
        playerVelocity.x=maxVelocity;
    }else if(playerVelocity.x<-maxVelocity){
        playerVelocity.x=-maxVelocity;
    }
}
-(void)update:(ccTime)delta
{
    //每帧都调用此方法
    //获得玩家的位置
    CGPoint pos=player.position;
    //根据计算的速度更新玩家位置
    pos.x += playerVelocity.x;
    //计算屏幕的左边和右边的极限位置
    CGSize screenSize=[CCDirector sharedDirector].winSize;
    float imageWidthHalved=player.texture.contentSize.width *0.5f;
    float leftBorderLimit=imageWidthHalved;
    float rightBorderLimit=screenSize.width-imageWidthHalved;
    //防止玩家跑到屏幕外面
    if(pos.x<leftBorderLimit){
        pos.x=leftBorderLimit;
        //已经贴近屏幕边缘，则不再加速了
        playerVelocity=CGPointZero;
    }else if(pos.x>rightBorderLimit){
        pos.x=rightBorderLimit;
        //已经贴近屏幕边缘，则不再加速了
        playerVelocity=CGPointZero;
    }
    player.position=pos;
}
@end
