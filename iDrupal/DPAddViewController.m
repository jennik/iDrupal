//
//  DPAddViewController.m
//  iDrupal
//
//  Created by Evgeny on 16.03.14.
//  Copyright (c) 2014 Drupal.org. All rights reserved.
//

#import "DPAddViewController.h"
#import "DIOSNode.h"
#import "DIOSFile.h"

@interface DPAddViewController ()

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)takePicture:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *bodyText;

@end

@implementation DPAddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleText.delegate = self;
    self.bodyText.delegate = self;
}

- (IBAction)save:(id)sender
{
    void (^nodeAdd)(AFHTTPRequestOperation *, id ) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *nodeData = [[NSMutableDictionary alloc] init];
        nodeData[@"title"] = self.titleText.text;
        nodeData[@"body"] = @{@"und": @[ @{@"value": self.bodyText.text} ]};
        nodeData[@"type"] = @"article";
        nodeData[@"und"] = @"language";
        if (responseObject != nil) {
            nodeData[@"field_image"] = @{@"und": @[responseObject]};
        }
        
        [DIOSNode nodeSave:nodeData success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            
        }];
            
    };
    
    if (self.imageView.image)
    {
        CFUUIDRef uniqueID = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef CFimageName = CFUUIDCreateString(kCFAllocatorDefault, uniqueID);
        NSString *imageName = [NSString stringWithFormat:@"%@.png", (__bridge_transfer NSString *)CFimageName];
        CFRelease(uniqueID);
        NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.9f);
        
        NSMutableDictionary *fileData = [[NSMutableDictionary alloc] init];
        fileData[@"filename"] = imageName;
        fileData[@"file"] = [imageData base64EncodedStringWithOptions:0];
        fileData[@"mimetype"] = @"image/png";
        
        [DIOSFile fileSave:fileData success:nodeAdd
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               NSLog(@"%@", error);
        }];
    }
    else
    {
        nodeAdd(nil, nil);
    }
    
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)takePicture:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
@end
