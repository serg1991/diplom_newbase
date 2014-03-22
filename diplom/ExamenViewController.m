//
//  ExamenViewController.m
//  diplom
//
//  Created by Sergey Kiselev on 20.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "ExamenViewController.h"

@interface ExamenViewController ()

@end

@implementation ExamenViewController

@synthesize theLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)handleTimerTick {
    remainingTicks--;
    [self updateLabel];
    
    if (remainingTicks <= 0) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)updateLabel {
    NSString *minutes = [NSString stringWithFormat:@"%d", remainingTicks / 60];
    NSString *seconds = [NSString stringWithFormat:@"%d", remainingTicks % 60];
    NSUInteger myMinute = [minutes intValue];
    NSUInteger mySecond = [seconds intValue];
    if (myMinute < 10)
        minutes = [NSString stringWithFormat:@"0%d", remainingTicks / 60];
    if (mySecond < 10)
        seconds = [NSString stringWithFormat:@"0%d", remainingTicks % 60];
    theLabel.text =  [NSString stringWithFormat:@"%@ : %@", minutes, seconds];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (_timer)
        return;
    
    remainingTicks = 1200;
    [self updateLabel];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimerTick) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:(BOOL)animated];
    [_timer invalidate];
    [self.theLabel removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //дата начала решения билета
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
    _dateString = [dateFormatter stringFromDate:date];

    //генерация номеров билетов для вопросов экзамена
    _randomNumbers = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i++) {
        NSUInteger randomNumber;
        randomNumber = arc4random()%(40 - 1 + 1) + 1;
        [_randomNumbers addObject:[NSNumber numberWithUnsignedLong:randomNumber]];
    }
    
    //добавление контроллеров в массив
    NSDictionary *options = (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) ? [NSDictionary dictionaryWithObject: [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid] forKey: UIPageViewControllerOptionSpineLocationKey] : nil;
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    ExamenChildViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    //добавление шапки из названия контроллера и таймера
    self.theLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 6, 100, 30)];
    _timer = nil;
    [self.navigationItem setTitle:@"Экзамен"];
    [self.navigationController.navigationBar addSubview:theLabel];
    //отключение жеста свайпа от левого края экрана
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ExamenChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    ExamenChildViewController *childViewController = [[ExamenChildViewController alloc] initWithNibName:@"QuestionsViewController" bundle:nil];
    childViewController.index = index;
    childViewController.rightAnswersArray = _rightArray;
    childViewController.wrongAnswersArray = _wrongArray;
    childViewController.wrongAnswersSelectedArray = _wrongSelectedArray;
    childViewController.startDate = _dateString;
    childViewController.randomNumbers = _randomNumbers;
    childViewController.timer = _timer;
    
    return childViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [(ExamenChildViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [(ExamenChildViewController *)viewController index];
    index++;
    if (index == 20)
        
        return nil;
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    
    return 20;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    
    return 0;
}

@end
