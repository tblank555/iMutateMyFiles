//
//  TABFileMutator.m
//  File Mutator
//
//  Created by Travis Blankenship on 4/11/14.
//  Copyright (c) 2014 T Blank. All rights reserved.
//

#import "TABFileMutator.h"

@implementation TABFileMutator

static NSURL *TABGenerateFile(NSURL *rootDirectory)
{
    // If you call this function a lot, you're gonna want to create an NSDateFormatter singleton. They're expensive to create.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterFullStyle;
    dateFormatter.timeStyle = NSDateFormatterLongStyle;
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSData *randomData = [dateString dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *fileURL = [rootDirectory URLByAppendingPathComponent:dateString];
    [randomData writeToURL:fileURL
                   options:NSDataWritingFileProtectionNone
                     error:nil];
    return fileURL;
}

@end
