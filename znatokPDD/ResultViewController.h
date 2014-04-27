//
//  ResultViewController.h
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 31.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "ExamenViewController.h"
#import "Reachability.h"
#import "VKontakteActivity.h"

@interface ResultViewController : UIViewController

@property (nonatomic) int type;
@property (nonatomic) int rightCount;
@property (nonatomic) int themeCommon;
@property (nonatomic) int themeNumber;
@property (nonatomic) int time;
@property (nonatomic) int biletNumber;
@property (nonatomic, retain) NSMutableArray *themeName;
@property (nonatomic, strong) NSArray *shareItems;
@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, strong) NSString *backlabel;
@property (weak, nonatomic) IBOutlet UIImageView *resultImage;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightCountImage;
@property (weak, nonatomic) IBOutlet UILabel *rightCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *reloadImage;
@property (weak, nonatomic) IBOutlet UILabel *reloadLabel;

@end
