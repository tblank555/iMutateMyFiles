//
//  TABFileMutatorTests.m
//  File Mutator
//
//  Created by Travis Blankenship on 4/14/14.
//  Copyright (c) 2014 T Blank. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TABFileMutator.h"

@interface TABFileMutatorTests : XCTestCase

@end

@implementation TABFileMutatorTests

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

- (void)testGenerateFile
{
    NSURL *documentsDirectory = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
    NSURL *testFileURL = TABGenerateFile(documentsDirectory);
    
    // Verify the URLs exist
    XCTAssertNotNil(documentsDirectory, @"Internal test error. URL for Documents directory was not returned by iOS.");
    XCTAssertNotNil(testFileURL, @"TABGenerateFile() failed to provide a URL that points to the file.");
    
    NSString *testFilePath = [testFileURL path];
    BOOL isDirectory;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:testFilePath
                                                           isDirectory:&isDirectory];
    XCTAssertTrue(fileExists, @"TABGenerateFile() failed to create a file.");
    XCTAssertFalse(isDirectory, @"TABGenerateFile() generated a directory instead of a file.");
}

@end
