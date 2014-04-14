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
    
    NSURL *_testFileURL;
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
    _testFileURL = TABGenerateFile(documentsDirectoryURL);
    
    // Display the file's contents in the text field
    NSError *error;
    _fileTextField.text = [TABFileMutator readFileAsUTF8String:_testFileURL
                                                         error:&error];
    if (error)
    {
        _fileTextField.text = error.localizedDescription;
    }
}

- (void)__mutateFile:(NSURL *)file mutationType:(TABFileMutatorMutationType)mutationType
{
    NSError *error;
    if ([TABFileMutator mutateFile:file
                      mutationType:mutationType
                             error:&error])
    {
        _fileTextField.text = [TABFileMutator readFileAsUTF8String:file
                                                             error:&error];
        
        if (error)
        {
            _fileTextField.text = error.localizedDescription;
        }
    }
    else
    {
        _fileTextField.text = error.localizedDescription;
    }
}

- (IBAction)append:(UIButton *)sender
{
    [self __mutateFile:_testFileURL
          mutationType:TABFileMutatorMutationTypeAppend];
}

- (IBAction)delete:(UIButton *)sender
{
    [self __mutateFile:_testFileURL
          mutationType:TABFileMutatorMutationTypeDelete];
}

@end
