//
//  LinesDetailViewController.h
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 13.04.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinesDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *linesWebView;
@property (strong, nonatomic) NSString *lineDetailModel;
@property (strong, nonatomic) NSString *lineName;

@end
