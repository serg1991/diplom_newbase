//
//  StatisticsViewController.m
//  diplom
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
    NSDictionary *options = (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) ? [NSDictionary dictionaryWithObject: [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid] forKey: UIPageViewControllerOptionSpineLocationKey] : nil;
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    StatisticsChildViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 22)];
    label.font = [UIFont systemFontOfSize: 18.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Статистика";
    self.navigationItem.titleView = label;
    
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
    trashButton.frame = CGRectMake(0, 0, 22, 22);
    [trashButton addTarget:self action:@selector(confirmReset) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *trashIconButton = [[UIBarButtonItem alloc]initWithCustomView:trashButton];
    self.navigationItem.rightBarButtonItem = trashIconButton;
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
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement1, *statement2, *statement3;
        if (sqlite3_open(dbpath, &_pdd_ab_stat) == SQLITE_OK) {
            NSString *querySQL1 = [NSString stringWithFormat:@"Delete from paper_ab_stat"];
            const char *query_stmt1 = [querySQL1 UTF8String];
            
            if (sqlite3_prepare_v2(_pdd_ab_stat, query_stmt1, -1, &statement1, NULL) == SQLITE_OK) {
                NSLog(@"Removed all data from paper_ab_stat OK!");
            }
            else {
                NSLog(@"Removed all data from paper_ab_stat not OK!");
            }
            sqlite3_finalize(statement1);
            
            NSString *querySQL2 = [NSString stringWithFormat:@"Delete from paper_ab_theme_stat"];
            const char *query_stmt2 = [querySQL2 UTF8String];
            
            if (sqlite3_prepare_v2(_pdd_ab_stat, query_stmt2, -1, &statement2, NULL) == SQLITE_OK) {
                NSLog(@"Removed all data from paper_ab_theme_stat OK!");
            }
            else {
                NSLog(@"Removed all data from paper_ab_theme_stat not OK!");
            }
            sqlite3_finalize(statement2);
            
            NSString *querySQL3 = [NSString stringWithFormat:@"Delete from paper_ab_examen_stat"];
            const char *query_stmt3 = [querySQL3 UTF8String];
            
            if (sqlite3_prepare_v2(_pdd_ab_stat, query_stmt3, -1, &statement3, NULL) == SQLITE_OK) {
                NSLog(@"Removed all data from paper_ab_examen_stat OK!");
            }
            else {
                NSLog(@"Removed all data from paper_ab_examen_stat not OK!");
            }
            sqlite3_finalize(statement3);
            sqlite3_close(_pdd_ab_stat);
        }
    }
    else {
        NSLog(@"Mozhno bylo i ne nazhimat' togda!");
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
    // Dispose of any resources that can be recreated.
}

- (StatisticsChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    StatisticsChildViewController *childViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StatisticsChildViewController"];
    childViewController.index = index;
    
    return childViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [(StatisticsChildViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [(StatisticsChildViewController *)viewController index];
    index++;
    if (index == 3)
        
        return nil;
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    
    return 0;
}

@end
