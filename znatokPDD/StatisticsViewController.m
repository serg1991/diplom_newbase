//
//  StatisticsViewController.m
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 23.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "StatisticsViewController.h"

@interface StatisticsViewController ()

@end

@implementation StatisticsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self getBiletStatistics];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.segmentedControl.tintColor = [UIColor blackColor];
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
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
        UIButton *trashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [trashButton setBackgroundImage:[UIImage imageNamed:@"UIButtonBarTrash"] forState:UIControlStateNormal];
        trashButton.frame = CGRectMake(0, 0, 18, 25);
        [trashButton addTarget:self action:@selector(confirmReset) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *trashIconButton = [[UIBarButtonItem alloc]initWithCustomView:trashButton];
        self.navigationItem.rightBarButtonItem = trashIconButton;
    } else {
        UIButton *customBackButton = [UIButton buttonWithType:101];
        [customBackButton setTitle:@"Меню" forState:UIControlStateNormal];
        [customBackButton addTarget:self
                             action:@selector(confirmCancel) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *myBackButton = [[UIBarButtonItem alloc] initWithCustomView:customBackButton];
        [self.navigationItem setLeftBarButtonItem:myBackButton];
        UIButton *trashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [trashButton setBackgroundImage:[UIImage imageNamed:@"UIButtonBarTrash6"] forState:UIControlStateNormal];
        trashButton.frame = CGRectMake(0, 0, 18, 25);
        [trashButton addTarget:self action:@selector(confirmReset) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *trashIconButton = [[UIBarButtonItem alloc]initWithCustomView:trashButton];
        self.navigationItem.rightBarButtonItem = trashIconButton;
    }
}

- (void)confirmCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        NSString *docsDir;
        NSArray *dirPaths;
        NSString *databasePath;
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"pdd_stat.sqlite"]];
		const char * dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &_pdd_ab_stat) == SQLITE_OK) {
            char *errMsg;
            const char * sql_stmt_removeBiletStat = "DELETE FROM paper_ab_stat WHERE RecNo > 0";
            const char * sql_stmt_removeThemeStat = "DELETE FROM paper_ab_theme_stat WHERE RecNo > 0";
            const char * sql_stmt_removeExamenStat = "DELETE FROM paper_ab_examen_stat WHERE RecNo > 0";
            if (sqlite3_exec(_pdd_ab_stat, sql_stmt_removeBiletStat, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to remove bilet table!");
            }
            if (sqlite3_exec(_pdd_ab_stat, sql_stmt_removeThemeStat, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to remove theme table!");
            }
            if (sqlite3_exec(_pdd_ab_stat, sql_stmt_removeExamenStat, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to remove examen table!");
            }
            sqlite3_close(_pdd_ab_stat);
        } else {
            NSLog(@"Failed to open database!");
        }
        switch (self.segmentedControl.selectedSegmentIndex) {
            case 0: {
                for (UIView *subview in [self.view subviews]) {
                    [subview removeFromSuperview];
                }
                [self getBiletStatistics];
            }
                break;
            case 1: {
                for (UIView *subview in [self.view subviews]) {
                    [subview removeFromSuperview];
                }
                [self getThemeStatistics];
            }
                break;
            case 2: {
                for (UIView *subview in [self.view subviews]) {
                    [subview removeFromSuperview];
                }
                [self getExamenStatistics];
            }
                break;
        }
    }
}

- (void)confirmReset {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание"
                                                    message:@"Вы действительно хотите сбросить статистику и рекорды?"
                                                   delegate:self
                                          cancelButtonTitle:@"Нет"
                                          otherButtonTitles:@"Да, сбросить", nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getBiletStatistics {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"pdd_stat.sqlite"]];
    const char * dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement1, *statement2;
    int i = 0;
    if (sqlite3_open(dbpath, &_pdd_ab_stat) == SQLITE_OK) {
        UILabel *BiletCommonStatTitle = [[UILabel alloc] initWithFrame: CGRectMake(10, 2, 300, 40)];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            BiletCommonStatTitle.text = @"Общая статистика ответов на билеты\nПравильных ответов\t\t\t  Неправильных ответов";
            BiletCommonStatTitle.textAlignment = NSTextAlignmentCenter;
            BiletCommonStatTitle.numberOfLines = 2;
            BiletCommonStatTitle.font = [UIFont italicSystemFontOfSize:11];
            [BiletCommonStatTitle sizeToFit];
            [scrollView addSubview:BiletCommonStatTitle];
        } else {
            BiletCommonStatTitle.text = @"Общая статистика ответов на билеты\nПравильных ответов\t\t\t  Неправильных ответов";
            BiletCommonStatTitle.textAlignment = NSTextAlignmentCenter;
            BiletCommonStatTitle.numberOfLines = 2;
            BiletCommonStatTitle.font = [UIFont italicSystemFontOfSize:11];
            [scrollView addSubview:BiletCommonStatTitle];
        }
        NSString *querySQL1 = [NSString stringWithFormat:@"SELECT SUM(rightCount), SUM(wrongCount), (SUM(rightCount) + SUM(wrongCount)) FROM paper_ab_stat"];
        const char * query_stmt1 = [querySQL1 UTF8String];
        if (sqlite3_prepare_v2(_pdd_ab_stat, query_stmt1, -1, &statement1, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement1) == SQLITE_ROW) {
                if (sqlite3_column_int(statement1, 2) != 0) {
                    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                        NSString *stat = [NSString stringWithFormat:@" %d \t\t\t\t\t\t\t\t %d ", sqlite3_column_int(statement1, 0), sqlite3_column_int(statement1, 1)];
                        UILabel *BiletCommonStat = [[UILabel alloc] initWithFrame: CGRectMake(10, 30, 300, 20)];
                        BiletCommonStat.text = stat;
                        BiletCommonStat.textColor = [UIColor whiteColor];
                        UIGraphicsBeginImageContext(CGSizeMake(300, 20));
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        if (sqlite3_column_int(statement1, 0) != 0) {
                            CGContextSetRGBFillColor(context,  0.0, 0.8, 0.0, 1.0);
                            CGContextFillRect(context, CGRectMake(0.0, 0.0, 300 * (sqlite3_column_int(statement1, 0) * 1.0 / sqlite3_column_int(statement1, 2)), 20));
                        }
                        if (sqlite3_column_int(statement1, 1) != 0) {
                            CGContextSetRGBFillColor(context,  0.8, 0.0, 0.0, 1.0);
                            CGContextFillRect(context, CGRectMake(300 * (sqlite3_column_int(statement1, 0) * 1.0 / sqlite3_column_int(statement1, 2)), 0.0, 300 * ((sqlite3_column_int(statement1, 1) * 1.0 / sqlite3_column_int(statement1, 2))), 20));
                        }
                        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        BiletCommonStat.backgroundColor = [UIColor colorWithPatternImage:resultingImage];
                        [scrollView addSubview:BiletCommonStat];
                    } else {
                        NSString *stat = [NSString stringWithFormat:@" %d \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t %d ", sqlite3_column_int(statement1, 0), sqlite3_column_int(statement1, 1)];
                        UILabel *BiletCommonStat = [[UILabel alloc] initWithFrame: CGRectMake(10, 40, 300, 20)];
                        BiletCommonStat.text = stat;
                        BiletCommonStat.textColor = [UIColor whiteColor];
                        UIGraphicsBeginImageContext(CGSizeMake(300, 20));
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        if (sqlite3_column_int(statement1, 0) != 0) {
                            CGContextSetRGBFillColor(context,  0.0, 0.8, 0.0, 1.0);
                            CGContextFillRect(context, CGRectMake(0.0, 0.0, 300 * (sqlite3_column_int(statement1, 0) * 1.0 / sqlite3_column_int(statement1, 2)), 20));
                        }
                        if (sqlite3_column_int(statement1, 1) != 0) {
                            CGContextSetRGBFillColor(context,  0.8, 0.0, 0.0, 1.0);
                            CGContextFillRect(context, CGRectMake(300 * (sqlite3_column_int(statement1, 0) * 1.0 / sqlite3_column_int(statement1, 2)), 0.0, 300 * ((sqlite3_column_int(statement1, 1) * 1.0 / sqlite3_column_int(statement1, 2))), 20));
                        }
                        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        BiletCommonStat.backgroundColor = [UIColor colorWithPatternImage:resultingImage];
                        [scrollView addSubview:BiletCommonStat];
                    }
                } else {
                    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                        NSString *stat = [NSString stringWithFormat:@" 0 \t\t\t\t\t\t\t\t 0 "];
                        UILabel *BiletCommonStat = [[UILabel alloc] initWithFrame: CGRectMake(10, 40, 300, 20)];
                        BiletCommonStat.text = stat;
                        BiletCommonStat.textColor = [UIColor whiteColor];
                        UIGraphicsBeginImageContext(CGSizeMake(300, 20));
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextSetRGBFillColor(context,  0.0, 0.8, 0.0, 1.0);
                        CGContextFillRect(context, CGRectMake(0.0, 0.0, 300 * 0.5, 20));
                        CGContextSetRGBFillColor(context,  0.8, 0.0, 0.0, 1.0);
                        CGContextFillRect(context, CGRectMake(300 * 0.5, 0.0, 300 * 0.5, 20));
                        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        BiletCommonStat.backgroundColor = [UIColor colorWithPatternImage:resultingImage];
                        [scrollView addSubview:BiletCommonStat];
                    } else {
                        NSString *stat = [NSString stringWithFormat:@" 0 \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t 0 "];
                        UILabel *BiletCommonStat = [[UILabel alloc] initWithFrame: CGRectMake(10, 40, 300, 20)];
                        BiletCommonStat.text = stat;
                        BiletCommonStat.textAlignment = NSTextAlignmentCenter;
                        BiletCommonStat.textColor = [UIColor whiteColor];
                        UIGraphicsBeginImageContext(CGSizeMake(300, 20));
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextSetRGBFillColor(context,  0.0, 0.8, 0.0, 1.0);
                        CGContextFillRect(context, CGRectMake(0.0, 0.0, 300 * 0.5, 20));
                        CGContextSetRGBFillColor(context,  0.8, 0.0, 0.0, 1.0);
                        CGContextFillRect(context, CGRectMake(300 * 0.5, 0.0, 300 * 0.5, 20));
                        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        BiletCommonStat.backgroundColor = [UIColor colorWithPatternImage:resultingImage];
                        [scrollView addSubview:BiletCommonStat];
                    }
                }
            }
            sqlite3_finalize(statement1);
        } else {
            NSLog(@"Ne mogu vypolnit' zapros #1!");
        }
        UILabel *BiletStatTitle = [[UILabel alloc] initWithFrame: CGRectMake(10, 80, 300, 40)];
        BiletStatTitle.text = @"\tСтатистика правильности ответов по билетам";
        BiletStatTitle.textAlignment = NSTextAlignmentCenter;
        BiletStatTitle.font = [UIFont italicSystemFontOfSize:11];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            [BiletStatTitle sizeToFit];
        }
        [scrollView addSubview:BiletStatTitle];
        NSString *querySQL2 = [NSString stringWithFormat:@"SELECT biletNumber, SUM(rightCount), SUM(wrongCount), cast(SUM(rightCount) AS FLOAT) / cast ((SUM(rightCount) + SUM(wrongCount))AS FLOAT) as percent FROM paper_ab_stat GROUP BY biletNumber ORDER BY percent DESC"];
        const char * query_stmt2 = [querySQL2 UTF8String];
        if (sqlite3_prepare_v2(_pdd_ab_stat, query_stmt2, -1, &statement2, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement2) == SQLITE_ROW) {
                NSString *stat = [NSString stringWithFormat:@" Билет №%d - %3.2f%%", sqlite3_column_int(statement2, 0), sqlite3_column_double(statement2, 3) * 100];
                UILabel *BiletStat = [[UILabel alloc] initWithFrame: CGRectMake(10, 110 + (i * 30), 300, 20)];
                BiletStat.text = stat;
                BiletStat.textColor = [UIColor whiteColor];
                UIGraphicsBeginImageContext(CGSizeMake(300, 20));
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetRGBFillColor(context,  0.0, 0.8, 0.0, 1.0);
                CGContextFillRect(context, CGRectMake(0.0, 0.0, 300 * sqlite3_column_double(statement2, 3), 20));
                CGContextSetRGBFillColor(context,  0.8, 0.0, 0.0, 1.0);
                CGContextFillRect(context, CGRectMake(300 * sqlite3_column_double(statement2, 3), 0.0, 300 * (1 - sqlite3_column_double(statement2, 3)), 20));
                UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                BiletStat.backgroundColor = [UIColor colorWithPatternImage:resultingImage];
                [scrollView addSubview:BiletStat];
                i++;
            }
            sqlite3_finalize(statement2);
        } else {
            NSLog(@"Ne mogu vypolnit' zapros #2!");
        }
        sqlite3_close(_pdd_ab_stat);
    } else {
        NSLog(@"Ne mogu ustanovit' soedinenie!");
    }
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight == 480) {
        [scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height + 30 * (i - 9))];
    } else {
        [scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height + 30 * (i - 12))];
    }
    [self.view addSubview:scrollView];
}

- (void)getThemeStatistics {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"pdd_stat.sqlite"]];
    const char * dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement1, *statement2;
    int i = 0;
    if (sqlite3_open(dbpath, &_pdd_ab_stat) == SQLITE_OK) {
        UILabel *BiletCommonStatTitle = [[UILabel alloc] initWithFrame: CGRectMake(10, 2, 300, 40)];
        BiletCommonStatTitle.text = @"Общая статистика ответов на темы\nПравильных ответов\t\t\t  Неправильных ответов";
        BiletCommonStatTitle.textAlignment = NSTextAlignmentCenter;
        BiletCommonStatTitle.numberOfLines = 2;
        BiletCommonStatTitle.font = [UIFont italicSystemFontOfSize:11];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            [BiletCommonStatTitle sizeToFit];
        }
        [scrollView addSubview:BiletCommonStatTitle];
        NSString *querySQL1 = [NSString stringWithFormat:@"SELECT SUM(rightCount), SUM(wrongCount), (SUM(rightCount) + SUM(wrongCount)) FROM paper_ab_theme_stat"];
        const char * query_stmt1 = [querySQL1 UTF8String];
        if (sqlite3_prepare_v2(_pdd_ab_stat, query_stmt1, -1, &statement1, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement1) == SQLITE_ROW) {
                if (sqlite3_column_int(statement1, 2) != 0) {
                    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                        NSString *stat = [NSString stringWithFormat:@" %d \t\t\t\t\t\t\t\t %d ", sqlite3_column_int(statement1, 0), sqlite3_column_int(statement1, 1)];
                        UILabel *BiletCommonStat = [[UILabel alloc] initWithFrame: CGRectMake(10, 30, 300, 20)];
                        BiletCommonStat.text = stat;
                        BiletCommonStat.textColor = [UIColor whiteColor];
                        UIGraphicsBeginImageContext(CGSizeMake(300, 20));
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        if (sqlite3_column_int(statement1, 0) != 0) {
                            CGContextSetRGBFillColor(context,  0.0, 0.8, 0.0, 1.0);
                            CGContextFillRect(context, CGRectMake(0.0, 0.0, 300 * (sqlite3_column_int(statement1, 0) * 1.0 / sqlite3_column_int(statement1, 2)), 20));
                        }
                        if (sqlite3_column_int(statement1, 1) != 0) {
                            CGContextSetRGBFillColor(context,  0.8, 0.0, 0.0, 1.0);
                            CGContextFillRect(context, CGRectMake(300 * (sqlite3_column_int(statement1, 0) * 1.0 / sqlite3_column_int(statement1, 2)), 0.0, 300 * ((sqlite3_column_int(statement1, 1) * 1.0 / sqlite3_column_int(statement1, 2))), 20));
                        }
                        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        BiletCommonStat.backgroundColor = [UIColor colorWithPatternImage:resultingImage];
                        [scrollView addSubview:BiletCommonStat];
                    } else {
                        NSString *stat = [NSString stringWithFormat:@" %d \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t %d ", sqlite3_column_int(statement1, 0), sqlite3_column_int(statement1, 1)];
                        UILabel *BiletCommonStat = [[UILabel alloc] initWithFrame: CGRectMake(10, 40, 300, 20)];
                        BiletCommonStat.text = stat;
                        BiletCommonStat.textColor = [UIColor whiteColor];
                        UIGraphicsBeginImageContext(CGSizeMake(300, 20));
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        if (sqlite3_column_int(statement1, 0) != 0) {
                            CGContextSetRGBFillColor(context,  0.0, 0.8, 0.0, 1.0);
                            CGContextFillRect(context, CGRectMake(0.0, 0.0, 300 * (sqlite3_column_int(statement1, 0) * 1.0 / sqlite3_column_int(statement1, 2)), 20));
                        }
                        if (sqlite3_column_int(statement1, 1) != 0) {
                            CGContextSetRGBFillColor(context,  0.8, 0.0, 0.0, 1.0);
                            CGContextFillRect(context, CGRectMake(300 * (sqlite3_column_int(statement1, 0) * 1.0 / sqlite3_column_int(statement1, 2)), 0.0, 300 * ((sqlite3_column_int(statement1, 1) * 1.0 / sqlite3_column_int(statement1, 2))), 20));
                        }
                        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        BiletCommonStat.backgroundColor = [UIColor colorWithPatternImage:resultingImage];
                        [scrollView addSubview:BiletCommonStat];
                    }
                } else {
                    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                        NSString *stat = [NSString stringWithFormat:@" 0 \t\t\t\t\t\t\t\t 0 "];
                        UILabel *BiletCommonStat = [[UILabel alloc] initWithFrame: CGRectMake(10, 30, 300, 20)];
                        BiletCommonStat.text = stat;
                        BiletCommonStat.textColor = [UIColor whiteColor];
                        UIGraphicsBeginImageContext(CGSizeMake(300, 20));
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextSetRGBFillColor(context,  0.0, 0.8, 0.0, 1.0);
                        CGContextFillRect(context, CGRectMake(0.0, 0.0, 300 * 0.5, 20));
                        CGContextSetRGBFillColor(context,  0.8, 0.0, 0.0, 1.0);
                        CGContextFillRect(context, CGRectMake(300 * 0.5, 0.0, 300 * 0.5, 20));
                        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        BiletCommonStat.backgroundColor = [UIColor colorWithPatternImage:resultingImage];
                        [scrollView addSubview:BiletCommonStat];
                    } else {
                        NSString *stat = [NSString stringWithFormat:@" 0 \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t 0 "];
                        UILabel *BiletCommonStat = [[UILabel alloc] initWithFrame: CGRectMake(10, 40, 300, 20)];
                        BiletCommonStat.text = stat;
                        BiletCommonStat.textAlignment = NSTextAlignmentCenter;
                        BiletCommonStat.textColor = [UIColor whiteColor];
                        UIGraphicsBeginImageContext(CGSizeMake(300, 20));
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextSetRGBFillColor(context,  0.0, 0.8, 0.0, 1.0);
                        CGContextFillRect(context, CGRectMake(0.0, 0.0, 300 * 0.5, 20));
                        CGContextSetRGBFillColor(context,  0.8, 0.0, 0.0, 1.0);
                        CGContextFillRect(context, CGRectMake(300 * 0.5, 0.0, 300 * 0.5, 20));
                        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        BiletCommonStat.backgroundColor = [UIColor colorWithPatternImage:resultingImage];
                        [scrollView addSubview:BiletCommonStat];
                    }
                }
            }
            sqlite3_finalize(statement1);
        } else {
            NSLog(@"Ne mogu vypolnit' zapros #1!");
        }
        UILabel *ThemeStatTitle = [[UILabel alloc] initWithFrame: CGRectMake(10, 80, 300, 40)];
        ThemeStatTitle.text = @"\tСтатистика правильности ответов по темам";
        ThemeStatTitle.textAlignment = NSTextAlignmentCenter;
        ThemeStatTitle.font = [UIFont italicSystemFontOfSize:11];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            [ThemeStatTitle sizeToFit];
        }
        [scrollView addSubview:ThemeStatTitle];
        NSString *querySQL2 = [NSString stringWithFormat:@"SELECT themeNumber, SUM(rightCount), SUM(wrongCount), cast(SUM(rightCount) AS FLOAT) / cast ((SUM(rightCount) + SUM(wrongCount))AS FLOAT) as percent FROM paper_ab_theme_stat GROUP BY themeNumber ORDER BY percent DESC"];
        const char * query_stmt2 = [querySQL2 UTF8String];
        if (sqlite3_prepare_v2(_pdd_ab_stat, query_stmt2, -1, &statement2, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement2) == SQLITE_ROW) {
                NSString *stat = [NSString stringWithFormat:@" Тема №%d - %3.2f%%", sqlite3_column_int(statement2, 0), sqlite3_column_double(statement2, 3) * 100];
                UILabel *BiletStat = [[UILabel alloc] initWithFrame: CGRectMake(10, 110 + (i * 30), 300, 20)];
                BiletStat.text = stat;
                BiletStat.textColor = [UIColor whiteColor];
                UIGraphicsBeginImageContext(CGSizeMake(300, 20));
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextSetRGBFillColor(context,  0.0, 0.8, 0.0, 1.0);
                CGContextFillRect(context, CGRectMake(0.0, 0.0, 300 * sqlite3_column_double(statement2, 3), 20));
                CGContextSetRGBFillColor(context,  0.8, 0.0, 0.0, 1.0);
                CGContextFillRect(context, CGRectMake(300 * sqlite3_column_double(statement2, 3), 0.0, 300 * (1 - sqlite3_column_double(statement2, 3)), 20));
                UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                BiletStat.backgroundColor = [UIColor colorWithPatternImage:resultingImage];
                [scrollView addSubview:BiletStat];
                i++;
            }
            sqlite3_finalize(statement2);
        } else {
            NSLog(@"Ne mogu vypolnit' zapros #2!");
        }
        sqlite3_close(_pdd_ab_stat);
    } else {
        NSLog(@"Ne mogu ustanovit' soedinenie!");
    }
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (screenHeight == 480) {
        [scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height + 30 * (i - 9))];
    } else {
        [scrollView setContentSize:CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height + 30 * (i - 12))];
    }
    [self.view addSubview:scrollView];
}

- (void)getExamenStatistics {
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"pdd_stat.sqlite"]];
    const char * dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement1, *statement2, *statement3;
    if (sqlite3_open(dbpath, &_pdd_ab_stat) == SQLITE_OK) {
        NSString *querySQL1 = [NSString stringWithFormat:@"SELECT SUM(rightCount), SUM(wrongCount), (SUM(rightCount)+SUM(wrongCount)) FROM paper_ab_examen_stat"];
        const char * query_stmt1 = [querySQL1 UTF8String];
        if (sqlite3_prepare_v2(_pdd_ab_stat, query_stmt1, -1, &statement1, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement1) == SQLITE_ROW) {
                UILabel *ExCommonResultTitle = [[UILabel alloc] initWithFrame: CGRectMake(10, 2, 300, 40)];
                ExCommonResultTitle.textAlignment = NSTextAlignmentCenter;
                ExCommonResultTitle.numberOfLines = 2;
                ExCommonResultTitle.text = @" Общая статистика прохождения экзамена\nПравильных ответов\t\t\t  Неправильных ответов";
                ExCommonResultTitle.font = [UIFont italicSystemFontOfSize:11];
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                    [ExCommonResultTitle sizeToFit];
                }
                [self.view addSubview:ExCommonResultTitle];
                if (sqlite3_column_int(statement1, 2) != 0) {
                    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                        NSString *stat = [NSString stringWithFormat:@" %d \t\t\t\t\t\t\t\t %d ", sqlite3_column_int(statement1, 0), sqlite3_column_int(statement1, 1)];
                        UILabel *ExResult = [[UILabel alloc] initWithFrame: CGRectMake(10, 30, 300, 20)];
                        ExResult.text = stat;
                        ExResult.textColor = [UIColor whiteColor];
                        UIGraphicsBeginImageContext(CGSizeMake(300, 20));
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextSetRGBFillColor(context,  0.0, 0.8, 0.0, 1.0);//green
                        CGContextFillRect(context, CGRectMake(0.0, 0.0, 300 * (sqlite3_column_int(statement1, 0) * 1.0 / sqlite3_column_int(statement1, 2)), 20));
                        CGContextSetRGBFillColor(context,  0.8, 0.0, 0.0, 1.0);//red
                        CGContextFillRect(context, CGRectMake(300 * (sqlite3_column_int(statement1, 0) * 1.0 / sqlite3_column_int(statement1, 2)), 0.0, 300 * (sqlite3_column_double(statement1, 1) * 1.0 / sqlite3_column_int(statement1, 2)), 20));
                        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        ExResult.backgroundColor = [UIColor colorWithPatternImage:resultingImage];
                        [self.view addSubview:ExResult];
                    } else {
                        NSString *stat = [NSString stringWithFormat:@" %d \t\t\t\t\t\t\t\t %d ", sqlite3_column_int(statement1, 0), sqlite3_column_int(statement1, 1)];
                        UILabel *ExResult = [[UILabel alloc] initWithFrame: CGRectMake(10, 40, 300, 20)];
                        ExResult.text = stat;
                        ExResult.textColor = [UIColor whiteColor];
                        UIGraphicsBeginImageContext(CGSizeMake(300, 20));
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextSetRGBFillColor(context,  0.0, 0.8, 0.0, 1.0);//green
                        CGContextFillRect(context, CGRectMake(0.0, 0.0, 300 * (sqlite3_column_int(statement1, 0) * 1.0 / sqlite3_column_int(statement1, 2)), 20));
                        CGContextSetRGBFillColor(context,  0.8, 0.0, 0.0, 1.0);//red
                        CGContextFillRect(context, CGRectMake(300 * (sqlite3_column_int(statement1, 0) * 1.0 / sqlite3_column_int(statement1, 2)), 0.0, 300 * (sqlite3_column_double(statement1, 1) * 1.0 / sqlite3_column_int(statement1, 2)), 20));
                        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        ExResult.backgroundColor = [UIColor colorWithPatternImage:resultingImage];
                        [self.view addSubview:ExResult];
                    }
                } else {
                    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                        NSString *stat = [NSString stringWithFormat:@" 0 \t\t\t\t\t\t\t\t 0 "];
                        UILabel *ExResult = [[UILabel alloc] initWithFrame: CGRectMake(10, 30, 300, 20)];
                        ExResult.text = stat;
                        ExResult.textColor = [UIColor whiteColor];
                        UIGraphicsBeginImageContext(CGSizeMake(300, 20));
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextSetRGBFillColor(context,  0.0, 0.8, 0.0, 1.0);//green
                        CGContextFillRect(context, CGRectMake(0.0, 0.0, 300 * 0.5, 20));
                        CGContextSetRGBFillColor(context,  0.8, 0.0, 0.0, 1.0);//red
                        CGContextFillRect(context, CGRectMake(300 * 0.5, 0.0, 300 * 0.5, 20));
                        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        ExResult.backgroundColor = [UIColor colorWithPatternImage:resultingImage];
                        [self.view addSubview:ExResult];
                    } else {
                        NSString *stat = [NSString stringWithFormat:@" 0 \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t 0 "];
                        UILabel *ExResult = [[UILabel alloc] initWithFrame: CGRectMake(10, 40, 300, 20)];
                        ExResult.text = stat;
                        ExResult.textAlignment = NSTextAlignmentCenter;
                        ExResult.textColor = [UIColor whiteColor];
                        UIGraphicsBeginImageContext(CGSizeMake(300, 20));
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextSetRGBFillColor(context,  0.0, 0.8, 0.0, 1.0);//green
                        CGContextFillRect(context, CGRectMake(0.0, 0.0, 300 * 0.5, 20));
                        CGContextSetRGBFillColor(context,  0.8, 0.0, 0.0, 1.0);//red
                        CGContextFillRect(context, CGRectMake(300 * 0.5, 0.0, 300 * 0.5, 20));
                        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        ExResult.backgroundColor = [UIColor colorWithPatternImage:resultingImage];
                        [self.view addSubview:ExResult];
                    }
                }
            }
            sqlite3_finalize(statement1);
        } else {
            NSLog(@"Ne mogu vypolnit' zapros #1!");
        }
        NSString *querySQL2 = [NSString stringWithFormat:@"SELECT Count(*), Count(CASE WHEN rightCount>17 THEN 1 ELSE NULL END), (Count(*) - Count(CASE WHEN rightCount>17 THEN 1 ELSE NULL END)) FROM paper_ab_examen_stat"];
        const char * query_stmt2 = [querySQL2 UTF8String];
        if (sqlite3_prepare_v2(_pdd_ab_stat, query_stmt2, -1, &statement2, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement2) == SQLITE_ROW) {
                if (sqlite3_column_int(statement2, 0) != 0) {
                    UILabel *ExTriesTitle = [[UILabel alloc] initWithFrame: CGRectMake(10, 80, 300, 40)];
                    ExTriesTitle.numberOfLines = 2;
                    ExTriesTitle.text = [NSString stringWithFormat:@"   Попыток прохождения экзаменационного теста : %d\nУспешных \t\t\t\t\t\t  Неуспешных", sqlite3_column_int(statement2, 0)];
                    ExTriesTitle.font = [UIFont italicSystemFontOfSize:11];
                    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                        [ExTriesTitle sizeToFit];
                    }
                    [self.view addSubview:ExTriesTitle];
                    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                        NSString *stat = [NSString stringWithFormat:@" %d \t\t\t\t\t\t\t\t\t %d ", sqlite3_column_int(statement2, 1), sqlite3_column_int(statement2, 2)];
                        UILabel *ExResult = [[UILabel alloc] initWithFrame: CGRectMake(10, 110, 300, 20)];
                        ExResult.text = stat;
                        ExResult.textColor = [UIColor whiteColor];
                        UIGraphicsBeginImageContext(CGSizeMake(300, 20));
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextSetRGBFillColor(context,  0.0, 0.8, 0.0, 1.0);//green
                        CGContextFillRect(context, CGRectMake(0.0, 0.0, 300 * (1 - (sqlite3_column_double(statement2, 2) * 1.0 / sqlite3_column_int(statement2, 0))), 20));
                        CGContextSetRGBFillColor(context,  0.8, 0.0, 0.0, 1.0);//red
                        CGContextFillRect(context, CGRectMake(300 * (1 - (sqlite3_column_double(statement2, 2) * 1.0 / sqlite3_column_int(statement2, 0))), 0.0, 300 * (sqlite3_column_double(statement2, 2) * 1.0 / sqlite3_column_int(statement2, 0)), 20));
                        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        ExResult.backgroundColor = [UIColor colorWithPatternImage:resultingImage];
                        [self.view addSubview:ExResult];
                        _bottomBestResult = ExResult.frame;
                    } else {
                        
                    }
                } else {
                    UILabel *ExTriesTitle = [[UILabel alloc] initWithFrame: CGRectMake(10, 80, 300, 40)];
                    ExTriesTitle.numberOfLines = 2;
                    ExTriesTitle.text = [NSString stringWithFormat:@"   Попыток прохождения экзаменационного теста : 0\nУспешных \t\t\t\t\t\t  Неуспешных"];
                    ExTriesTitle.font = [UIFont italicSystemFontOfSize:11];
                    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                        [ExTriesTitle sizeToFit];
                    } else {
                        ExTriesTitle.textAlignment = NSTextAlignmentCenter;
                    }
                    [self.view addSubview:ExTriesTitle];
                    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                        NSString *stat = [NSString stringWithFormat:@" 0 \t\t\t\t\t\t\t\t\t 0 "];
                        UILabel *ExResult = [[UILabel alloc] initWithFrame: CGRectMake(10, 110, 300, 20)];
                        ExResult.text = stat;
                        ExResult.textColor = [UIColor whiteColor];
                        UIGraphicsBeginImageContext(CGSizeMake(300, 20));
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextSetRGBFillColor(context,  0.0, 0.8, 0.0, 1.0);//green
                        CGContextFillRect(context, CGRectMake(0.0, 0.0, 300 * 0.5, 20));
                        CGContextSetRGBFillColor(context,  0.8, 0.0, 0.0, 1.0);//red
                        CGContextFillRect(context, CGRectMake(300 * 0.5, 0.0, 300 * 0.5, 20));
                        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        ExResult.backgroundColor = [UIColor colorWithPatternImage:resultingImage];
                        [self.view addSubview:ExResult];
                        _bottomBestResult = ExResult.frame;
                    } else {
                        NSString *stat = [NSString stringWithFormat:@" 0 \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t 0 "];
                        UILabel *ExResult = [[UILabel alloc] initWithFrame: CGRectMake(10, 120, 300, 20)];
                        ExResult.text = stat;
                        ExResult.textAlignment = NSTextAlignmentCenter;
                        ExResult.textColor = [UIColor whiteColor];
                        UIGraphicsBeginImageContext(CGSizeMake(300, 20));
                        CGContextRef context = UIGraphicsGetCurrentContext();
                        CGContextSetRGBFillColor(context,  0.0, 0.8, 0.0, 1.0);//green
                        CGContextFillRect(context, CGRectMake(0.0, 0.0, 300 * 0.5, 20));
                        CGContextSetRGBFillColor(context,  0.8, 0.0, 0.0, 1.0);//red
                        CGContextFillRect(context, CGRectMake(300 * 0.5, 0.0, 300 * 0.5, 20));
                        UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        ExResult.backgroundColor = [UIColor colorWithPatternImage:resultingImage];
                        [self.view addSubview:ExResult];
                        _bottomBestResult = ExResult.frame;
                    }
                }
            }
            sqlite3_finalize(statement2);
        } else {
            NSLog(@"Ne mogu vypolnit' zapros #2!");
        }
        UILabel *ExBestResultTitle = [[UILabel alloc] initWithFrame: CGRectMake(0, _bottomBestResult.origin.y + 50, 300, 40)];
        ExBestResultTitle.textAlignment = NSTextAlignmentCenter;
        ExBestResultTitle.numberOfLines = 2;
        ExBestResultTitle.text = @"\tЛучшие результаты при прохождении экзамена\n   Ошибки     \t    Дата тестирования \t          Время ";
        ExBestResultTitle.font = [UIFont italicSystemFontOfSize:11];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            [ExBestResultTitle sizeToFit];
        }
        [self.view addSubview:ExBestResultTitle];
        NSString *querySQL3 = [NSString stringWithFormat:@"SELECT rightCount, finishDate, startDate FROM paper_ab_examen_stat ORDER BY rightCount DESC, (finishDate-startDate) LIMIT 5"];
        const char * query_stmt3 = [querySQL3 UTF8String];
        if (sqlite3_prepare_v2(_pdd_ab_stat, query_stmt3, -1, &statement3, NULL) == SQLITE_OK) {
            int i = 0;
            while (sqlite3_step(statement3) == SQLITE_ROW) {
                int timeDiff = sqlite3_column_int(statement3, 1) - sqlite3_column_int(statement3, 2);
                NSString *minutes = [NSString stringWithFormat:@"%d", timeDiff / 60];
                NSString *seconds = [NSString stringWithFormat:@"%d", timeDiff % 60];
                NSUInteger myMinute = [minutes intValue];
                NSUInteger mySecond = [seconds intValue];
                if (myMinute < 10) {
                    minutes = [NSString stringWithFormat:@"0%d", timeDiff / 60];
                }
                if (mySecond < 10) {
                    seconds = [NSString stringWithFormat:@"0%d", timeDiff % 60];
                }
                NSString *exTime =  [NSString stringWithFormat:@"%@ : %@", minutes, seconds];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(statement3, 1)];
                NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
                [date_formatter setDateFormat:@"dd MMMM YYYY"];
                NSString *result = [date_formatter stringFromDate:date];
                NSString *stat2 = [NSString stringWithFormat:@" %d\t     |\t\t %@\t | %@ ", 20 - sqlite3_column_int(statement3, 0), result, exTime];
                UILabel *exBestResults = [[UILabel alloc] initWithFrame: CGRectMake(10, _bottomBestResult.origin.y + 80 + (30 * i), 300, 20)];
                exBestResults.text = stat2;
                exBestResults.textColor = [UIColor blackColor];
                exBestResults.layer.borderColor = [UIColor blackColor].CGColor;
                exBestResults.layer.borderWidth = 1.0;
                [exBestResults sizeToFit];
                [self.view addSubview:exBestResults];
                i++;
            }
            sqlite3_finalize(statement3);
        } else {
            NSLog(@"Ne mogu vypolnit' zapros #3!");
        }
        sqlite3_close(_pdd_ab_stat);
    } else {
        NSLog(@"Ne mogu ustanovit' soedinenie!");
    }
}

- (IBAction)controlChanged:(id)sender {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0: {
            for (UIView *subview in [self.view subviews]) {
                [subview removeFromSuperview];
            }
            [self getBiletStatistics];
        }
            break;
        case 1: {
            for (UIView *subview in [self.view subviews]) {
                [subview removeFromSuperview];
            }
            [self getThemeStatistics];
        }
            break;
        case 2: {
            for (UIView *subview in [self.view subviews]) {
                [subview removeFromSuperview];
            }
            [self getExamenStatistics];
        }
            break;
    }
}

@end
