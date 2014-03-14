//
//  RulesDetailViewController.m
//  diplom
//
//  Created by Sergey Kiselev on 01.02.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "RulesDetailViewController.h"

@interface RulesDetailViewController ()

@end

@implementation RulesDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize: 10.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = _ruleName;
    
    self.navigationItem.titleView = label;

    NSURL *htmlFile = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_ruleDetailModel[0] ofType:@"html"]];
    [_rulesWebView loadRequest:[NSURLRequest requestWithURL:htmlFile]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
