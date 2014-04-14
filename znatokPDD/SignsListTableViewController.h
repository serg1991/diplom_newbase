//
//  SignsListTableViewController.h
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 13.04.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignsDetailViewController.h"

@interface SignsListTableViewController : UITableViewController

@property (nonatomic, retain) NSArray *signNames;
@property (nonatomic, retain) NSArray *signDetail;

@end
