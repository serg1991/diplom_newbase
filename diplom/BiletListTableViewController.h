//
//  BiletListTableViewController.h
//  diplom
//
//  Created by Sergey Kiselev on 29.01.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiletChildViewController.h"
#import "BiletViewController.h"

@interface BiletListTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *biletNumbers;
@property (nonatomic, strong) NSMutableArray *biletRecords;
@property (nonatomic) sqlite3 *pdd_ab_stat;

@end
