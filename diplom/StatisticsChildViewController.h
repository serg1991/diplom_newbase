//
//  StatisticsChildViewController.h
//  diplom
//
//  Created by Sergey Kiselev on 23.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface StatisticsChildViewController : UIViewController

@property (assign, nonatomic) NSUInteger index;
@property (nonatomic) sqlite3 *pdd_ab_stat;

@end
