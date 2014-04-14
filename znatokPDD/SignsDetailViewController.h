//
//  SignsDetailViewController.h
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 13.04.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignsDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *signWebView;
@property (strong, nonatomic) NSString *signDetailModel;
@property (strong, nonatomic) NSString *signName;

@end
