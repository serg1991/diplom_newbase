//
//  ThemeViewController.m
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 29.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "ThemeViewController.h"

@interface ThemeViewController ()

@end

@implementation ThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *date = [[NSDate alloc] init];
    _startDate = [date timeIntervalSince1970];
    NSDictionary *options = (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) ? [NSDictionary dictionaryWithObject: [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMid] forKey: UIPageViewControllerOptionSpineLocationKey] : nil;
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    [[self.pageController view] setFrame:[[self view] bounds]];
    ThemeChildViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 22)];
        label.font = [UIFont systemFontOfSize: 18.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"Тема №%lu", (unsigned long)_themeNumber + 1];
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
        CGRect appFrame = [[UIScreen mainScreen] bounds];
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            CGRect f = CGRectMake(0, 936, 768, 20);
            _pageControl = [[PageControl alloc] initWithFrame:f];
        } else {
            if (appFrame.size.height > 480) {
                CGRect f = CGRectMake(0, 480 , 320, 20);
                _pageControl = [[PageControl alloc] initWithFrame:f];
            } else {
                CGRect f = CGRectMake(0, 392 , 320, 20);
                _pageControl = [[PageControl alloc] initWithFrame:f];
            }
        }
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            if ([[_themeCount objectAtIndex:_themeNumber]integerValue] <= 41) {
                _pageControl.numberOfPages = [[_themeCount objectAtIndex:_themeNumber]integerValue];
                _pageControl.currentPage = 0;
            } else {
                _pageControl.numberOfPages = 0;
            }
            [self.view addSubview:_pageControl];
        } else {
            if ([[_themeCount objectAtIndex:_themeNumber]integerValue] <= 20) {
                _pageControl.numberOfPages = [[_themeCount objectAtIndex:_themeNumber]integerValue];
                _pageControl.currentPage = 0;
            } else {
                _pageControl.numberOfPages = 0;
            }
            [self.view addSubview:_pageControl];
        }
    } else {
        UIButton *customBackButton = [UIButton buttonWithType:101];
        [customBackButton setTitle:@"Прервать" forState:UIControlStateNormal];
        [customBackButton addTarget:self
                             action:@selector(confirmCancel) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *myBackButton = [[UIBarButtonItem alloc] initWithCustomView:customBackButton];
        [self.navigationItem setLeftBarButtonItem:myBackButton];
        NSString *title = [NSString stringWithFormat:@"Тема №%lu", (unsigned long)_themeNumber + 1];
        [self.navigationItem setTitle:title];
        CGRect appFrame = [[UIScreen mainScreen] bounds];
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            CGRect f = CGRectMake(0, 956 , 768, 20);
            _pageControl = [[PageControl alloc] initWithFrame:f];
        } else {
            if (appFrame.size.height > 480) {
                CGRect f = CGRectMake(0, 500 , 320, 20);
                _pageControl = [[PageControl alloc] initWithFrame:f];
            } else {
                CGRect f = CGRectMake(0, 412 , 320, 20);
                _pageControl = [[PageControl alloc] initWithFrame:f];
            }
        }
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            if ([[_themeCount objectAtIndex:_themeNumber]integerValue] <= 60) {
                _pageControl.numberOfPages = [[_themeCount objectAtIndex:_themeNumber]integerValue];
                _pageControl.currentPage = 0;
            } else {
                _pageControl.numberOfPages = 0;
            }
            [self.view addSubview:_pageControl];
        } else {
            if ([[_themeCount objectAtIndex:_themeNumber]integerValue] <= 20) {
                _pageControl.numberOfPages = [[_themeCount objectAtIndex:_themeNumber]integerValue];
                _pageControl.currentPage = 0;
            } else {
                _pageControl.numberOfPages = 0;
            }
            [self.view addSubview:_pageControl];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionAnsweredRight:) name:@"AnsweredRight" object:nil];
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if ([settings boolForKey:@"showComment"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionAnsweredWrong:) name:@"ClosedComment" object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionAnsweredWrong:) name:@"AnsweredWrong" object:nil];
    }
    
}

- (void)questionAnsweredRight:(id)object {
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self nextTap];
        _pageControl.currentPage++;
    });
}

- (void)questionAnsweredWrong:(id)object {
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self nextTap];
        _pageControl.currentPage++;
    });
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)confirmCancel {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание"
                                                    message:@"Вы действительно хотите \n выйти из тестирования? \n Ваш прогресс не будет сохранен."
                                                   delegate:self
                                          cancelButtonTitle:@"Нет"
                                          otherButtonTitles:@"Да, выйти", nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (ThemeChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    ThemeChildViewController *childViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ThemeChildViewController"];
    childViewController.index = (int)index;
    childViewController.themeNumber = (int)_themeNumber;
    childViewController.rightAnswersArray = _rightArray;
    childViewController.wrongAnswersArray = _wrongArray;
    childViewController.wrongAnswersSelectedArray = _wrongSelectedArray;
    childViewController.startDate = _startDate;
    childViewController.themeCount = (int)[[_themeCount objectAtIndex:_themeNumber]integerValue];
    childViewController.themeName = _themeName;
    _currentIndex = (int)index;
    return childViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [(ThemeChildViewController *)viewController index];
    if (index == 0) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [(ThemeChildViewController *)viewController index];
    index++;
    if (index == [[_themeCount objectAtIndex:_themeNumber]integerValue]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (void)nextTap {
	if (_currentIndex == [[_themeCount objectAtIndex:_themeNumber]integerValue] - 1) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
		return;
	} else {
		_currentIndex += 1;
	}
	
	ThemeChildViewController *toViewController = (ThemeChildViewController *)[self viewControllerAtIndex:_currentIndex];
	[_pageController setViewControllers:[NSArray arrayWithObject:toViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

@end
