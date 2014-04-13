//
//  SignsListTableViewController.m
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 13.04.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "SignsListTableViewController.h"

@interface SignsListTableViewController ()

@end

@implementation SignsListTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"]];
    UILabel *labelback = [[UILabel alloc] init];
    [labelback setText:@"ПДД и знаки"];
    [labelback sizeToFit];
    int space = 6;
    labelback.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + space, labelback.frame.origin.y, labelback.frame.size.width, labelback.frame.size.height);
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
    _signsNames = @[@"Предупреждающие знаки",
                    @"Знаки приоритета",
                    @"Запрещающие знаки",
                    @"Предписывающие знаки",
                    @"Знаки особых предписаний",
                    @"Информационные знаки",
                    @"Знаки сервиса",
                    @"Знаки дополнительной информации"];
    self.tableView.tableFooterView = [UIView new];
}

- (void)confirmCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_signsNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"signListCell" forIndexPath:indexPath];
    long row = [indexPath row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@", row + 1, _signsNames[row]];
    cell.textLabel.font = [UIFont systemFontOfSize:17.0f];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = backView;
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          cell.textLabel.font, NSFontAttributeName,
                                          nil];
    CGRect textLabelSize = [cell.textLabel.text boundingRectWithSize:kLabelFrameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
    cell.textLabel.frame = CGRectMake(5, 5, textLabelSize.size.width, textLabelSize.size.height);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    long row = [indexPath row];
    NSString *textLabel = [NSString stringWithFormat:@"%ld. %@", row + 1, _signsNames[row]];
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize:17.0f], NSFontAttributeName,
                                          nil];
    CGRect textLabelSize = [textLabel boundingRectWithSize:kLabelFrameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
    
    return kExamenDifference + textLabelSize.size.height;
}

@end
