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

@implementation ViewController {
    UIImageView *navBarHairlineImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];

    [self ifExamenStatTableExists];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    navBarHairlineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        const char *sql_stmt = "CREATE TABLE IF NOT EXISTS paper_ab_examen_stat (RecNo INTEGER PRIMARY KEY AUTOINCREMENT,  rightCount INTEGER, wrongCount INTEGER, rightAnswers TEXT, wrongAnswers TEXT, startDate INTEGER, finishDate INTEGER)";
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
