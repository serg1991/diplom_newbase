//
//  BiletListTableViewController.m
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 29.01.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "BiletListTableViewController.h"

@interface BiletListTableViewController ()

@end

@implementation BiletListTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self makeBiletRecordsArray];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"]];
        UILabel *label = [[UILabel alloc] init];
        [label setText:@"Меню"];
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            label.font = [UIFont systemFontOfSize:30.0];
        }
        [label sizeToFit];
        int space = 6;
        label.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + space, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        label.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + space, label.frame.origin.y - 9, label.frame.size.width, label.frame.size.height);
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, label.frame.size.width + imageView.frame.size.width + space, imageView.frame.size.height)];
        view.bounds = CGRectMake(view.bounds.origin.x + 8, view.bounds.origin.y - 1, view.bounds.size.width, view.bounds.size.height);
        [view addSubview:imageView];
        [view addSubview:label];
        UIButton *button = [[UIButton alloc] initWithFrame:view.frame];
        [button addTarget:self action:@selector(confirmCancel) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            label.alpha = 0.0;
            CGRect orig = label.frame;
            label.frame = CGRectMake(label.frame.origin.x + 25, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
            label.alpha = 1.0;
            label.frame = orig;
        } completion:nil];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:view];
        self.navigationItem.leftBarButtonItem = backButton;
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            UILabel *bigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 30)];
            bigLabel.text = @"Билеты";
            bigLabel.font = [UIFont systemFontOfSize:30.0];
            self.navigationItem.titleView = bigLabel;
        }
    } else {
        UIButton *customBackButton = [UIButton buttonWithType:101];
        [customBackButton setTitle:@"Меню" forState:UIControlStateNormal];
        [customBackButton addTarget:self
                             action:@selector(confirmCancel) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *myBackButton = [[UIBarButtonItem alloc] initWithCustomView:customBackButton];
        [self.navigationItem setLeftBarButtonItem:myBackButton];
    }
    [self makeBiletRecordsArray];
    _biletNumbers = [[NSMutableArray alloc] init];
    for (long row = 0; row < 40; row ++) {
        [_biletNumbers addObject:[NSString stringWithFormat:@"Билет № %d", (int) row + 1]];
    }
}

- (void)confirmCancel {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _biletNumbers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"biletListCell" forIndexPath:indexPath];
    long row = [indexPath row];
    NSString *record = [NSString stringWithFormat:@"Рекорд: %@ из 20", _biletRecords[row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _biletNumbers[row];
    cell.detailTextLabel.text = record;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showBiletDetails"]) {
        NSMutableArray *rightArray = [[NSMutableArray alloc] init];
        NSMutableArray *wrongArray = [[NSMutableArray alloc] init];
        NSMutableArray *wrongSelectedArray = [[NSMutableArray alloc] init];
        BiletViewController *detailViewController = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        long row = [myIndexPath row];
        detailViewController.biletNumber = row;
        detailViewController.wrongArray = wrongArray;
        detailViewController.rightArray = rightArray;
        detailViewController.wrongSelectedArray = wrongSelectedArray;
    }
}

- (NSMutableArray *)makeBiletRecordsArray {
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *defaultDBPath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"pdd_stat.sqlite"]];
    const char * dbpath = [defaultDBPath UTF8String];
    sqlite3_stmt *statement;
    _biletRecords = [[NSMutableArray alloc] init];
    if (sqlite3_open(dbpath, &_pdd_ab_stat) == SQLITE_OK) {
        for (long row = 0; row < 40; row ++) {
            NSString *querySQL = [NSString stringWithFormat:@"SELECT Max(rightCount) from paper_ab_stat WHERE biletNumber = \"%ld\"", row + 1];
            const char * query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(_pdd_ab_stat, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    NSNumber *arrayelement = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                    [_biletRecords addObject:arrayelement];
                }
            } else {
                NSNumber *arrayelement = [NSNumber numberWithInt:0];
                [_biletRecords addObject:arrayelement];
            }
            sqlite3_finalize(statement);
        }
    }
    sqlite3_close(_pdd_ab_stat);
    return _biletRecords;
}

@end
