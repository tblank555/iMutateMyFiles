//
//  TABViewController.m
//  File Mutator
//
//  Created by T Blank on 4/11/14.
//  Copyright (c) 2014 T Blank. All rights reserved.
//

#import "TABViewController.h"

static NSURL *TABGenerateFile(NSURL *rootDirectory)
{
    NSMutableData *randomData = [[NSKeyedArchiver archivedDataWithRootObject:[NSDate date]] mutableCopy];
    int randomNumber = arc4random_uniform(UINT32_MAX);
    NSString *randomNumberString = [@(randomNumber) stringValue];
    [randomData appendData:[randomNumberString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURL *fileURL = [rootDirectory URLByAppendingPathComponent:randomNumberString];
    [randomData writeToURL:fileURL
                atomically:YES];
    return fileURL;
}

@interface TABViewController ()

@end

@implementation TABViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Generate a random file in the Documents directory
    NSString *pathToDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSURL *documentsDirectoryURL = [NSURL URLWithString:pathToDocumentsDirectory];
    NSURL *randomFileURL = TABGenerateFile(documentsDirectoryURL);
}

@end
