//
//  BiletViewController.m
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 29.01.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "BiletViewController.h"

@interface BiletViewController ()

@end

@implementation BiletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *date = [[NSDate alloc] init];
    _startDate = [date timeIntervalSince1970];
    NSDictionary *options = (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) ? [NSDictionary dictionaryWithObject: [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid] forKey: UIPageViewControllerOptionSpineLocationKey] : nil;
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    [[self.pageController view] setFrame:[[self view] bounds]];
    BiletChildViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 22)];
    label.font = [UIFont systemFontOfSize: 18.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"Билет №%lu", (unsigned long)_biletNumber + 1];
    self.navigationItem.titleView = label;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"]];
    UILabel *labelback = [[UILabel alloc] init];
    [labelback setText:@"Прервать"];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionAnsweredRight:) name:@"AnsweredRight" object:nil];
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if ([settings boolForKey:@"showComment"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionAnsweredWrong:) name:@"ClosedComment" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionAnsweredWrong:) name:@"AnsweredWrong" object:nil];
    }
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    if (appFrame.size.height > 480) {
    CGRect f = CGRectMake(0, 480 , 320, 20);
        _pageControl = [[PageControl alloc] initWithFrame:f];
    } else {
        CGRect f = CGRectMake(0, 392 , 320, 20);
        _pageControl = [[PageControl alloc] initWithFrame:f];
    }
    _pageControl.numberOfPages = 20;
    _pageControl.currentPage = 0;
    [self.view addSubview:_pageControl];
}

- (void)questionAnsweredRight:(id)object {
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    NSLog (@"Successfully received the test notification!");
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self nextTap];
        _pageControl.currentPage++;
    });
}

- (void)questionAnsweredWrong:(id)object {
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    NSLog (@"Successfully received the test notification!");
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self nextTap];
        _pageControl.currentPage++;
    });
}

- (void)confirmCancel {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание"
                                                    message:@"Вы действительно хотите \n выйти из тестирования? \n Ваш прогресс не будет сохранен."
                                                   delegate:self
                                          cancelButtonTitle:@"Нет"
                                          otherButtonTitles:@"Да, выйти", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BiletChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    BiletChildViewController *childViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BiletChildViewController"];
    childViewController.index = index;
    childViewController.biletNumber = _biletNumber;
    childViewController.rightAnswersArray = _rightArray;
    childViewController.wrongAnswersArray = _wrongArray;
    childViewController.wrongAnswersSelectedArray = _wrongSelectedArray;
    childViewController.startDate = _startDate;
    _currentIndex = (int)index;
    return childViewController;
}

- (void)nextTap {
	if (_currentIndex == kBiletQuestionNumber - 1) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
		return;
	} else {
		_currentIndex += 1;
	}
	
	BiletChildViewController *toViewController = (BiletChildViewController *)[self viewControllerAtIndex:_currentIndex];
	[_pageController setViewControllers:[NSArray arrayWithObject:toViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

@end
