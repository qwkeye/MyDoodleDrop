//
//  AboutScreen.m
//  SpidersDrop
//
//  Created by rosen on 4/6/14.
//
//

#import "AboutScreen.h"
#import "MainScreen.h"

@implementation AboutScreen
- (id)init
{
    self = [super init];
    if (self) {
        CCLOG(@"%@: %@",NSStringFromSelector(_cmd),self);
        //创建并显示一个Label
        CGSize screenSize=[[CCDirector sharedDirector] winSize];
        CCLabelTTF *aboutLabel=[CCLabelTTF labelWithString:@"About this game"
                                             fontName:@"Marker Felt"
                                             fontSize:36];
        aboutLabel.position=CGPointMake(screenSize.width/2, screenSize.height/2);
        [self addChild:aboutLabel];
        //允许触摸屏幕
        self.isTouchEnabled = YES;
    }
    return self;
}
+(id)scene
{
    CCScene *scene=[CCScene node];
    CCLayer *layer=[AboutScreen node];
    [scene addChild:layer];
    return scene;
}
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //触摸屏幕后退出
	[[CCDirector sharedDirector] replaceScene:[MainScreen scene]];
}
- (void)dealloc
{
    CCLOG(@"%@: %@",NSStringFromSelector(_cmd),self);
}
@end
