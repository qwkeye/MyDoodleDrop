//
//  LevelA.m
//  MyDoodleDrop
//
//  Created by rosen on 3/12/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "LevelA.h"
#import "SimpleAudioEngine.h"

@implementation LevelA
@synthesize score;
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
        //播放背景音乐
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"blues.mp3" loop:YES];
        //预加载声音，以避免初始使用声音时出现一点延迟
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"alien-sfx.caf"];
    }
    return self;
}
- (void)dealloc
{
    CCLOG(@"%@: %@",NSStringFromSelector(_cmd),self);
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
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

-(void) runSpiderWiggleSequence:(CCSprite*)spider
{
	// Do something icky with the spiders ...
	CCScaleTo* scaleUp = [CCScaleTo actionWithDuration:CCRANDOM_0_1() * 2 + 1 scale:1.05f];
	CCEaseBackInOut* easeUp = [CCEaseBackInOut actionWithAction:scaleUp];
	CCScaleTo* scaleDown = [CCScaleTo actionWithDuration:CCRANDOM_0_1() * 2 + 1 scale:0.95f];
	CCEaseBackInOut* easeDown = [CCEaseBackInOut actionWithAction:scaleDown];
	CCSequence* scaleSequence = [CCSequence actions:easeUp, easeDown, nil];
	CCRepeatForever* repeatScale = [CCRepeatForever actionWithAction:scaleSequence];
	[spider runAction:repeatScale];
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
            [self showGameOver];
            break;
        }
    }
}
-(void)resetGame
{
    // prevent screensaver from darkening the screen while the game is played
	[self setScreenSaverEnabled:NO];
	// remove game over label & touch to continue label
	[self removeChildByTag:100 cleanup:YES];
	[self removeChildByTag:101 cleanup:YES];
	// re-enable accelerometer
	self.isAccelerometerEnabled = YES;
	self.isTouchEnabled = NO;
	// put all spiders back to top
	[self resetSpiders];
	// re-schedule update
	[self scheduleUpdate];
	// reset score
	score = 0;
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
// The game is played only using the accelerometer. The screen may go dark while playing because the player
// won't touch the screen. This method allows the screensaver to be disabled during gameplay.
-(void) setScreenSaverEnabled:(bool)enabled
{
	UIApplication *thisApp = [UIApplication sharedApplication];
	thisApp.idleTimerDisabled = !enabled;
}

-(void) showGameOver
{
	// Re-enable screensaver, to prevent battery drain in case the user puts the device aside without turning it off.
	[self setScreenSaverEnabled:YES];
	
	// have everything stop
	for (CCNode* node in self.children)
	{
		[node stopAllActions];
	}
	
	// I do want the spiders to keep wiggling so I simply restart this here
	for (CCSprite* spider in spiders)
	{
		[self runSpiderWiggleSequence:spider];
	}
	
	// disable accelerometer input for the time being
	self.isAccelerometerEnabled = NO;
	// but allow touch input now
	self.isTouchEnabled = YES;
	
	// stop the scheduled selectors
	[self unscheduleAllSelectors];
	
	// add the labels shown during game over
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

@end
