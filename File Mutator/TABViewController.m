//
//  TABViewController.m
//  File Mutator
//
//  Created by Travis Blankenship on 4/11/14.
//  Copyright (c) 2014 T Blank. All rights reserved.
//

#import "TABViewController.h"

#import "TABFileMutator.h"

@interface TABViewController ()
{
@private
    
    __weak IBOutlet UITextView *_fileTextField;
}

@end

@implementation TABViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Generate a random file in the Documents directory
    NSString *pathToDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:pathToDocumentsDirectory];
    NSURL *testFile = TABGenerateFile(documentsDirectoryURL);
    
    // Display the file's contents in the text field
    BOOL isDirectory;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[testFile path] isDirectory:&isDirectory])
    {
        NSError *error;
        NSString *fileContents = [NSString stringWithContentsOfURL:testFile
                                                          encoding:NSUTF8StringEncoding
                                                             error:&error];
        _fileTextField.text = fileContents;
    }
}

- (IBAction)mutate:(UIButton *)sender
{
    
}

@end
