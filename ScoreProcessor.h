//
//  ScoreProcessor.h
//  MyDoodleDrop
//
//  Created by rosen on 3/23/14.
//
//

#import <Foundation/Foundation.h>

@protocol ScoreProcessor <NSObject>
/**
 *  获得分数
 *
 *  @param level 关卡
 *  @param score 分数
 */
-(void)addScoreInLevel:(int)level earnedScore:(int)earnedScore;
@end
