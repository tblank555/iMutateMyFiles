//
//  TABFileMutator.h
//  File Mutator
//
//  Created by Travis Blankenship on 4/11/14.
//  Copyright (c) 2014 T Blank. All rights reserved.
//

/** The error domain for errors produced by TABFileMutator */
NSString * const TABFileMutatorErrorDomain;

/** An enumeration of the error codes that TABFileMutator can produce. */
typedef NS_ENUM(NSUInteger, TABFileMutatorErrorType)
{
    /** The URL passed in to the mutation method points to a directory, not a file. */
    TABFileMutatorURLPointsToDirectoryError = 1,
    /** The file you are attempting to mutate does not exist. */
    TABFileMutatorFileDoesNotExistError,
    /** The file you are attempting to delete data from is too short. */
    TABFileMutatorFileIsTooShort
};

/** An enumeration of the types of mutations that TABFileMutator can perform. */
typedef NS_ENUM(NSUInteger, TABFileMutatorMutationType)
{
    /** A constant representing the append mutation type, where random data is appended to the end of a file. */
    TABFileMutatorMutationTypeAppend,
    /** A constant representing the delete mutation type, where data is randomly deleted from a file. */
    TABFileMutatorMutationTypeDelete,
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
 @param mutationType A constant that determines the type of mutation to perform.
 @param error A pointer to an `NSError` object that will contain an `NSError` in the event of an error.
 @result A Boolean value indicating whether or not the mutation operation was successful. If this value is `NO`, `error` will point to an `NSError` object describing the error.
 @see `<TABFileMutatorMutationType>`
 */
+ (BOOL)mutateFile:(NSURL *)fileURL mutationType:(TABFileMutatorMutationType)mutationType error:(NSError **)error;

@end
