//
//  ScoreStoreTests.m
//  SpidersDrop
//
//  Created by Developer on 4/2/14.
//
//

#import <XCTest/XCTest.h>
#import "ScoreStore.h"

@interface ScoreStoreTests : XCTestCase
{
    
}
@end

@implementation ScoreStoreTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddScore
{
    NSString *levelId=@"ABC";
    //分数初始化
    [[ScoreStore sharedStore] resetAtLevel:levelId];
    XCTAssertEqual([[ScoreStore sharedStore] getLevelScore:levelId], 0);
    //加10分
    [[ScoreStore sharedStore] addScoreAtLevel:levelId earnedScore:10];
    XCTAssertEqual([[ScoreStore sharedStore] getLevelScore:levelId], 10);
    //加5分
    [[ScoreStore sharedStore] addScoreAtLevel:levelId earnedScore:5];
    XCTAssertEqual([[ScoreStore sharedStore] getLevelScore:levelId], 15);
    //分数初始化
    [[ScoreStore sharedStore] resetAtLevel:levelId];
    XCTAssertEqual([[ScoreStore sharedStore] getLevelScore:levelId], 0);
}
-(void)testGetTotalScore
{
    NSString *levelIdA=@"A";
    NSString *levelIdB=@"B";
    
    //分数初始化
    [[ScoreStore sharedStore] resetAll];
    XCTAssertEqual([[ScoreStore sharedStore] getLevelScore:levelIdA], 0);
    XCTAssertEqual([[ScoreStore sharedStore] getLevelScore:levelIdB], 0);
    //增加分数
    [[ScoreStore sharedStore] addScoreAtLevel:levelIdA earnedScore:10];
    [[ScoreStore sharedStore] addScoreAtLevel:levelIdB earnedScore:5];
    XCTAssertEqual([[ScoreStore sharedStore] getTotalScore], 15);
}
@end
