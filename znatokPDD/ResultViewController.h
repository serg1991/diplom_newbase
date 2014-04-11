//
//  ResultViewController.h
//  diplom
//
//  Created by Sergey Kiselev on 31.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "VKontakteActivity.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "ExamenViewController.h"

@interface ResultViewController : UIViewController

@property (nonatomic) bool examen;
@property (nonatomic) int rightCount;
@property (nonatomic) int time;
@property (nonatomic, strong) NSArray *shareItems;
@property (nonatomic, strong) NSString *timeString;

@end
