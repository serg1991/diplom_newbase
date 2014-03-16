//
//  ThemeListTableViewController.m
//  diplom
//
//  Created by Sergey Kiselev on 29.01.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "ThemeListTableViewController.h"

@interface ThemeListTableViewController ()

@end

@implementation ThemeListTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"pdd.sqlite"];
    const char *dbpath = [defaultDBPath UTF8String];
    sqlite3_stmt *statement, *statement2;
    _themeTheme = [[NSMutableArray alloc] init];
    _themeQuestionNumber = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &_pdd) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ThemeName from paper_ab_themes"];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_pdd, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *arrayelement = [[NSString alloc]
                                          initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 0)];
                [_themeTheme addObject:arrayelement];
            }
        }
        sqlite3_finalize(statement);
        
        NSString *querySQL2 = [NSString stringWithFormat:@"SELECT COUNT(*) FROM paper_ab GROUP BY QuestionType"];
        const char *query_stmt2 = [querySQL2 UTF8String];
        
        if (sqlite3_prepare_v2(_pdd, query_stmt2, -1, &statement2, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement2) == SQLITE_ROW) {
                NSNumber *arrayelement = [NSNumber numberWithInt:sqlite3_column_int(statement2, 0)];
                [_themeQuestionNumber addObject:arrayelement];
                NSLog(@"%d %@", _themeQuestionNumber.count, arrayelement);
            }
        }
        sqlite3_finalize(statement2);
    }
    sqlite3_close(_pdd);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_themeTheme count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"themeListCell" forIndexPath:indexPath];
    long row = [indexPath row];
    NSString *themecount = [NSString stringWithFormat:@"Вопросов : %@", _themeQuestionNumber[row]];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@", row + 1, _themeTheme[row]];
    cell.detailTextLabel.text = themecount;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [[_themeTheme objectAtIndex:indexPath.row]
                   sizeWithFont:[UIFont systemFontOfSize:18]
                   constrainedToSize:CGSizeMake(260, CGFLOAT_MAX)];
    double commonsize = size.height + 14;
    
    if (commonsize < 43)
        commonsize = 44.0;
    else if (commonsize < 57)
        commonsize = 66.0;
    else if (commonsize > 66 && commonsize < 79)
        commonsize = 88.0;
    else
        commonsize = 110.0;

    
    return commonsize;
}

@end
