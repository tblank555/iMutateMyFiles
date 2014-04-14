//
//  TABFileMutator.h
//  File Mutator
//
//  Created by Travis Blankenship on 4/11/14.
//  Copyright (c) 2014 T Blank. All rights reserved.
//

NSString * const TABFileMutatorErrorDomain;

NS_ENUM(NSUInteger, TABFileMutatorErrorType)
{
    TABFileMutatorURLPointsToDirectoryError = 1,
    TABFileMutatorFileDoesNotExistError
};

/**
 Generates a file with the current date and time as both its contents and name.
 @param rootDirectory The directory in which to create the file.
 @result An `NSURL` object that points to the newly created file.
 */
NSURL *TABGenerateFile(NSURL *rootDirectory);

@interface TABFileMutator : NSObject

/**
 Reads a file as a UTF-8 encoded string.
 @param fileURL An `NSURL` object that points to the file to be read.
 @param error A pointer to an `NSError` object that will contain an `NSError` in the event of an error.
 @result An `NSString` containing the contents of the file pointed to by `fileURL`.
 */
+ (NSString *)readFileAsUTF8String:(NSURL *)fileURL error:(NSError **)error;

/**
 Mutates a file by appending a random integer (uint32) to the end of the file.
 @param fileURL An `NSURL` object that points to the file to be mutated.
 @param error A pointer to an `NSError` object that will contain an `NSError` in the event of an error.
 @result A Boolean value indicating whether or not the mutation operation was successful. If this value is `NO`, `error` will point to an `NSError` object describing the error.
 */
+ (BOOL)mutateFile:(NSURL *)fileURL error:(NSError **)error;

@end
