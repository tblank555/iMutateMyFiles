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

+ (NSString *)readFileAsUTF8String:(NSURL *)fileURL error:(NSError **)error;
+ (BOOL)mutateFile:(NSURL *)fileURL error:(NSError **)error;

@end
