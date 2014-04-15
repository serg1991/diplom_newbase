//
//  ViewController.h
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 26.01.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamenViewController.h"
#import <sqlite3.h>

@interface ViewController : UIViewController

@property (nonatomic) sqlite3 *pdd_ab_stat;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UIImageView *image5;
@property (weak, nonatomic) IBOutlet UIImageView *image6;

@end
