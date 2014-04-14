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

- (void)testReadFileAsUTF8String
{
    // Generate a test file with TABGenerateFile()
    NSURL *documentsDirectory = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
    NSURL *testFileURL = TABGenerateFile(documentsDirectory);
    
    NSError *error;
    NSString *testFileContents = [TABFileMutator readFileAsUTF8String:testFileURL
                                                                error:&error];
    
    XCTAssertNotNil(testFileContents, @"+ [TABFileMutator readFileAsUTF8String] returned a nil string.");
    XCTAssertNil(error, @"+ [TABFileMutator readFileAsUTF8String] produced an error: %@", error.localizedDescription);
    XCTAssertTrue(testFileContents.length > 0, @"+ [TABFileMutator readFileAsUTF8String] returned an empty string.");
}

@end
