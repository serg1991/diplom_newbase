//
//  StatisticsViewController.h
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 23.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface StatisticsViewController : UIViewController

@property (nonatomic) sqlite3 *pdd_ab_stat;
@property (nonatomic, assign) CGRect bottomBestResult;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)controlChanged:(id)sender;

@end
