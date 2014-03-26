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
    
    if (_index == 0) {
        _label.text = [NSString stringWithFormat:@"%u", _index + 1];
    }
    else {
        _label.text = [NSString stringWithFormat:@"%u ololo", _index + 1];
    }
}
//    [self.tableView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
//}
//
//- (void)dealloc {
//    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    CGRect frame = self.tableView.frame;
//    frame.size = self.tableView.contentSize;
//    self.tableView.frame = frame;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
