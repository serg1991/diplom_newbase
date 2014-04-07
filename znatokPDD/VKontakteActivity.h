//
//  VKontakteActivity.h
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 07.04.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKAPI/sdk/vksdk.h"
#import "MBProgressHUD.h"

@interface VKontakteActivity : UIActivity <VKSdkDelegate>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, strong) UIViewController *parent;
@property (nonatomic, strong) MBProgressHUD *HUD;

- (id)initWithParent:(UIViewController *)parent;

@end
