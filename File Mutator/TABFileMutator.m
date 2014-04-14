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
            if (readError)
            {
                *error = readError;
                return nil;
            }
        }
        else
        {
            *error = [NSError errorWithDomain:TABFileMutatorErrorDomain
                                         code:TABFileMutatorURLPointsToDirectoryError
                                     userInfo:@{ NSLocalizedDescriptionKey : @"The NSURL passed in points to a directory, not a file." }];
            return nil;
        }
    }
    else
    {
        *error = [NSError errorWithDomain:TABFileMutatorErrorDomain
                                     code:TABFileMutatorFileDoesNotExistError
                                 userInfo:@{ NSLocalizedDescriptionKey : @"The NSURL passed in points to a file that doesn't exist." }];
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
    if (readError)
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
    
    return NO;
}

@end
