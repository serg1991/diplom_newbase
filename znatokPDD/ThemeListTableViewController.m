//
//  ThemeListTableViewController.m
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 29.01.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "ThemeListTableViewController.h"

@interface ThemeListTableViewController ()

@end

@implementation ThemeListTableViewController

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
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            labelback.font = [UIFont systemFontOfSize:30.0f];
        }
        [labelback setText:@"Меню"];
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
            bigLabel.text = @"Темы";
            bigLabel.font = [UIFont systemFontOfSize:30.0];
            self.navigationItem.titleView = bigLabel;
        }
    } else {
        UIButton *customBackButton = [UIButton buttonWithType:101];
        [customBackButton setTitle:@"Меню" forState:UIControlStateNormal];
        [customBackButton addTarget:self
                             action:@selector(confirmCancel) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *myBackButton = [[UIBarButtonItem alloc] initWithCustomView:customBackButton];
        [self.navigationItem setLeftBarButtonItem:myBackButton];
    }
    [self getThemeNameCount];
}

- (void)getThemeNameCount {
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"pdd.sqlite"];
    const char * dbpath = [defaultDBPath UTF8String];
    sqlite3_stmt *statement, *statement2;
    _themeTheme = [[NSMutableArray alloc] init];
    _themeQuestionNumber = [[NSMutableArray alloc] init];
    if (sqlite3_open(dbpath, &_pdd) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ThemeName from paper_ab_themes"];
        const char * query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_pdd, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *arrayelement = [[NSString alloc]
                                          initWithUTF8String:
                                          (const char *) sqlite3_column_text(statement, 0)];
                [_themeTheme addObject:arrayelement];
            }
        }
        sqlite3_finalize(statement);
        NSString *querySQL2 = [NSString stringWithFormat:@"SELECT COUNT(*) FROM paper_ab GROUP BY QuestionType"];
        const char * query_stmt2 = [querySQL2 UTF8String];
        if (sqlite3_prepare_v2(_pdd, query_stmt2, -1, &statement2, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement2) == SQLITE_ROW) {
                NSNumber *arrayelement = [NSNumber numberWithInt:sqlite3_column_int(statement2, 0)];
                [_themeQuestionNumber addObject:arrayelement];
            }
        }
        sqlite3_finalize(statement2);
    }
    sqlite3_close(_pdd);
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
    return [_themeTheme count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"themeListCell"];
    long row = [indexPath row];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@", row + 1, _themeTheme[row]];
        cell.textLabel.font = [UIFont systemFontOfSize:30.0f];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Вопросов : %@", _themeQuestionNumber[row]];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:18.0f];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = backView;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIFont systemFontOfSize:30.0f], NSFontAttributeName,
                                                  nil];
            NSDictionary *attributesDictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIFont systemFontOfSize:18.0f], NSFontAttributeName,
                                                   nil];
            CGRect textLabelSize = [cell.textLabel.text boundingRectWithSize:kLabelIpadFrameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
            cell.textLabel.frame = CGRectMake(5, 5, textLabelSize.size.width, textLabelSize.size.height);
            CGRect detailTextLabelSize = [cell.detailTextLabel.text boundingRectWithSize:kLabelIpadFrameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary2 context:nil];
            cell.detailTextLabel.frame = CGRectMake(5, 5, detailTextLabelSize.size.width, detailTextLabelSize.size.height);
            return cell;
        } else {
            CGSize textLabelSize = [cell.textLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:30.0f]
                                                   constrainedToSize:kExamenLabelIpadFrameMaxSize
                                                       lineBreakMode:NSLineBreakByWordWrapping];
            cell.textLabel.frame = CGRectMake(5, 5, textLabelSize.width, textLabelSize.height);
            CGSize detailTextLabelSize = [cell.detailTextLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0f]
                                                               constrainedToSize:kExamenLabelIpadFrameMaxSize
                                                                   lineBreakMode:NSLineBreakByWordWrapping];
            cell.detailTextLabel.frame = CGRectMake(5, 5, detailTextLabelSize.width, detailTextLabelSize.height);
            return cell;
        }
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@", row + 1, _themeTheme[row]];
        cell.textLabel.font = [UIFont systemFontOfSize:17.0f];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Вопросов : %@", _themeQuestionNumber[row]];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = backView;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  cell.textLabel.font, NSFontAttributeName,
                                                  nil];
            NSDictionary *attributesDictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   cell.detailTextLabel.font, NSFontAttributeName,
                                                   nil];
            CGRect textLabelSize = [cell.textLabel.text boundingRectWithSize:kLabelFrameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
            cell.textLabel.frame = CGRectMake(5, 5, textLabelSize.size.width, textLabelSize.size.height);
            CGRect detailTextLabelSize = [cell.detailTextLabel.text boundingRectWithSize:kLabelFrameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary2 context:nil];
            cell.detailTextLabel.frame = CGRectMake(5, 5, detailTextLabelSize.size.width, detailTextLabelSize.size.height);
            return cell;
        } else {
            CGSize textLabelSize = [cell.textLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0f]
                                                   constrainedToSize:kExamenLabelFrameMaxSize
                                                       lineBreakMode:NSLineBreakByWordWrapping];
            cell.textLabel.frame = CGRectMake(5, 5, textLabelSize.width, textLabelSize.height);
            CGSize detailTextLabelSize = [cell.detailTextLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0f]
                                                               constrainedToSize:kExamenLabelFrameMaxSize
                                                                   lineBreakMode:NSLineBreakByWordWrapping];
            cell.detailTextLabel.frame = CGRectMake(5, 5, detailTextLabelSize.width, detailTextLabelSize.height);
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    long row = [indexPath row];
    NSString *textLabel = [NSString stringWithFormat:@"%ld. %@", row + 1, _themeTheme[row]];
    NSString *detailTextLabel = [NSString stringWithFormat:@"Вопросов : %@", _themeQuestionNumber[row]];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIFont systemFontOfSize:30.0f], NSFontAttributeName,
                                                  nil];
            NSDictionary *attributesDictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIFont systemFontOfSize:18.0f], NSFontAttributeName,
                                                   nil];
            CGRect textLabelSize = [textLabel boundingRectWithSize:kLabelIpadFrameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
            CGRect detailTextLabelSize = [detailTextLabel boundingRectWithSize:kLabelIpadFrameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary2 context:nil];
            return kListDifference + textLabelSize.size.height + detailTextLabelSize.size.height;
        } else {
            CGSize textLabelSize = [textLabel sizeWithFont:[UIFont fontWithName:@"Helvetica" size:30.0f]
                                         constrainedToSize:kExamenLabelIpadFrameMaxSize
                                             lineBreakMode:NSLineBreakByWordWrapping];
            CGSize detailTextLabelSize = [detailTextLabel sizeWithFont:[UIFont fontWithName:@"Helvetica" size:18.0f]
                                                     constrainedToSize:kExamenLabelFrameMaxSize
                                                         lineBreakMode:NSLineBreakByWordWrapping];
            return kListDifference + textLabelSize.height + detailTextLabelSize.height;
        }
    } else {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIFont systemFontOfSize:17.0f], NSFontAttributeName,
                                                  nil];
            NSDictionary *attributesDictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIFont systemFontOfSize:12.0f], NSFontAttributeName,
                                                   nil];
            CGRect textLabelSize = [textLabel boundingRectWithSize:kLabelFrameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil];
            CGRect detailTextLabelSize = [detailTextLabel boundingRectWithSize:kLabelFrameMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary2 context:nil];
            return kListDifference + textLabelSize.size.height + detailTextLabelSize.size.height;
        } else {
            CGSize textLabelSize = [textLabel sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17.0f]
                                         constrainedToSize:kExamenLabelFrameMaxSize
                                             lineBreakMode:NSLineBreakByWordWrapping];
            CGSize detailTextLabelSize = [detailTextLabel sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0f]
                                                     constrainedToSize:kExamenLabelFrameMaxSize
                                                         lineBreakMode:NSLineBreakByWordWrapping];
            return kListDifference + textLabelSize.height + detailTextLabelSize.height;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showThemeDetails"]) {
        NSMutableArray *rightArray = [[NSMutableArray alloc] init];
        NSMutableArray *wrongArray = [[NSMutableArray alloc] init];
        NSMutableArray *wrongSelectedArray = [[NSMutableArray alloc] init];
        ThemeViewController *detailViewController = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        long row = [myIndexPath row];
        detailViewController.themeName = _themeTheme;
        detailViewController.themeNumber = row;
        detailViewController.themeCount = _themeQuestionNumber;
        detailViewController.wrongArray = wrongArray;
        detailViewController.rightArray = rightArray;
        detailViewController.wrongSelectedArray = wrongSelectedArray;
    }
}

@end