//
//  RulesListTableViewController.m
//  diplom
//
//  Created by Sergey Kiselev on 31.01.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "RulesListTableViewController.h"
#import "RulesDetailViewController.h"

@interface RulesListTableViewController ()

@end

@implementation RulesListTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    _ruleNumbers = @[@"Общие положения",
                     @"Общие обязанности водителей",
                     @"Применение специальных сигналов",
                     @"Обязаности пешеходов",
                     @"Обязанности пассажиров",
                     @"Сигналы светофора и регулировщика",
                     @"Применение аварийной сигнализации и \nзнака аварийной остановки",
                     @"Начало движения, маневрирование",
                     @"Расположение транспортных средств \nна проезжей части",
                     @"Скорость движения",
                     @"Обгон, опережение и \nвстречный разъезд",
                     @"Остановка и стоянка",
                     @"Проезд перекрестков",
                     @"Пешеходные переходы и \nместа остановок маршрутных \nтранспортных средств",
                     @"Движение через \nжелезнодорожные пути",
                     @"Движение по автомагистралям",
                     @"Движение в жилых зонах",
                     @"Приоритет маршрутных \nтранспортных средств",
                     @"Пользование внешними световыми приборами и звуковыми сигналами",
                     @"Буксировка механических \nтранспортных средств",
                     @"Учебная езда",
                     @"Перевозка людей",
                     @"Перевозка грузов",
                     @"Дополнительные требования к движению велосипедистов, мопедов, гужевых повозок, \nа также прогону животных"];
    _ruleDetail = @[@"pdd1",
                    @"pdd2",
                    @"pdd3",
                    @"pdd4",
                    @"pdd5",
                    @"pdd6",
                    @"pdd7",
                    @"pdd8",
                    @"pdd9",
                    @"pdd10",
                    @"pdd11",
                    @"pdd12",
                    @"pdd13",
                    @"pdd14",
                    @"pdd15",
                    @"pdd16",
                    @"pdd17",
                    @"pdd18",
                    @"pdd19",
                    @"pdd20",
                    @"pdd21",
                    @"pdd22",
                    @"pdd23",
                    @"pdd24"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"]];
    UILabel *labelback = [[UILabel alloc] init];
    [labelback setText:@"Меню"];
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
}

- (void)confirmCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_ruleNumbers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ruleListCell" forIndexPath:indexPath];
    long row = [indexPath row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@", row + 1, _ruleNumbers[row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [[_ruleNumbers objectAtIndex:indexPath.row]
                   sizeWithFont:[UIFont systemFontOfSize:18]
                   constrainedToSize:CGSizeMake(263, CGFLOAT_MAX)];
    double commonsize = size.height + 14;
    if (commonsize < 43) {
        commonsize = 44.0;
    }
    else if (commonsize < 57) {
        commonsize = 66.0;
    }
    else if (commonsize > 66 && commonsize < 79) {
        commonsize = 88.0;
    }
    else {
        commonsize = 132.0;
    }
    
    return commonsize;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showRuleDetails"]) {
        RulesDetailViewController *detailViewController = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        long row = [myIndexPath row];
        detailViewController.ruleDetailModel  = [NSString stringWithFormat:@"%@", _ruleDetail[row]];
        NSString *result = [NSString stringWithFormat:@"%ld. %@", row + 1, _ruleNumbers[row]];
        detailViewController.ruleName = result;
    }
}

@end