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
            }
        }
        sqlite3_finalize(statement2);
    }
    sqlite3_close(_pdd);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"]];
    UILabel *labelback = [[UILabel alloc] init];
    [labelback setText:@"Меню"];
    [labelback sizeToFit];
    
    int space = 6;
    labelback.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + space, labelback.frame.origin.y, labelback.frame.size.width, labelback.frame.size.height);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, labelback.frame.size.width + imageView.frame.size.width + space, imageView.frame.size.height)];
    
    view.bounds = CGRectMake(view.bounds.origin.x + 8, view.bounds.origin.y - 1, view.bounds.size.width, view.bounds.size.height);
    [view addSubview:imageView];
    [view addSubview:labelback];
    
    UIButton *button = [[UIButton alloc] initWithFrame:view.frame];
    [button addTarget:self action:@selector(confirmCancel) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        labelback.alpha = 0.0;
        CGRect orig = labelback.frame;
        labelback.frame = CGRectMake(labelback.frame.origin.x + 25, labelback.frame.origin.y, labelback.frame.size.width, labelback.frame.size.height);
        labelback.alpha = 1.0;
        labelback.frame = orig;
    } completion:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)confirmCancel {
    [self.navigationController popViewControllerAnimated:YES];
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
    
    if (commonsize < 43) {
        commonsize = 44.0;
    }
    else if (commonsize < 57) {
        commonsize = 66.0;
    }
    else if (commonsize > 66 && commonsize < 79) {
        commonsize = 88.0;
    }
    else {
        commonsize = 110.0;
    }
    
    return commonsize;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showThemeDetails"]) {
        NSMutableArray *rightArray = [[NSMutableArray alloc] init];
        NSMutableArray *wrongArray = [[NSMutableArray alloc] init];
        NSMutableArray *wrongSelectedArray = [[NSMutableArray alloc] init];
        
        ThemeViewController *detailViewController = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        long row = [myIndexPath row];
        detailViewController.themeNumber = row;
        detailViewController.themeCount = _themeQuestionNumber;
        detailViewController.wrongArray = wrongArray;
        detailViewController.rightArray = rightArray;
        detailViewController.wrongSelectedArray = wrongSelectedArray;
    }
}

@end
