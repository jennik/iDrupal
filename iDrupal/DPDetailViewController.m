//
//  DPDetailViewController.m
//  iDrupal
//
//  Created by Evgeny on 16.03.14.
//  Copyright (c) 2014 Drupal.org. All rights reserved.
//

#import "DPDetailViewController.h"
#import "DIOSNode.h"
#import "DIOSFile.h"

@interface DPDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *nodeBody;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation DPDetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
}

- (void)loadData
{
    [DIOSNode nodeGet:@{@"nid": self.nid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"field_image"] count]) {
            [DIOSFile fileGet:@{@"fid": responseObject[@"field_image"][@"und"][0][@"fid"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSData *rawData = [[NSData alloc] initWithBase64EncodedString:responseObject[@"file"] options:0];
                self.image.image = [UIImage imageWithData:rawData];
                self.indicator.hidden = YES;
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@", error);
                
            }];
        }
        else
        {
            self.indicator.hidden = YES;
        }
        
        self.navigationItem.title = responseObject[@"title"];
        self.nodeBody.text = responseObject[@"body"][@"und"][0][@"value"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        
    }];
}

@end
