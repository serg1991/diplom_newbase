//
//  ResultViewController.h
//  diplom
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
@property (nonatomic, retain) NSMutableArray *themeName;
@property (nonatomic, strong) NSArray *shareItems;
@property (nonatomic, strong) NSString *timeString;

@end
