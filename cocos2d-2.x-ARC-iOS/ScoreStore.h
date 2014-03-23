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
    
}
+(ScoreStore*)sharedStore;
-(void)addScoreAtLevel:(int)level earnedScore:(int)earnedScore;
-(void)resetAtLevel:(int)level;
@property (readonly) int score;
@end
