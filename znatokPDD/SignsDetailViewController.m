//
//  SignsDetailViewController.m
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 13.04.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "SignsDetailViewController.h"

@interface SignsDetailViewController ()

@end

@implementation SignsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"]];
        UILabel *labelback = [[UILabel alloc] init];
        [labelback setText:@"Знаки"];
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            labelback.font = [UIFont systemFontOfSize:30.0f];
        }
        [labelback sizeToFit];
        int space = 6;
        labelback.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + space, labelback.frame.origin.y, labelback.frame.size.width, labelback.frame.size.height);
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            labelback.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + space, labelback.frame.origin.y - 8, labelback.frame.size.width, labelback.frame.size.height);
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, labelback.frame.size.width + imageView.frame.size.width + space, imageView.frame.size.height)];
        view.bounds = CGRectMake(view.bounds.origin.x + 8, view.bounds.origin.y - 1, view.bounds.size.width, view.bounds.size.height);
        [view addSubview:imageView];
        [view addSubview:labelback];
        UIButton *button = [[UIButton alloc] initWithFrame:view.frame];
        [button addTarget:self action:@selector(confirmCancel) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            labelback.alpha = 0.0;
            CGRect orig = labelback.frame;
            labelback.frame = CGRectMake(labelback.frame.origin.x + 25, labelback.frame.origin.y, labelback.frame.size.width, labelback.frame.size.height);
            labelback.alpha = 1.0;
            labelback.frame = orig;
        } completion:nil];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:view];
        self.navigationItem.leftBarButtonItem = backButton;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:12.0f];
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            label.font = [UIFont systemFontOfSize:30.0f];
        }
        label.text = _signName;
        self.navigationItem.titleView = label;
    } else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor whiteColor];
        label.text = _signName;
        label.backgroundColor = [UIColor clearColor];
        self.navigationItem.titleView = label;
    }
    NSURL *htmlFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_signDetailModel ofType:@"html"]];
    [_signWebView loadRequest:[NSURLRequest requestWithURL:htmlFile]];
    
}

- (void)confirmCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
