//
//  ViewController.m
//  ZnatokPDD
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
    UITapGestureRecognizer *singleTap1 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    UITapGestureRecognizer *singleTap2 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    UITapGestureRecognizer *singleTap3 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    UITapGestureRecognizer *singleTap4 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    UITapGestureRecognizer *singleTap5 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    UITapGestureRecognizer *singleTap6 =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [_image1 addGestureRecognizer:singleTap1];
    [_image2 addGestureRecognizer:singleTap2];
    [_image3 addGestureRecognizer:singleTap3];
    [_image4 addGestureRecognizer:singleTap4];
    [_image5 addGestureRecognizer:singleTap5];
    [_image6 addGestureRecognizer:singleTap6];
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    [self ifStatTablesExists];
}

- (void)singleTapping:(UIGestureRecognizer *)recognizer {
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    switch ((long)recognizer.view.tag) {
        case 1: {
            _image1.image = [UIImage imageNamed:@"bookmark_hl.png"];
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self performSegueWithIdentifier:@"showTheme" sender:self];
            });
            break;
        }
        case 2: {
            _image2.image = [UIImage imageNamed:@"bilet_hl.png"];
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self performSegueWithIdentifier:@"showBilet" sender:self];
            });
            break;
        }
        case 3: {
            _image3.image = [UIImage imageNamed:@"examen_hl.png"];
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self performSegueWithIdentifier:@"showExamen" sender:self];
            });
            break;
        }
        case 4: {
            _image4.image = [UIImage imageNamed:@"statistics_hl.png"];
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self performSegueWithIdentifier:@"showStatistics" sender:self];
            });
            break;
        }
        case 5: {
            _image5.image = [UIImage imageNamed:@"literature_hl.png"];
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self performSegueWithIdentifier:@"showRules" sender:self];
            });
            break;
        }
        case 6: {
            _image6.image = [UIImage imageNamed:@"settings_hl.png"];
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self performSegueWithIdentifier:@"showSettings" sender:self];
            });
            break;
        }
    }
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
    _image1.image = [UIImage imageNamed:@"bookmark.png"];
    _image2.image = [UIImage imageNamed:@"bilet.png"];
    _image3.image = [UIImage imageNamed:@"examen.png"];
    _image4.image = [UIImage imageNamed:@"statistics.png"];
    _image5.image = [UIImage imageNamed:@"literature.png"];
    _image6.image = [UIImage imageNamed:@"settings.png"];
    
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

- (void)ifStatTablesExists {
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"pdd_stat.sqlite"]];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
		const char * dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &_pdd_ab_stat) == SQLITE_OK) {
            char *errMsg;
            const char * sql_stmt_biletStat = "CREATE TABLE IF NOT EXISTS paper_ab_stat (RecNo integer PRIMARY KEY AUTOINCREMENT NOT NULL, biletNumber integer NOT NULL, rightCount integer NOT NULL, wrongCount integer NOT NULL, startDate integer NOT NULL, finishDate integer NOT NULL)";
            const char * sql_stmt_themeStat = "CREATE TABLE IF NOT EXISTS paper_ab_theme_stat (RecNo integer PRIMARY KEY AUTOINCREMENT NOT NULL, themeNumber integer NOT NULL, rightCount integer NOT NULL, wrongCount integer NOT NULL, startDate integer NOT NULL, finishDate integer NOT NULL)";
            const char * sql_stmt_examenStat = "CREATE TABLE IF NOT EXISTS paper_ab_examen_stat (RecNo integer PRIMARY KEY AUTOINCREMENT NOT NULL, rightCount integer NOT NULL, wrongCount integer NOT NULL, rightAnswers text NOT NULL, wrongAnswers text NOT NULL, startDate integer NOT NULL, finishDate integer NOT NULL)";
            if (sqlite3_exec(_pdd_ab_stat, sql_stmt_biletStat, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create bilet table!");
            }
            if (sqlite3_exec(_pdd_ab_stat, sql_stmt_themeStat, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create theme table!");
            }
            if (sqlite3_exec(_pdd_ab_stat, sql_stmt_examenStat, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create examen table!");
            }
            sqlite3_close(_pdd_ab_stat);
        } else {
            NSLog(@"Failed to open/create database");
        }
    } else {
        NSLog(@"File exists!");
    }
}

@end
