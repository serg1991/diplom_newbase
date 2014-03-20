//
//  ViewController.m
//  diplom
//
//  Created by Sergey Kiselev on 26.01.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self ifExamenStatTableExists];
// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showExamen"]) {
        NSMutableArray *rightArray = [[NSMutableArray alloc] init];
        NSMutableArray *wrongArray = [[NSMutableArray alloc] init];
        NSMutableArray *wrongSelectedArray = [[NSMutableArray alloc] init];
        
        ExamenViewController *detailViewController = [segue destinationViewController];

        detailViewController.wrongArray = wrongArray;
        detailViewController.rightArray = rightArray;
        detailViewController.wrongSelectedArray = wrongSelectedArray;
    }
}

- (void)ifExamenStatTableExists {
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"pdd_stat.sqlite"]];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_pdd_ab_stat) == SQLITE_OK) {
        char *errMsg;
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS paper_ab_examen_stat (RecNo INTEGER PRIMARY KEY AUTOINCREMENT,  rightCount INTEGER, wrongCount INTEGER, rightAnswers TEXT, wrongAnswers TEXT, startDate TEXT, finishDate TEXT)";
        if (sqlite3_exec(_pdd_ab_stat, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
            NSLog(@"Failed to create table");
        }
        sqlite3_close(_pdd_ab_stat);
    }
    else {
        NSLog(@"Failed to open/create database");
    }
}

@end
