//
//  DPDetailViewController.h
//  iDrupal
//
//  Created by Evgeny on 16.03.14.
//  Copyright (c) 2014 Drupal.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
