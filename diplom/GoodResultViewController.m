//
//  GoodResultViewController.m
//  diplom
//
//  Created by Sergey Kiselev on 31.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "GoodResultViewController.h"

@interface GoodResultViewController ()

@end

@implementation GoodResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"]];
    UILabel *labelback = [[UILabel alloc] init];
    if (_whichController == 0)
        [labelback setText:@"К списку билетов"];
    else [labelback setText:@"В меню"];
    [labelback sizeToFit];
    int space = 6;
    labelback.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + space, labelback.frame.origin.y, labelback.frame.size.width, labelback.frame.size.height);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, labelback.frame.size.width + imageView.frame.size.width + space, imageView.frame.size.height)];
    view.bounds = CGRectMake(view.bounds.origin.x + 8, view.bounds.origin.y - 1, view.bounds.size.width, view.bounds.size.height);
    [view addSubview:imageView];
    [view addSubview:labelback];
    UIButton *button = [[UIButton alloc] initWithFrame:view.frame];
    if (_whichController == 0)
        [button addTarget:self action:@selector(backToBiletList) forControlEvents:UIControlEventTouchUpInside];
    else [button addTarget:self action:@selector(backToMenu) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveLinear animations:^ {
        labelback.alpha = 0.0;
        CGRect orig = labelback.frame;
        labelback.frame = CGRectMake(labelback.frame.origin.x + 25, labelback.frame.origin.y, labelback.frame.size.width, labelback.frame.size.height);
        labelback.alpha = 1.0;
        labelback.frame = orig;
    } completion:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = backButton;
    UIImage *image = [UIImage imageNamed:@"cars.png"];
    [_imageGood.layer setBorderColor:[[UIColor greenColor] CGColor]];
    [_imageGood.layer setBorderWidth:2.0];
    [_imageGood setImage:image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backToBiletList {
    [self performSegueWithIdentifier:@"backToBiletList" sender:self];
}

- (void)backToMenu {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
