//
//  ExamenViewController.h
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 20.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamenChildViewController.h"
#import "PageControl.h"

@interface ExamenViewController : UIViewController {

@private
    int remainingTicks;
}

@property (strong, nonatomic) UIPageViewController *pageController;
@property (nonatomic, retain) NSMutableArray *rightArray;
@property (nonatomic, retain) NSMutableArray *wrongArray;
@property (nonatomic, retain) NSMutableArray *wrongSelectedArray;
@property (nonatomic, retain) NSMutableArray *randomNumbers;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic) NSTimeInterval startDate;
@property (nonatomic, retain) UILabel *theLabel;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic) int currentIndex;
@property (nonatomic) PageControl *pageControl;

- (void)handleTimerTick;
- (void)updateLabel;

@end
