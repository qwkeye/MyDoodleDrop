//
//  ScoreStore.h
//  MyDoodleDrop
//
//  Created by Developer on 3/23/14.
//
//

#import <Foundation/Foundation.h>

@interface ScoreStore : NSObject
{
    NSMutableDictionary* scores;
}
+(ScoreStore*)sharedStore;
/**
 *  增加分数
 *
 *  @param levelId     关卡ID
 *  @param earnedScore 新增的分数
 */
-(void)addScoreAtLevel:(NSString*)levelId earnedScore:(int)earnedScore;
/**
 *  重置分数为零
 *
 *  @param levelId 关卡ID
 */
-(void)resetAtLevel:(NSString*)levelId;
/**
 *  获得所有关卡的总分数
 *
 *  @return 总分数
 */
-(int)getTotalScore;
/**
 *  获得某个关卡的分数
 *
 *  @param levelId 关卡ID
 *
 *  @return 分数
 */
-(int)getLevelScore:(NSString*)levelId;
/**
 *  保存数据到文件中
 *
 *  @return 保存是否成功
 */
-(BOOL)saveData;
@end
