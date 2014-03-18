//
//  Player.m
//  MyDoodleDrop
//
//  Created by rosen on 3/18/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

@implementation Player
-(void)setPosition:(CGPoint)position
{
    playerSprite.position=position;
}
+(CGSize)getSize
{
    //创建一个临时精灵
    CCSprite* temp=[CCSprite spriteWithFile:@"alien.png"];
    return temp.texture.contentSize;
}
+(id) playerWithParentNode:(CCNode*)parentNode position:(CGPoint)pos
{
	return [[self alloc] initWithParentNode:parentNode position:pos];
}
-(id) initWithParentNode:(CCNode*)parentNode position:(CGPoint)pos
{
	if ((self = [super init]))
	{
        CCLOG(@"%@: %@",NSStringFromSelector(_cmd),self);
		// 将自己添加到父节点
		[parentNode addChild:self];
		playerSprite = [CCSprite spriteWithFile:@"alien.png"];
		playerSprite.position = pos;
        //记录原始位置
        spriteOriginalPos=pos;
        //添加一个精灵对象
		[self addChild:playerSprite];
	}
	return self;
}
- (void)dealloc
{
    CCLOG(@"%@: %@",NSStringFromSelector(_cmd),self);
}
-(void)stop
{
    [playerSprite stopAllActions];
    isMoving=NO;
}
-(void)reset
{
    [playerSprite stopAllActions];
    playerSprite.position=spriteOriginalPos;
}
-(CGPoint)getSpritePosition
{
    return playerSprite.position;
}
-(float)getCollisionRadius
{
    //获得精灵图像的宽度
    float spiderImageSize=playerSprite.texture.contentSize.width;
    //设定碰撞半径
    return spiderImageSize*0.4f;
}
-(BOOL)getIsMoving{
    return isMoving;
}
@end