//
//  LevelScore.h
//  SpidersDrop
//
//  Created by Developer on 4/1/14.
//
//

#import <Foundation/Foundation.h>
/**
 *  记录某个关卡的得分情况的类
 */
@interface LevelScore : NSObject <NSCoding>{
    /**
     *  内部变量：关卡ID
     */
    NSString* _levelId;
    /**
     *  内部变量：分数
     */
    int _score;
    /**
     *  内部变量：
     */
    BOOL _isFinished;
}
/**
 *  关卡ID
 */
@property NSString* levelId;
/**
 *  关卡当前得分
 */
@property int score;
/**
 *  关卡是否已经完成
 */
@property BOOL isFinished;
/**
 *  增加得分
 *
 *  @param score 分数值
 */
-(void)addScore:(int)score;
/**
 *  初始化函数
 *
 *  @param levelId    关卡ID
 *  @param score      关卡的得分
 *  @param isFinished 关卡是否已经完成
 *
 *  @return 关卡分数对象
 */
-(id)initWithLevelId:(NSString*)levelId Score:(int)score IsFinished:(BOOL)isFinished;
@end
