//
//  ScoreStore.m
//  MyDoodleDrop
//
//  Created by Developer on 3/23/14.
//
//

#import "ScoreStore.h"
#import "cocos2d.h"
#import "LevelScore.h"
#import "FileHelper.h"

#define kDataFile       @"data.plist"
#define kDataKey        @"Data"

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
        [self loadData];
    }
    return self;
}
-(void)addScoreAtLevel:(NSString*)levelId earnedScore:(int)earnedScore
{
    LevelScore *oldScore=[scores valueForKey:levelId];
    if(oldScore==nil){
        oldScore=[[LevelScore alloc] initWithLevelId:levelId Score:0 IsFinished:NO];
        [scores setValue:oldScore forKey:levelId];
    }
    [oldScore addScore:earnedScore];
    CCLOG(@"add score %d to level %@",earnedScore,levelId);
}
-(void)resetAtLevel:(NSString*)levelId
{
    LevelScore *oldScore=[scores valueForKey:levelId];
    if(oldScore!=nil){
        oldScore.score=0;
    }
}
-(void)resetAll
{
    //重建分数字典
    scores=[[NSMutableDictionary alloc] initWithCapacity:10];
}
-(int)getLevelScore:(NSString *)levelId
{
    int score=0;
    LevelScore *oldScore=[scores valueForKey:levelId];
    if(oldScore!=nil)
        score=[oldScore score];
    return score;
}
-(int)getTotalScore
{
    int totla=0;
    NSString* key;
    for (key in scores) {
        LevelScore* v=[scores valueForKey:key];
        totla+=[v score];
    }
    return totla;
}
-(BOOL)saveData
{
    NSString* docPath=[FileHelper getPrivateDocsDir];
    NSString *dataPath = [docPath stringByAppendingPathComponent:kDataFile];
    if([NSKeyedArchiver archiveRootObject:scores toFile:dataPath])
    {
        NSLog(@"write data to file %@",dataPath);
        return YES;
    }
    return NO;
}
-(void)loadData
{
    NSString* docPath=[FileHelper getPrivateDocsDir];
    NSString *dataPath = [docPath stringByAppendingPathComponent:kDataFile];
    
    scores=[NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
    if(scores==nil){
        NSLog(@"can not load data from file %@",dataPath);
        scores=[[NSMutableDictionary alloc] initWithCapacity:10];
        return;
    }
    NSLog(@"load data from file %@",dataPath);
    [self debugPrintScores];
}
-(void)debugPrintScores
{
    NSString* key;
    for (key in scores) {
        LevelScore* v=[scores valueForKey:key];
        NSLog(@"levelId=%@,score=%i,finished=%i",v.levelId,v.score,v.isFinished);
    }
}
@end
