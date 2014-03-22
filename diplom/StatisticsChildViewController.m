//
//  StatisticsChildViewController.m
//  diplom
//
//  Created by Sergey Kiselev on 23.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "StatisticsChildViewController.h"

@interface StatisticsChildViewController ()

@end

@implementation StatisticsChildViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _label.text = [NSString stringWithFormat:@"%d", _index + 1];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
