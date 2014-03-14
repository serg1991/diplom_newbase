//
//  BiletListTableViewController.h
//  diplom
//
//  Created by Sergey Kiselev on 29.01.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPChildViewController.h"
#import "APPViewController.h"

@interface BiletListTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *biletNumbers;
@property (nonatomic, strong) NSArray *biletRecords;
@end
