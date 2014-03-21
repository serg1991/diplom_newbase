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
        // Custom initialization
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_ruleNumbers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ruleListCell" forIndexPath:indexPath];
        long row = [indexPath row];
    
    // Configure the cell...
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
        
        detailViewController.ruleDetailModel = _ruleDetail[row];
        
        NSString *result = [NSString stringWithFormat:@"%ld. %@", row + 1, _ruleNumbers[row]];
        detailViewController.ruleName = result;
    }
}

@end
