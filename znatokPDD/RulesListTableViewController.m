//
//  RulesListTableViewController.m
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 31.01.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "RulesListTableViewController.h"

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
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"]];
        UILabel *labelback = [[UILabel alloc] init];
        [labelback setText:@"ПДД и знаки"];
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            labelback.font = [UIFont systemFontOfSize:30.0f];
        }
        [labelback sizeToFit];
        int space = 6;
        labelback.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + space, labelback.frame.origin.y, labelback.frame.size.width, labelback.frame.size.height);
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            labelback.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + space, labelback.frame.origin.y - 9, labelback.frame.size.width, labelback.frame.size.height);
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
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            UILabel *bigLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 30)];
            bigLabel.text = @"Правила дорожного движения";
            bigLabel.font = [UIFont systemFontOfSize:30.0];
            self.navigationItem.titleView = bigLabel;
        }
    }
    _ruleNumbers = @[@"Общие положения",
                     @"Общие обязанности водителей",
                     @"Применение специальных сигналов",
                     @"Обязаности пешеходов",
                     @"Обязанности пассажиров",
                     @"Сигналы светофора и регулировщика",
                     @"Применение аварийной сигнализации и знака аварийной остановки",
                     @"Начало движения, маневрирование",
                     @"Расположение транспортных средств на проезжей части",
                     @"Скорость движения",
                     @"Обгон, опережение и встречный разъезд",
                     @"Остановка и стоянка",
                     @"Проезд перекрестков",
                     @"Пешеходные переходы и места остановок маршрутных транспортных средств",
                     @"Движение через железнодорожные пути",
                     @"Движение по автомагистралям",
                     @"Движение в жилых зонах",
                     @"Приоритет маршрутных транспортных средств",
                     @"Пользование внешними световыми приборами и звуковыми сигналами",
                     @"Буксировка механических транспортных средств",
                     @"Учебная езда",
                     @"Перевозка людей",
                     @"Перевозка грузов",
                     @"Дополнительные требования к движению велосипедистов и водителей мопедов",
                     @"Дополнительные требования к движению гужевых повозок, а также прогону животных"];
    _ruleDetail = @[@"/www/pdd1",
                    @"/www/pdd2",
                    @"/www/pdd3",
                    @"/www/pdd4",
                    @"/www/pdd5",
                    @"/www/pdd6",
                    @"/www/pdd7",
                    @"/www/pdd8",
                    @"/www/pdd9",
                    @"/www/pdd10",
                    @"/www/pdd11",
                    @"/www/pdd12",
                    @"/www/pdd13",
                    @"/www/pdd14",
                    @"/www/pdd15",
                    @"/www/pdd16",
                    @"/www/pdd17",
                    @"/www/pdd18",
                    @"/www/pdd19",
                    @"/www/pdd20",
                    @"/www/pdd21",
                    @"/www/pdd22",
                    @"/www/pdd23",
                    @"/www/pdd24",
                    @"/www/pdd25"];
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
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:18.0f];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = backView;
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          cell.textLabel.font, NSFontAttributeName,
                                          nil];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        cell.textLabel.font = [UIFont systemFontOfSize:30.0f];
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              cell.textLabel.font, NSFontAttributeName,
                                              nil];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            CGRect textLabelSize = [cell.textLabel.text boundingRectWithSize:kLabelIpadFrameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
            cell.textLabel.frame = CGRectMake(5, 5, textLabelSize.size.width, textLabelSize.size.height);
            return cell;
        } else {
            CGSize textLabelSize = [cell.textLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:30.0f]
                                                   constrainedToSize:kLabelIpadFrameMaxSize
                                                       lineBreakMode:NSLineBreakByWordWrapping];
            cell.textLabel.frame = CGRectMake(5, 5, textLabelSize.width, textLabelSize.height);
            return cell;
        }
    } else {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            CGRect textLabelSize = [cell.textLabel.text boundingRectWithSize:kLabelFrameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
            cell.textLabel.frame = CGRectMake(5, 5, textLabelSize.size.width, textLabelSize.size.height);
            return cell;
        } else {
            CGSize textLabelSize = [cell.textLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0f]
                                                   constrainedToSize:kLabelFrameMaxSize
                                                       lineBreakMode:NSLineBreakByWordWrapping];
            cell.textLabel.frame = CGRectMake(5, 5, textLabelSize.width, textLabelSize.height);
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    long row = [indexPath row];
    NSString *textLabel = [NSString stringWithFormat:@"%ld. %@", row + 1, _ruleNumbers[row]];
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIFont systemFontOfSize:18.0f], NSFontAttributeName,
                                          nil];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont systemFontOfSize:30.0f], NSFontAttributeName,
                                              nil];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            CGRect textLabelSize = [textLabel boundingRectWithSize:kLabelIpadFrameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
            return kExamenDifference + textLabelSize.size.height;
        } else {
            CGSize textLabelSize = [textLabel sizeWithFont:[UIFont fontWithName:@"Helvetica" size:30.0f]
                                         constrainedToSize:kExamenLabelIpadFrameMaxSize
                                             lineBreakMode:NSLineBreakByWordWrapping];
            return kExamenDifference + textLabelSize.height;
        }
    } else {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            CGRect textLabelSize = [textLabel boundingRectWithSize:kLabelFrameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
            return kExamenDifference + textLabelSize.size.height - 4;
        } else {
            CGSize textLabelSize = [textLabel sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0f]
                                         constrainedToSize:kExamenLabelFrameMaxSize
                                             lineBreakMode:NSLineBreakByWordWrapping];
            return kExamenDifference + textLabelSize.height - 4;
        }
    }
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
