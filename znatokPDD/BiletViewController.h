//
//  BiletViewController.h
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 29.01.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiletChildViewController.h"
#import "PageControl.h"

@interface BiletViewController : UIViewController

@property (strong, nonatomic) UIPageViewController *pageController;
@property (nonatomic) NSUInteger biletNumber;
@property (nonatomic, retain) NSMutableArray *rightArray;
@property (nonatomic, retain) NSMutableArray *wrongArray;
@property (nonatomic, retain) NSMutableArray *wrongSelectedArray;
@property (nonatomic) NSTimeInterval startDate;
@property (nonatomic) int currentIndex;
@property (nonatomic) PageControl *pageControl;

@end