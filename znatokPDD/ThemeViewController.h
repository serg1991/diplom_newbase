//
//  ThemeViewController.h
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 29.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeChildViewController.h"
#import "PageControl.h"

@interface ThemeViewController : UIViewController

@property (strong, nonatomic) UIPageViewController *pageController;
@property (nonatomic) NSUInteger themeNumber;
@property (nonatomic, retain) NSMutableArray *rightArray;
@property (nonatomic, retain) NSMutableArray *wrongArray;
@property (nonatomic, retain) NSMutableArray *wrongSelectedArray;
@property (nonatomic, retain) NSMutableArray *themeCount;
@property (nonatomic, retain) NSMutableArray *themeName;
@property (nonatomic) NSTimeInterval startDate;
@property (nonatomic) int currentIndex;
@property (nonatomic) PageControl *pageControl;

@end
