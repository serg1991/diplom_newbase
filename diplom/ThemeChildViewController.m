//
//  ThemeChildViewController.m
//  diplom
//
//  Created by Sergey Kiselev on 29.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "ThemeChildViewController.h"

@interface ThemeChildViewController ()

@end

@implementation ThemeChildViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAnswers];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
}

- (void)dealloc {
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGRect frame = self.tableView.frame;
    frame.size = self.tableView.contentSize;
    self.tableView.frame = frame;
}

- (void)showComment {
    NSArray *array = [self getAnswers];
    NSUInteger arrayCount = array.count;
    NSString *comment = [NSString stringWithFormat:@"%@ \n Правильный ответ - %d.", self.getAnswers[arrayCount - 1], [self.getAnswers[arrayCount - 2] intValue]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Подсказка"
                                                    message:comment
                                                   delegate:self
                                          cancelButtonTitle:@"ОК"
                                          otherButtonTitles:nil];
    [alert show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSUInteger)section {
    int height =  (_imageView.image == 0) ? 0 : 118;
    
    return height;
}

- (NSMutableArray *)getAnswers {
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"pdd.sqlite"];
    const char *dbpath = [defaultDBPath UTF8String];
    sqlite3_stmt *statement;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &_pdd_ab) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT RecNo, Picture, Question, Answer1, Answer2, Answer3, Answer4, Answer5, RightAnswer, Comment FROM paper_ab WHERE QuestionType = \"%d\" LIMIT 1 OFFSET \"%lu\"", (int)_themeNumber + 1, (unsigned long)_index];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(_pdd_ab, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NSData *picture = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 1) length: sqlite3_column_bytes(statement, 1)];
                _imageView.image = [UIImage imageWithData:picture];
                
                for (int i = 2; i < 10; i++) {
                    if (sqlite3_column_text(statement, i) != NULL) {
                        NSString *arrayelement = [[NSString alloc]
                                                  initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, i)];
                        [array addObject:arrayelement];
                    }
                }
                sqlite3_finalize(statement);
            }
            else {
                NSLog(@"Rezultatov net!");
            }
        }
        else {
            NSLog(@"Ne mogu vypolnit' zapros!");
        }
        sqlite3_close(_pdd_ab);
    }
    else {
        NSLog(@"Ne mogu ustanovit' soedinenie!");
    }
    
    return array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfSectionInTableView:(UITableView *)tableView {
    return 1;
}

- (NSUInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSUInteger)section {
    
    NSArray *array = [self getAnswers];
    
    return array.count - 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger rowNumber = [indexPath row];
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    NSMutableArray *answerArray = [self getAnswers];
    if (rowNumber == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont italicSystemFontOfSize:15.0];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = [NSString stringWithFormat:@"%@", answerArray[0]];
        cell.textLabel.numberOfLines = 0;
    }
    else {
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@", (long)rowNumber, answerArray[rowNumber]];
        cell.textLabel.numberOfLines = 0;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger rowNumber = [indexPath row];
    NSArray *array = [self getAnswers];
    if ([self.rightAnswersArray containsObject:[NSNumber numberWithLong:_index + 1]] ) { // делаю красиво, если пользователь возвращается к вопросу, на который уже правильно ответил
        self.tableView.allowsSelection = NO;
        if (rowNumber == [array[array.count - 2] intValue])  // если ответ правильный
            cell.contentView.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
    }
    else if ([self.wrongAnswersArray containsObject:[NSNumber numberWithLong:_index + 1]] ) { // делаю красиво, если пользователь возвращается к вопросу, на который уже НЕправильно ответил
        long questnum = [self.wrongAnswersArray indexOfObject:[NSNumber numberWithInteger:_index + 1]];
        self.tableView.allowsSelection = NO;
        if (rowNumber != [array[array.count - 2] intValue] && [NSNumber numberWithLong:rowNumber] == [NSNumber numberWithInt:[[self.wrongAnswersSelectedArray objectAtIndex:questnum] intValue]])  // если ответ НЕправильный
            cell.contentView.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSUInteger rowNumber = [indexPath row];
    NSArray *array = [self getAnswers];
    if (rowNumber == 0) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self showComment];
    }
    else {
        if (rowNumber == [array[array.count - 2] intValue]) { // если ответ правильный
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate); // вибрация при правильном ответе
            cell.contentView.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
            self.tableView.allowsSelection = NO;
            [self.rightAnswersArray addObject:[NSNumber numberWithLong:_index + 1]];
        }
        else { // если ответ неправильный
            cell.contentView.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
            self.tableView.allowsSelection = NO;
            [self.wrongAnswersArray addObject:[NSNumber numberWithLong:_index + 1]];
            [self.wrongAnswersSelectedArray addObject:[NSNumber numberWithLong:rowNumber]];
            [self showComment];
        }
    }
    
    NSUInteger wrongCount = _wrongAnswersArray.count;
    NSUInteger rightCount = _rightAnswersArray.count;
    NSLog(@"Номер вопроса - %d, правильных ответов - %d, неправильных ответов - %d", (int)_index + 1, (int)rightCount, (int)wrongCount);
    if (rightCount + wrongCount == _themeCount) {
        [self getResultOfTest];
        [self writeStatisticsToBase];
    }
}

- (void)getResultOfTest {
    if (_wrongAnswersArray.count <= 2) {
        //[self performSegueWithIdentifier:@"GoodResult" sender:self];
    }
    else {
        //[self performSegueWithIdentifier:@"BadResult" sender:self];
    }
}

- (void)writeStatisticsToBase {
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *defaultDBPath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"pdd_stat.sqlite"]];
    const char *dbpath = [defaultDBPath UTF8String];
    sqlite3_stmt *statement;
    
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    if (sqlite3_open(dbpath, &_pdd_ab_stat) == SQLITE_OK) {
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO paper_ab_theme_stat(themeNumber, rightCount, wrongCount, startDate, finishDate) VALUES ('%d', '%d', '%d', '%@', '%@')", (int)_themeNumber + 1, (int)_rightAnswersArray.count, (int)_wrongAnswersArray.count, _startDate, dateString];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_pdd_ab_stat, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"Zapis' proizvedena uspeshno");
        }
        else {
            NSLog(@"Zapis' proizvedena neuspeshno");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_pdd_ab_stat);
    }
    else {
        NSLog(@"Ne mogu ustanovit' soedinenie!");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [[[self getAnswers] objectAtIndex:indexPath.row]
                   sizeWithFont:[UIFont systemFontOfSize:15]
                   constrainedToSize:CGSizeMake(276, CGFLOAT_MAX)];
    double commonsize = size.height;
    if (commonsize < 20) {
        return commonsize = 44;
    }
    else if (commonsize < 40) {
        return commonsize = 62;
    }
    else if (commonsize < 55) {
        return commonsize = 80;
    }
    else if (commonsize < 72) {
        return commonsize = 98;
    }
    else if (commonsize < 90) {
        return commonsize = 116;
    }
    else if (commonsize < 108) {
        return commonsize = 134;
    }
    else if (commonsize < 142) {
        return commonsize = 152;
    }
    else if (commonsize < 160) {
        return commonsize = 176;
    }
    else {
        return commonsize = 200;
    }
}

@end
