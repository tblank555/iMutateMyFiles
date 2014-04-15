//
//  TABFileMutator.m
//  File Mutator
//
//  Created by Travis Blankenship on 4/11/14.
//  Copyright (c) 2014 T Blank. All rights reserved.
//

#import "TABFileMutator.h"

NSString * const TABFileMutatorErrorDomain = @"TABFileMutatorErrorDomain";

NSURL *TABGenerateFile(NSURL *rootDirectory)
{
    // If you call this function a lot, you're gonna want to create an NSDateFormatter singleton. They're expensive to create.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterFullStyle;
    dateFormatter.timeStyle = NSDateFormatterLongStyle;
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSData *randomData = [dateString dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *fileURL = [rootDirectory URLByAppendingPathComponent:dateString];
    [randomData writeToURL:fileURL
                atomically:YES];
    return fileURL;
}

@implementation TABFileMutator

+ (NSString *)readFileAsUTF8String:(NSURL *)fileURL error:(NSError **)error
{
    NSString *fileContents;
    BOOL isDirectory;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[fileURL path] isDirectory:&isDirectory])
    {
        if (!isDirectory)
        {
            NSError *readError;
            fileContents = [NSString stringWithContentsOfURL:fileURL
                                                    encoding:NSUTF8StringEncoding
                                                       error:&readError];
            if (!fileContents)
            {
                if (error != NULL)
                {
                    *error = readError;
                }
                return nil;
            }
        }
        else
        {
            if (error != NULL)
            {
                *error = [NSError errorWithDomain:TABFileMutatorErrorDomain
                                             code:TABFileMutatorURLPointsToDirectoryError
                                         userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"The NSURL passed in points to a directory, not a file.", nil) }];
            }
            return nil;
        }
    }
    else
    {
        if (error != NULL)
        {
            *error = [NSError errorWithDomain:TABFileMutatorErrorDomain
                                         code:TABFileMutatorFileDoesNotExistError
                                     userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"The NSURL passed in points to a file that doesn't exist.", nil) }];
        }
        return nil;
    }
    
    return fileContents;
}

+ (BOOL)mutateFile:(NSURL *)fileURL mutationType:(TABFileMutatorMutationType)mutationType error:(NSError **)error
{
    // Read file into memory
    NSError *readError;
    NSString *fileContents = [[self class] readFileAsUTF8String:fileURL
                                                          error:&readError];
    if (!fileContents && error != NULL)
    {
        *error = readError;
        return NO;
    }
    
    if (mutationType == TABFileMutatorMutationTypeAppend)
    {
        // Generate a string of random numbers
        uint32_t randomNumber = arc4random_uniform(UINT32_MAX);
        NSString *randomNumberString = [@(randomNumber) stringValue];
        
        // Append that string to the end of the file contents
        fileContents = [fileContents stringByAppendingString:randomNumberString];
        
        // Write the file back to disk
        NSData *newFileData = [fileContents dataUsingEncoding:NSUTF8StringEncoding];
        [newFileData writeToURL:fileURL
                     atomically:YES];
        
        return YES;
    }
    else if (mutationType == TABFileMutatorMutationTypeDelete)
    {
        uint32_t beginDeletionIndex;
        uint32_t deletionLength;
        
        if (fileContents.length <= 1)
        {
            if (error != NULL)
            {
                *error = [NSError errorWithDomain:TABFileMutatorErrorDomain
                                             code:TABFileMutatorFileIsTooShort
                                         userInfo:@{ NSLocalizedDescriptionKey : NSLocalizedString(@"The NSURL passed in points to a file that is too short to delete characters from.", nil) }];
            }
            return NO;
        }
        
        // This do-while loop prevents the entire contents of the file from being deleted
        do
        {
            // Choose a random place in the file to begin deleting data from
            beginDeletionIndex = arc4random_uniform(fileContents.length);
            
            // Choose a random amount of data to begin deleting from the file
            deletionLength = arc4random_uniform([fileContents substringFromIndex:beginDeletionIndex].length);
        }
        while ((beginDeletionIndex == 0 && deletionLength >= fileContents.length) || deletionLength == 0);
        
        NSString *newFileContents = [NSString stringWithFormat:@"%@%@", [fileContents substringToIndex:beginDeletionIndex], [fileContents substringFromIndex:(beginDeletionIndex + deletionLength)]];
        
        // Write the new string back to disk
        NSData *newFileData = [newFileContents dataUsingEncoding:NSUTF8StringEncoding];
        [newFileData writeToURL:fileURL
                     atomically:YES];
        
        return YES;
    }
    
    return NO;
}

@end
