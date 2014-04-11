//
//  TABFileMutator.h
//  File Mutator
//
//  Created by Travis Blankenship on 4/11/14.
//  Copyright (c) 2014 T Blank. All rights reserved.
//

/**
 Generates a file with the current date and time as both its contents and name.
 @param rootDirectory The directory in which to create the file.
 @result An `NSURL` object that points to the newly created file.
 */
static NSURL *TABGenerateFile(NSURL *rootDirectory);

@interface TABFileMutator : NSObject

@end
