//
//  ExamenChildViewController.m
//  diplom
//
//  Created by Sergey Kiselev on 20.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "ExamenChildViewController.h"

@interface ExamenChildViewController ()

@end

@implementation ExamenChildViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)dealloc {
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self getAnswers];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
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
        NSString *querySQL = [NSString stringWithFormat:@"SELECT RecNo, Picture, Question, Answer1, Answer2, Answer3, Answer4, Answer5, RightAnswer, Comment FROM paper_ab WHERE PaperNumber = \"%@\" AND QuestionInPaper = \"%d\"", _randomNumbers[_index] , (int)_index + 1];
        
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
        }
    }
    NSUInteger wrongCount = _wrongAnswersArray.count;
    NSUInteger rightCount = _rightAnswersArray.count;
    NSLog(@"Номер вопроса - %d, правильных ответов - %d, неправильных ответов - %d", (int)_index + 1, (int)rightCount, (int)wrongCount);
    if (rightCount + wrongCount == 20 || _remainingTicks == 0) {
        [self getResultOfTest];
        [self writeStatisticsToBase];
        [_timer invalidate];
    }
}

- (void)getResultOfTest {
    [NSThread sleepForTimeInterval:1.00]; //pause before go to result's xib
    if (_wrongAnswersArray.count <= 2) {
        // Instantiate the nib content without any reference to it.
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"GoodResultInBilet" owner:nil options:nil];
        
        // Find the view among nib contents (not too hard assuming there is only one view in it).
        UIView *plainView = [nibContents lastObject];
        
        // Some hardcoded layout.
        CGSize padding = (CGSize){ 0.0, 0.0 };
        plainView.frame = (CGRect){padding.width, padding.height, plainView.frame.size};
        
        // Add to the view hierarchy (thus retain).
        [self.view addSubview:plainView];
    }
    else {
        // Instantiate the nib content without any reference to it.
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"BadResultInBilet" owner:nil options:nil];
        
        // Find the view among nib contents (not too hard assuming there is only one view in it).
        UIView *plainView = [nibContents lastObject];
        
        // Some hardcoded layout.
        CGSize padding = (CGSize){ 0.0, 0.0 };
        plainView.frame = (CGRect){padding.width, padding.height, plainView.frame.size};
        
        // Add to the view hierarchy (thus retain).
        [self.view addSubview:plainView];
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
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO paper_ab_examen_stat(rightCount, wrongCount, rightAnswers, wrongAnswers, startDate, finishDate) VALUES ('%d', '%d', '%@', '%@', '%@', '%@')", (int)_rightAnswersArray.count, (int)_wrongAnswersArray.count, [_rightAnswersArray componentsJoinedByString:@","], [_wrongAnswersArray componentsJoinedByString:@","], _startDate, dateString];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_pdd_ab_stat, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"Zapis' proizvedena uspeshno");
        }
        else {
            NSLog(@"%s", insert_stmt);
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGRect frame = self.tableView.frame;
    frame.size = self.tableView.contentSize;
    self.tableView.frame = frame;
}

@end
