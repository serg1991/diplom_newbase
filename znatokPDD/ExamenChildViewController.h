//
//  ExamenChildViewController.h
//  diplom
//
//  Created by Sergey Kiselev on 20.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <sqlite3.h>
#import "ResultViewController.h"

@interface ExamenChildViewController : UIViewController

@property (assign, nonatomic) NSUInteger index;
@property (nonatomic) sqlite3 *pdd_ab;
@property (nonatomic) sqlite3 *pdd_ab_stat;
@property (weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) NSMutableArray *rightAnswersArray;
@property (nonatomic, retain) NSMutableArray *wrongAnswersSelectedArray;
@property (nonatomic, retain) NSMutableArray *wrongAnswersArray;
@property (nonatomic, retain) NSMutableArray *randomNumbers;
@property (nonatomic) NSTimeInterval startDate;
@property (nonatomic) NSTimeInterval finishDate;
@property (nonatomic, retain) NSTimer *timer;
@property (assign, nonatomic) NSUInteger remainingTicks;

@end
