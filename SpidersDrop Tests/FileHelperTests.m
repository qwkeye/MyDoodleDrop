//
//  FileHelperTests.m
//  SpidersDrop
//
//  Created by Developer on 4/2/14.
//
//

#import <XCTest/XCTest.h>
#import "FileHelper.h"

@interface FileHelperTests : XCTestCase

@end

@implementation FileHelperTests

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

- (void)testGetPrivateDocsDir
{
    NSString *dir=[FileHelper getPrivateDocsDir];
    XCTAssertNotNil(dir, @"private dir not nil");
}

@end
