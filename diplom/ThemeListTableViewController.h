//
//  ThemeListTableViewController.h
//  diplom
//
//  Created by Sergey Kiselev on 29.01.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ThemeListTableViewController : UITableViewController
@property (nonatomic, retain) NSMutableArray *themeTheme;
@property (nonatomic, strong) NSMutableArray *themeQuestionNumber;
@property (nonatomic) sqlite3 *pdd;

@end
