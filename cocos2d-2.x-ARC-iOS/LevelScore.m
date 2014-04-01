//
//  LevelScore.m
//  SpidersDrop
//
//  Created by Developer on 4/1/14.
//
//

#import "LevelScore.h"

@implementation LevelScore
@synthesize levelId=_levelId;
@synthesize score=_score;
@synthesize isFinished=_isFinished;

-(id)initWithLevelId:(NSString*)levelId Score:(int)score IsFinished:(BOOL)isFinished
{
    if(self=[super init]){
        _levelId=[levelId copy];
        _score=score;
        _isFinished=isFinished;
    }
    return self;
}

-(void)addScore:(int)score
{
    _score+=score;
}

#pragma mark NSCoding

#define kLevelIdKey          @"LevelId"
#define kScoreKey            @"Score"
#define kFinishedKey         @"Finished"

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_levelId forKey:kLevelIdKey];
    [aCoder encodeInt:_score forKey:kScoreKey];
    [aCoder encodeBool:_isFinished forKey:kFinishedKey];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    NSString* lid=[aDecoder decodeObjectForKey:kLevelIdKey];
    int score=[aDecoder decodeIntegerForKey:kScoreKey];
    BOOL finished=[aDecoder decodeBoolForKey:kFinishedKey];
    return [self initWithLevelId:lid Score:score IsFinished:finished];
}
@end
