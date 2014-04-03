//
//  LevelScoreTests.m
//  SpidersDrop
//
//  Created by Developer on 4/2/14.
//
//

#import <XCTest/XCTest.h>
#import "LevelScore.h"
@interface LevelScoreTests : XCTestCase
{
    LevelScore *_levelScore;
}
@end

@implementation LevelScoreTests

- (void)setUp
{
    [super setUp];
    _levelScore=[[LevelScore alloc] initWithLevelId:@"ABC" Score:10 IsFinished:NO];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddScore
{
    [_levelScore addScore:20];
    XCTAssertEqual(_levelScore.score, 30, @"add 20 points");
}
/**
 *  测试初始化：空的levelid
 */
-(void)testInitWithNilLevelId
{
    LevelScore *data=nil;
    XCTAssertThrows(data=[[LevelScore alloc] initWithLevelId:nil Score:0 IsFinished:YES], @"can not init with nil levelId");
}
/**
 *  测试初始化：leveiId为空字符串，或者只有空格的字符串
 */
-(void)testInitWithEmptyLevelId
{
    LevelScore *data=nil;
    XCTAssertThrows(data=[[LevelScore alloc] initWithLevelId:@"" Score:0 IsFinished:YES], @"can not init with nil levelId");
    XCTAssertThrows(data=[[LevelScore alloc] initWithLevelId:@"   " Score:0 IsFinished:YES], @"can not init with nil levelId");
}
/**
 *  测试初始化：levelId含有前置和后置的空格时，初始化后会删除前置和后置空格
 */
-(void)testInitWithLevelIdHasWhiteSpace
{
    LevelScore *data=[[LevelScore alloc] initWithLevelId:@"  abc  " Score:0 IsFinished:YES];
    XCTAssertTrue([[data levelId] isEqualToString:@"abc"],"trim white space");
}

@end
