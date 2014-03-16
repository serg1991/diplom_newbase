//
//  BiletListTableViewController.m
//  diplom
//
//  Created by Sergey Kiselev on 29.01.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "BiletListTableViewController.h"

@interface BiletListTableViewController ()

@end

@implementation BiletListTableViewController

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
    
    _biletNumbers = @[@"Билет №1",
                      @"Билет №2",
                      @"Билет №3",
                      @"Билет №4",
                      @"Билет №5",
                      @"Билет №6",
                      @"Билет №7",
                      @"Билет №8",
                      @"Билет №9",
                      @"Билет №10",
                      @"Билет №11",
                      @"Билет №12",
                      @"Билет №13",
                      @"Билет №14",
                      @"Билет №15",
                      @"Билет №16",
                      @"Билет №17",
                      @"Билет №18",
                      @"Билет №19",
                      @"Билет №20",
                      @"Билет №21",
                      @"Билет №22",
                      @"Билет №23",
                      @"Билет №24",
                      @"Билет №25",
                      @"Билет №26",
                      @"Билет №27",
                      @"Билет №28",
                      @"Билет №29",
                      @"Билет №30",
                      @"Билет №31",
                      @"Билет №32",
                      @"Билет №33",
                      @"Билет №34",
                      @"Билет №35",
                      @"Билет №36",
                      @"Билет №37",
                      @"Билет №38",
                      @"Билет №39",
                      @"Билет №40"];
    _biletRecords = @[@"",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" ",
                      @" "];
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
    return _biletNumbers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"biletListCell" forIndexPath:indexPath];
    long row = [indexPath row];
    NSString *record = [NSString stringWithFormat:@"Рекорд: %@ из 20", _biletRecords[row]];

    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _biletNumbers[row];
    cell.detailTextLabel.text = record;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showBiletDetails"]) {
        NSMutableArray *rightArray = [[NSMutableArray alloc] init];
        NSMutableArray *wrongArray = [[NSMutableArray alloc] init];
        
        APPViewController *detailViewController = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        long row = [myIndexPath row];
        detailViewController.biletNumber = row;
        detailViewController.wrongArray = wrongArray;
        detailViewController.rightArray = rightArray;
    }
}

@end
