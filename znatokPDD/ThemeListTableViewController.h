//
//  ThemeListTableViewController.h
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 29.01.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeViewController.h"

@interface ThemeListTableViewController : UITableViewController
@property (nonatomic, retain) NSMutableArray *themeTheme;
@property (nonatomic, strong) NSMutableArray *themeQuestionNumber;
@property (nonatomic) sqlite3 *pdd;
@property (nonatomic) sqlite3 *pdd_ab_stat;

@end
