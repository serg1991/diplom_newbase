//
//  BiletChildViewController.h
//  diplom
//
//  Created by Sergey Kiselev on 29.01.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <sqlite3.h>

@interface BiletChildViewController : UIViewController

@property (assign, nonatomic) NSUInteger index;
@property (nonatomic) sqlite3 *pdd_ab;
@property (nonatomic) sqlite3 *pdd_ab_stat;
@property (weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) NSUInteger biletNumber;
@property (nonatomic, retain) NSMutableArray *rightAnswersArray;
@property (nonatomic, retain) NSMutableArray *wrongAnswersSelectedArray;
@property (nonatomic, retain) NSMutableArray *wrongAnswersArray;
@property (nonatomic, retain) NSString *startDate;

@end
