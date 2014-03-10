//
//  GameLayer.m
//  MyDoodleDrop
//
//  Created by yzw on 3/7/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "SimpleAudioEngine.h"

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
        //重置所有的蜘蛛
        [self initSpiders];
        //创建分数标签
        scoreLabel=[CCLabelBMFont labelWithString:@"0"
                                          fntFile:@"bitmapfont.fnt"];
        //分数标签放在屏幕顶端中间位置
        scoreLabel.position=CGPointMake(screenSize.width/2, screenSize.height);
        //让分数标签和屏幕顶端对齐
        scoreLabel.anchorPoint=CGPointMake(0.5f, 1.0f);
        //讲分数标签加入到场景
        [self addChild:scoreLabel z:-1];
        //播放背景音乐
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"blues.mp3" loop:YES];
        //预加载声音
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"alien-sfx.caf"];
    }
    return self;
}
- (void)dealloc
{
    CCLOG(@"%@: %@",NSStringFromSelector(_cmd),self);
}
-(void)initSpiders
{
    //==============================
    //重置所有的蜘蛛
    //==============================
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
    //==============================
    //重置所有蜘蛛
    //==============================
    //获得屏幕尺寸
    CGSize screenSize=[CCDirector sharedDirector].winSize;
    //获得一个蜘蛛
    CCSprite *tempSpider=[spiders lastObject];
    //获得蜘蛛的尺寸
    CGSize size=tempSpider.texture.contentSize;
    //获得蜘蛛的数量
    int numSpiders=[spiders count];
    //重设每个蜘蛛的位置
    for (int i=0; i<numSpiders; i++) {
        CCSprite *spider=[spiders objectAtIndex:i];
        //蜘蛛的高度在屏幕外面，这样蜘蛛就不可见了
        spider.position=CGPointMake(size.width*i+size.width*0.5f, screenSize.height+size.height);
        //停止蜘蛛的所有动作
        [spider stopAllActions];
    }
    //定时更新蜘蛛
    [self schedule:@selector(spidersUpdate:) interval:0.7f];
    //初始化：移动的蜘蛛数量
    numSpidersMoved=0;
    //初始化：蜘蛛从顶端掉到底端的时间
    spiderMoveDuration=4.0f;
}
-(void)spidersUpdate:(ccTime)delta
{
    //==============================
    //实现让蜘蛛频繁地落下
    //==============================
    for (int i=0; i<10; i++) {
        //随机挑选一个蜘蛛
        int randomSpiderIndex=CCRANDOM_0_1()*spiders.count;
        CCSprite *spider=[spiders objectAtIndex:randomSpiderIndex];
        if(spider.numberOfRunningActions==0){
            //如果这只蜘蛛还没有动过，则让它动起来
            [self runSpiderMoveSequence:spider];
            //一次只触动一只蜘蛛
            break;
        }
    }
}
-(void)runSpiderMoveSequence:(CCSprite*)spider
{
    //==============================
    //控制蜘蛛运动的动作序列
    //==============================
    //记录已经在运送的蜘蛛的数量
    numSpidersMoved++;
    //让蜘蛛加速落下
    if(numSpidersMoved % 8 == 0 && spiderMoveDuration > 2.0f){
        spiderMoveDuration-=0.1f;
    }
    //计算蜘蛛掉到屏幕下面的位置
    CGPoint belowScreenPosition=CGPointMake(spider.position.x, -spider.texture.contentSize.height);
    //创建一个运动：从屏幕顶部掉下来
    CCMoveTo* move=[CCMoveTo actionWithDuration:spiderMoveDuration position:belowScreenPosition];
    //创建一个回调块：掉到屏幕底部后，重新将蜘蛛放在屏幕的顶端
    CCCallBlock* callDidDrop=[CCCallBlock actionWithBlock:^void() {
        CGPoint pos=spider.position;
        CGSize screenSize=[CCDirector sharedDirector].winSize;
        pos.y=screenSize.height+spider.texture.contentSize.height;
        spider.position=pos;
    }];
    //创建一个动作序列：掉下来，然后重置位置
    CCSequence* sequence=[CCSequence actions:move,callDidDrop,nil];
    //蜘蛛执行动作
    [spider runAction:sequence];
}
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    //==============================
    //加速计事件处理函数
    //==============================
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
-(void)checkForCollision
{
    //==============================
    //检测玩家和蜘蛛是否碰撞，假设玩家
    //和蜘蛛的图像都是正方形
    //==============================
    //获得玩家和蜘蛛的图像尺寸
    float playerImageSize=player.texture.contentSize.width;
    CCSprite* spider=[spiders lastObject];
    float spiderImageSize=spider.texture.contentSize.width;
    //设定玩家的碰撞半径
    float playerCollisionRadius=playerImageSize*0.4f;
    //设定蜘蛛的碰撞半径
    float spiderCollisionRadius=spiderImageSize*0.4f;
    //计算碰撞距离
    float maxCollisionDistance=playerCollisionRadius+spiderCollisionRadius;
    //循环检测蜘蛛
    int numSpiders=spiders.count;
    for (int i=0; i<numSpiders; i++) {
        //获得蜘蛛对象
        spider=[spiders objectAtIndex:i];
        //如果蜘蛛没有动，则忽略
        if(spider.numberOfRunningActions==0){
            continue;
        }
        //计算玩家和蜘蛛的距离
        float actualDistance=ccpDistance(player.position, spider.position);
        if(actualDistance<maxCollisionDistance){
            //播放碰撞音效
            [[SimpleAudioEngine sharedEngine] playEffect:@"alien-sfx.caf"];
            //出现了碰撞，结束游戏
            [self resetGame];
            break;
        }
    }
}
-(void)resetGame
{
    //重置所有的蜘蛛
    [self resetSpiders];
    //分数归零
    score=0;
    //重置显示分数的标签
    [scoreLabel setString:@"0"];
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
    //碰撞检测
    [self checkForCollision];
    //调试：用总帧数来模拟分数
    score=[CCDirector sharedDirector].totalFrames;
    //显示分数
    [scoreLabel setString:[NSString stringWithFormat:@"%i",score]];
}
#if DEBUG
-(void)draw
{
    //==============================
    //为了调试碰撞检测，在蜘蛛和玩家上画一个圈
    //==============================
    [super draw];
    //遍历所有的精灵
    for (CCNode* node in [self children]) {
        //仅处理蜘蛛和玩家
        if([node isKindOfClass:[CCSprite class]] && (node.tag==1 || node.tag==2)){
            CCSprite* sprite=(CCSprite*)node;
            //获得画圆的参数
            float radius=sprite.texture.contentSize.width * 0.4f;
            float angle=0;
            int numSegments=10;
            bool drawLineToCenter=NO;
            //画一个圆
            ccDrawCircle(sprite.position, radius, angle, numSegments, drawLineToCenter);
        }
    }
}
#endif
@end
