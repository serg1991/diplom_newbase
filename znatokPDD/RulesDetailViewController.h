//
//  RulesDetailViewController.h
//  diplom
//
//  Created by Sergey Kiselev on 01.02.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RulesDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *rulesWebView;
@property (strong, nonatomic) NSString *ruleDetailModel;
@property (strong, nonatomic) NSString *ruleName;

@end
