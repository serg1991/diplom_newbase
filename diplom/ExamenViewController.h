//
//  ExamenViewController.h
//  diplom
//
//  Created by Sergey Kiselev on 20.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamenChildViewController.h"
#import "AppDelegate.h"

@interface ExamenViewController : UIViewController <UIPageViewControllerDataSource>
{
    UILabel *theLabel;
    
@private
    int remainingTicks;
}

@property (strong, nonatomic) UIPageViewController *pageController;
@property (nonatomic, retain) NSMutableArray *rightArray;
@property (nonatomic, retain) NSMutableArray *wrongArray;
@property (nonatomic, retain) NSMutableArray *wrongSelectedArray;
@property (nonatomic, retain) NSMutableArray *randomNumbers;
@property (nonatomic, retain) NSString *dateString;
@property (nonatomic, retain) IBOutlet UILabel *theLabel;
@property (nonatomic, retain) NSTimer *timer;

- (void)handleTimerTick;
- (void)updateLabel;

@end
