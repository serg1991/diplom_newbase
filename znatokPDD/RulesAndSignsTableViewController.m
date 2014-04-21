//
//  RulesAndSignsTableViewController.m
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 13.04.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "RulesAndSignsTableViewController.h"

@interface RulesAndSignsTableViewController ()

@end

@implementation RulesAndSignsTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"]];
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"Меню"];
    [label sizeToFit];
    int space = 6;
    label.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + space, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
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
    } else {
        UIButton *customBackButton = [UIButton buttonWithType:101];
        [customBackButton setTitle:@"Меню" forState:UIControlStateNormal];
        [customBackButton addTarget:self
                             action:@selector(confirmCancel) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *myBackButton = [[UIBarButtonItem alloc] initWithCustomView:customBackButton];
        [self.navigationItem setLeftBarButtonItem:myBackButton];
    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)confirmCancel {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showHorizontalLines"]) {
        LinesDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.lineDetailModel  = @"/www/razgoriz";
        detailViewController.lineName = @"Горизонтальная разметка";
    }
    if ([[segue identifier] isEqualToString:@"showVerticalLines"]) {
        LinesDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.lineDetailModel  = @"/www/razvert";
        detailViewController.lineName = @"Вертикальная разметка";
    }
}

@end
