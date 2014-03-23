//
//  ScoreStore.m
//  MyDoodleDrop
//
//  Created by Developer on 3/23/14.
//
//

#import "ScoreStore.h"

@implementation ScoreStore
@synthesize score;
+(ScoreStore*)sharedStore
{
    static ScoreStore* scoreStore=nil;
    if(!scoreStore){
        scoreStore=[[ScoreStore alloc] init];
    }
    return scoreStore;
}
-(void)addScoreAtLevel:(int)level earnedScore:(int)earnedScore
{
    score+=earnedScore;
}
-(void)resetAtLevel:(int)level
{
    score=0;
}
@end
