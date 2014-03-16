//
//  DPMasterViewController.m
//  iDrupal
//
//  Created by Evgeny on 16.03.14.
//  Copyright (c) 2014 Drupal.org. All rights reserved.
//

#import "DPMasterViewController.h"
#import "DPDetailViewController.h"
#import "DIOSNode.h"
#import "DIOSFile.h"

@interface DPMasterViewController ()

@property NSMutableArray *allNodes;

- (IBAction)edit:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end

@implementation DPMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}

- (void) loadData
{
    [DIOSNode nodeIndex:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        self.allNodes = (NSMutableArray *)responseObject;
        self.allNodes = [NSMutableArray arrayWithArray:responseObject];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        
    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allNodes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = self.allNodes[indexPath.row][@"title"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *nid = self.allNodes[indexPath.row][@"nid"];
        [segue.destinationViewController setNid:nid];
    }
    else if ([[segue identifier] isEqualToString:@"addNode"])
    {
    }
}

- (IBAction)edit:(id)sender
{
    if (self.isEditing) {
        [self setEditing:NO animated:YES];
    }
    else
    {
        [self setEditing:YES animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [DIOSNode nodeDelete:@{@"nid": self.allNodes[indexPath.row][@"nid"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
            [self.allNodes removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            
        }];
    }
}
@end
