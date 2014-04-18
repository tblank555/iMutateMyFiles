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
    
    [[NSFileManager defaultManager] removeItemAtURL:testFileURL
                                              error:nil];
}

- (void)testReadFileAsUTF8String
{
    // Generate a test file with TABGenerateFile()
    NSURL *documentsDirectory = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
    NSURL *testFileURL = TABGenerateFile(documentsDirectory);
    
    NSError *error;
    NSString *testFileContents = [TABFileMutator readFileAsUTF8String:testFileURL
                                                                error:&error];
    
    XCTAssertNotNil(testFileContents, @"+ [TABFileMutator readFileAsUTF8String:error:] returned a nil string.");
    XCTAssertNil(error, @"+ [TABFileMutator readFileAsUTF8String:error:] produced an error: %@", error.localizedDescription);
    XCTAssertTrue(testFileContents.length > 0, @"+ [TABFileMutator readFileAsUTF8String:error:] returned an empty string.");
    
    [[NSFileManager defaultManager] removeItemAtURL:testFileURL
                                              error:nil];
}

- (void)testMutateFileAppend
{
    // Generate a test file with TABGenerateFile()
    NSURL *documentsDirectory = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
    NSURL *testFileURL = TABGenerateFile(documentsDirectory);
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[testFileURL path]
                                                                                    error:nil];
    
    XCTAssertNotNil(fileAttributes, @"NSFileManager failed to get the attributes of the test file before mutation.");
    
    uint64_t fileSizeBefore = [fileAttributes fileSize];
    
    XCTAssertTrue(fileSizeBefore > 0, @"Test file has 0 byte file size before mutation.");
    
    // Mutate the file
    NSError *error;
    BOOL success = [TABFileMutator mutateFile:testFileURL
                                 mutationType:TABFileMutatorMutationTypeAppend
                                        error:&error];
    
    XCTAssertTrue(success, @"+ [TABFileMutator mutateFile:error:] failed to mutate the test file.");
    XCTAssertNil(error, @"+ [TABFileMutator mutateFile:error:] produced an error: %@", error.localizedDescription);
    
    fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[testFileURL path]
                                                                      error:nil];
    
    XCTAssertNotNil(fileAttributes, @"NSFileManager failed to get the attributes of the test file after mutation.");
    
    uint64_t fileSizeAfter = [fileAttributes fileSize];
    
    XCTAssertTrue(fileSizeAfter > 0, @"Test file has 0 byte file size after mutation.");
    
    [[NSFileManager defaultManager] removeItemAtURL:testFileURL
                                              error:nil];
}

- (void)testMutateFileDelete
{
    // Generate a test file with TABGenerateFile()
    NSURL *documentsDirectory = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
    NSURL *testFileURL = TABGenerateFile(documentsDirectory);
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[testFileURL path]
                                                                                    error:nil];
    
    XCTAssertNotNil(fileAttributes, @"NSFileManager failed to get the attributes of the test file before mutation.");
    
    uint64_t fileSizeBefore = [fileAttributes fileSize];
    
    XCTAssertTrue(fileSizeBefore > 0, @"Test file has 0 byte file size before mutation.");
    
    // Mutate the file
    NSError *error;
    BOOL success = [TABFileMutator mutateFile:testFileURL
                                 mutationType:TABFileMutatorMutationTypeDelete
                                        error:&error];
    
    XCTAssertTrue(success, @"+ [TABFileMutator mutateFile:error:] failed to mutate the test file.");
    XCTAssertNil(error, @"+ [TABFileMutator mutateFile:error:] produced an error: %@", error.localizedDescription);
    
    fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[testFileURL path]
                                                                      error:nil];
    
    XCTAssertNotNil(fileAttributes, @"NSFileManager failed to get the attributes of the test file after mutation.");
    
    uint64_t fileSizeAfter = [fileAttributes fileSize];
    
    XCTAssertTrue(fileSizeAfter > 0, @"Test file has 0 byte file size after mutation.");
    
    // Attempt to delete characters from a single-character file
    NSString *characterToWrite = @"•";
    NSURL *testFile2URL = [documentsDirectory URLByAppendingPathComponent:@"testFile2"];
    NSData *dataToWrite = [characterToWrite dataUsingEncoding:NSUTF8StringEncoding];
    [dataToWrite writeToURL:testFile2URL
                 atomically:YES];
    
    success = [TABFileMutator mutateFile:testFile2URL
                            mutationType:TABFileMutatorMutationTypeDelete
                                   error:&error];
    
    XCTAssertFalse(success, @"+ [TABFileMutator mutateFile:error:] managed to delete characters from a single-character file.");
    XCTAssertNotNil(error, @"+ [TABFileMutator mutateFile:error:] failed to produce an error deleting characters from a single-character file.");
    XCTAssertTrue(error.code == TABFileMutatorFileIsTooShort, @"+ [TABFileMutator mutateFile:error:] produced the wrong type of error deleting characters from a single-character file.");
    
    [[NSFileManager defaultManager] removeItemAtURL:testFileURL
                                              error:nil];
    [[NSFileManager defaultManager] removeItemAtURL:testFile2URL
                                              error:nil];
}

@end
