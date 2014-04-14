//
//  StatisticsViewController.h
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 23.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatisticsChildViewController.h"

@interface StatisticsViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (nonatomic) sqlite3 *pdd_ab_stat;

@end
