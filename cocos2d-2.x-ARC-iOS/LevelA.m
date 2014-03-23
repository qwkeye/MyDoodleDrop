//
//  LevelA.m
//  MyDoodleDrop
//
//  Created by rosen on 3/12/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "LevelA.h"
#import "SimpleAudioEngine.h"
#import "Spider.h"
#import "ScoreStore.h"

@implementation LevelA
@synthesize isGameOver;
+(id)scene
{
    CCScene *scene=[CCScene node];
    CCLayer *layer=[LevelA node];
    [scene addChild:layer];
    return scene;
}
- (id)init
{
    self = [super init];
    if (self) {
        CCLOG(@"%@: %@",NSStringFromSelector(_cmd),self);
        //计算玩家对象的位置：将玩家对象摆放在屏幕底部中间位置
        CGSize screenSize=[CCDirector sharedDirector].winSize;
        float imageHeight=[Player getSize].height;
        CGPoint playerPos=CGPointMake(screenSize.width/2, imageHeight/2);
        //创建玩家对象
        player=[Player playerWithParentNode:self position:playerPos];
        //计算玩家能够活动的范围
        float imageWidthHalved=[Player getSize].width *0.5f;
        playerMoveLeftBorderLimit=imageWidthHalved;
        playerMoveRightBorderLimit=screenSize.width-imageWidthHalved;
        //播放背景音乐
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"blues.mp3" loop:YES];
        //预加载声音，以避免初始使用声音时出现一点延迟
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"alien-sfx.caf"];
        [self resetGame];
    }
    return self;
}
- (void)dealloc
{
    CCLOG(@"%@: %@",NSStringFromSelector(_cmd),self);
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}
/**
 *  初始化所有的蜘蛛
 */
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
        CGPoint pos=CGPointMake(imageWidth*i + imageWidth*0.5f, screenSize.height+imageWidth);
        //创建蜘蛛对象
        Spider *spider=[Spider spiderWithParentNode:self position:pos];
        [spiders addObject:spider];
    }
    //重新摆放蜘蛛位置
    [self resetSpiders];
}
/**
 *  重置所有蜘蛛
 */
-(void)resetSpiders
{
    //获得蜘蛛的数量
    int numSpiders=[spiders count];
    //重设每个蜘蛛的位置
    for (int i=0; i<numSpiders; i++) {
        Spider *spider=[spiders objectAtIndex:i];
        [spider reset];
    }
    //定时更新蜘蛛
    [self schedule:@selector(spidersUpdate:) interval:0.7f];
    //初始化：移动的蜘蛛数量
    numSpidersMoved=0;
    //初始化：蜘蛛从顶端掉到底端的时间
    spiderMoveDuration=5.0f;
}
-(void)spidersUpdate:(ccTime)delta
{
    //==============================
    //实现让蜘蛛频繁地落下
    //==============================
    for (int i=0; i<10; i++) {
        //随机挑选一个蜘蛛
        int randomSpiderIndex=CCRANDOM_0_1()*spiders.count;
        Spider *spider=[spiders objectAtIndex:randomSpiderIndex];
        if(spider.getIsMoving==NO){
            //如果这只蜘蛛还没有动过，则让它动起来
            [spider startDrop:spiderMoveDuration];
            //一次只触动一只蜘蛛
            break;
        }
    }
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
/**
 *  检测玩家和蜘蛛是否碰撞，假设玩家和蜘蛛的图像都是正方形
 */
-(void)checkForCollision
{
    Spider* spider=[spiders lastObject];
    //计算碰撞距离
    float maxCollisionDistance=player.getCollisionRadius+spider.getCollisionRadius;
    //循环检测蜘蛛
    int numSpiders=spiders.count;
    for (int i=0; i<numSpiders; i++) {
        //获得蜘蛛对象
        spider=[spiders objectAtIndex:i];
        //如果蜘蛛没有动，则忽略
        if(spider.getIsMoving==NO){
            continue;
        }
        //计算玩家和蜘蛛的距离
        float actualDistance=ccpDistance(player.getSpritePosition, spider.getSpritePosition);
        if(actualDistance<maxCollisionDistance){
            //播放碰撞音效
            [[SimpleAudioEngine sharedEngine] playEffect:@"alien-sfx.caf"];
            //出现了碰撞，结束游戏
            [self showGameOver];
            break;
        }
    }
}
/**
 *  重新开始游戏
 */
-(void)resetGame
{
	//禁止屏保
    [self setScreenSaverEnabled:NO];
    //删除标签：GameOver和touch to continue
	[self removeChildByTag:100 cleanup:YES];
	[self removeChildByTag:101 cleanup:YES];
    //删除所有的蜘蛛
    if(spiders!=nil){
        for (Spider* s in spiders) {
            [self removeChild:s cleanup:YES];
        }
    }
    spiders=nil;
    //初始化蜘蛛
    [self initSpiders];
	//重新打开加速器
	self.isAccelerometerEnabled = YES;
	//允许触摸
    self.isTouchEnabled = NO;
	//开始每帧更新
	[self scheduleUpdate];
	//重置分数
	isGameOver=NO;
}

-(void)update:(ccTime)delta
{
    //每帧都调用此方法
    //获得玩家的位置
    CGPoint pos=player.getSpritePosition;
    //根据计算的速度更新玩家位置
    pos.x += playerVelocity.x;
    //防止玩家跑到屏幕外面
    if(pos.x<playerMoveLeftBorderLimit){
        pos.x=playerMoveLeftBorderLimit;
        //已经贴近屏幕边缘，则不再加速了
        playerVelocity=CGPointZero;
    }else if(pos.x>playerMoveRightBorderLimit){
        pos.x=playerMoveRightBorderLimit;
        //已经贴近屏幕边缘，则不再加速了
        playerVelocity=CGPointZero;
    }
    [player setSpritePosition:pos];
    //碰撞检测
    [self checkForCollision];
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
#pragma mark Reset Game
/**
 *  he game is played only using the accelerometer. The screen may go dark while playing because the player won't touch the screen. This method allows the screensaver to be disabled during gameplay.
 *
 *  @param enabled 是否允许屏保
 */
-(void) setScreenSaverEnabled:(bool)enabled
{
	UIApplication *thisApp = [UIApplication sharedApplication];
	thisApp.idleTimerDisabled = !enabled;
}
/**
 *  显示游戏结束
 */
-(void) showGameOver
{
    //设置标志
    isGameOver=YES;
    //重新允许屏保，以免电池耗尽
	[self setScreenSaverEnabled:YES];
	//玩家停止运动
    [player stop];
    //蜘蛛停止运动
	for (Spider* spider in spiders){
        [spider stop];
	}
	//禁止加速计
	self.isAccelerometerEnabled = NO;
    //允许触摸屏幕
	self.isTouchEnabled = YES;
    //停止所有更新
	[self unscheduleAllSelectors];
    //显示标签：游戏结束
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	CCLabelTTF* gameOver = [CCLabelTTF labelWithString:@"GAME OVER!" fontName:@"Marker Felt" fontSize:60];
	gameOver.position = CGPointMake(screenSize.width / 2, screenSize.height / 3);
	[self addChild:gameOver z:100 tag:100];
	
	// game over label runs 3 different actions at the same time to create the combined effect
	// 1) color tinting
	CCTintTo* tint1 = [CCTintTo actionWithDuration:2 red:255 green:0 blue:0];
	CCTintTo* tint2 = [CCTintTo actionWithDuration:2 red:255 green:255 blue:0];
	CCTintTo* tint3 = [CCTintTo actionWithDuration:2 red:0 green:255 blue:0];
	CCTintTo* tint4 = [CCTintTo actionWithDuration:2 red:0 green:255 blue:255];
	CCTintTo* tint5 = [CCTintTo actionWithDuration:2 red:0 green:0 blue:255];
	CCTintTo* tint6 = [CCTintTo actionWithDuration:2 red:255 green:0 blue:255];
	CCSequence* tintSequence = [CCSequence actions:tint1, tint2, tint3, tint4, tint5, tint6, nil];
	CCRepeatForever* repeatTint = [CCRepeatForever actionWithAction:tintSequence];
	[gameOver runAction:repeatTint];
	
	// 2) rotation with ease
	CCRotateTo* rotate1 = [CCRotateTo actionWithDuration:2 angle:3];
	CCEaseBounceInOut* bounce1 = [CCEaseBounceInOut actionWithAction:rotate1];
	CCRotateTo* rotate2 = [CCRotateTo actionWithDuration:2 angle:-3];
	CCEaseBounceInOut* bounce2 = [CCEaseBounceInOut actionWithAction:rotate2];
	CCSequence* rotateSequence = [CCSequence actions:bounce1, bounce2, nil];
	CCRepeatForever* repeatBounce = [CCRepeatForever actionWithAction:rotateSequence];
	[gameOver runAction:repeatBounce];
	
	// 3) jumping
	CCJumpBy* jump = [CCJumpBy actionWithDuration:3 position:CGPointZero height:screenSize.height / 3 jumps:1];
	CCRepeatForever* repeatJump = [CCRepeatForever actionWithAction:jump];
	[gameOver runAction:repeatJump];
	//显示标签：点击继续
	// touch to continue label
	CCLabelTTF* touch = [CCLabelTTF labelWithString:@"tap screen to play again" fontName:@"Arial" fontSize:20];
	touch.position = CGPointMake(screenSize.width / 2, screenSize.height / 4);
	[self addChild:touch z:100 tag:101];
	
	// did you try turning it off and on again?
	CCBlink* blink = [CCBlink actionWithDuration:10 blinks:20];
	CCRepeatForever* repeatBlink = [CCRepeatForever actionWithAction:blink];
	[touch runAction:repeatBlink];
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self resetGame];
}
-(void)pauseGame
{
    [self pauseSchedulerAndActions];
    for (Spider* spider in spiders) {
        [spider pauseGame];
    }
    [player pauseGame];
}
-(void)resumeGame
{
    for (Spider* spider in spiders) {
        [spider resumeGame];
    }
    [player resumeGame];
    [self resumeSchedulerAndActions];
}
@end
