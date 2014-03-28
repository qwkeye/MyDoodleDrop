//
//  ScoreStore.m
//  MyDoodleDrop
//
//  Created by Developer on 3/23/14.
//
//

#import "ScoreStore.h"
#import "cocos2d.h"
@implementation ScoreStore

+(ScoreStore*)sharedStore
{
    static ScoreStore* scoreStore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scoreStore=[[ScoreStore alloc] init];
    });
    return scoreStore;
}
- (id)init
{
    self = [super init];
    if (self) {
        scores=[NSMutableDictionary dictionaryWithCapacity:10];
    }
    return self;
}
-(void)addScoreAtLevel:(NSString*)levelId earnedScore:(int)earnedScore
{
    NSNumber *oldScore=[scores valueForKey:levelId];
    if(oldScore==nil)
        oldScore=[NSNumber numberWithInt:0];
    NSNumber* newScore=[NSNumber numberWithInt:earnedScore+[oldScore intValue]];
    [scores setValue:newScore forKey:levelId];
    CCLOG(@"add score %d to level %@",earnedScore,levelId);
}
-(void)resetAtLevel:(NSString*)levelId
{
    NSNumber* newScore=[NSNumber numberWithInt:0];
    [scores setValue:newScore forKey:levelId];
}
-(int)getLevelScore:(NSString *)levelId
{
    int score=0;
    NSNumber *scoreValue=[scores valueForKey:levelId];
    if(scoreValue==nil)
        score=[scoreValue intValue];
    return score;
}
-(int)getTotalScore
{
    int totla=0;
    NSString* key;
    for (key in scores) {
        NSNumber* v=[scores valueForKey:key];
        totla+=[v intValue];
    }
    return totla;
}
@end
