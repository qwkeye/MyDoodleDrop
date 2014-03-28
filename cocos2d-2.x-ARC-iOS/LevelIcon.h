//
//  LevelIcon.h
//  SpidersDrop
//
//  Created by rosen on 3/28/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LevelIcon : CCNode <CCTargetedTouchDelegate> {
    CCSprite* backgroundSprite;
    void (^touchHandler)(void);
}
-(id)initWithLevel:(int)level
            locked:(BOOL)locked
          position:(CGPoint)pos
      clickHandler:(void(^)(void))callback;
@end
