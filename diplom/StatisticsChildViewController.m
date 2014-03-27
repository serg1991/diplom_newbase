//
//  StatisticsChildViewController.m
//  diplom
//
//  Created by Sergey Kiselev on 23.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "StatisticsChildViewController.h"

@interface StatisticsChildViewController ()

@end

@implementation StatisticsChildViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)getBiletStatistics {
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"pdd_stat.sqlite"]];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    int i = 0;
    if (sqlite3_open(dbpath, &_pdd_ab_stat) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT biletNumber, SUM(rightCount), SUM(wrongCount), cast(SUM(rightCount) AS FLOAT) / cast ((SUM(rightCount) + SUM(wrongCount))AS FLOAT) as percent FROM paper_ab_stat GROUP BY biletNumber ORDER BY percent DESC"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_pdd_ab_stat, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                UILabel *label =  [[UILabel alloc] initWithFrame: CGRectMake(10, 10 + (i * 30), 300, 20)];
                label.text = [NSString stringWithFormat:@"Билет №%d \t \t \t \t \t   %3.2f%%", sqlite3_column_int(statement, 0), sqlite3_column_double(statement, 3) * 100];
                if (sqlite3_column_double(statement, 3) < 0.8) {
                    label.backgroundColor = [UIColor redColor];
                }
                else {
                    label.backgroundColor = [UIColor greenColor];
                }
                label.layer.borderColor = [UIColor blackColor].CGColor;
                label.layer.borderWidth = 1.0;
                [self.view addSubview:label];
                i++;
            }
            sqlite3_finalize(statement);
        }
        else {
            NSLog(@"Ne mogu vypolnit' zapros!");
        }
        sqlite3_close(_pdd_ab_stat);
    }
    else {
        NSLog(@"Ne mogu ustanovit' soedinenie!");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_index == 0)
        [self getBiletStatistics];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
