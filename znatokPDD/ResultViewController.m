//
//  ResultViewController.m
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 31.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *minutes = [NSString stringWithFormat:@"%d", _time / 60];
    NSString *seconds = [NSString stringWithFormat:@"%d", _time % 60];
    NSUInteger myMinute = [minutes intValue];
    NSUInteger mySecond = [seconds intValue];
    if (myMinute < 10) {
        minutes = [NSString stringWithFormat:@"0%d", _time / 60];
    }
    if (mySecond < 10) {
        seconds = [NSString stringWithFormat:@"0%d", _time % 60];
    }
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"]];
        UILabel *labelback = [[UILabel alloc] init];
        if (_type == 0) {
            [labelback setText:@"К списку билетов"];
        } else if (_type == 1) {
            [labelback setText:@"К списку тем"];
        } else {
            [labelback setText:@"Меню"];
        }
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
        if (_type == 0) {
            [button addTarget:self action:@selector(backToBiletList) forControlEvents:UIControlEventTouchUpInside];
        } else if (_type == 1) {
            [button addTarget:self action:@selector(backToThemeList) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [button addTarget:self action:@selector(backToMenu) forControlEvents:UIControlEventTouchUpInside];
        }
        [view addSubview:button];
        [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveLinear animations:^ {
            labelback.alpha = 0.0;
            CGRect orig = labelback.frame;
            labelback.frame = CGRectMake(labelback.frame.origin.x + 25, labelback.frame.origin.y, labelback.frame.size.width, labelback.frame.size.height);
            labelback.alpha = 1.0;
            labelback.frame = orig;
        } completion:nil];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:view];
        self.navigationItem.leftBarButtonItem = backButton;
    } else {
        if (_type == 0) {
            _backlabel = @"К списку билетов";
        } else if (_type == 1) {
            _backlabel = @"К списку тем";
        } else {
            _backlabel = @"Меню";
        }
        UIButton *customBackButton = [UIButton buttonWithType:101];
        [customBackButton setTitle:_backlabel forState:UIControlStateNormal];
        if (_type == 0) {
            [customBackButton addTarget:self action:@selector(backToBiletList) forControlEvents:UIControlEventTouchUpInside];
        } else if (_type == 1) {
            [customBackButton addTarget:self action:@selector(backToThemeList) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [customBackButton addTarget:self action:@selector(backToMenu) forControlEvents:UIControlEventTouchUpInside];
        }
        UIBarButtonItem *myBackButton = [[UIBarButtonItem alloc] initWithCustomView:customBackButton];
        [self.navigationItem setLeftBarButtonItem:myBackButton];
        
    }
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"UIButtonBarAction"] forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(0, 0, 18, 25);
    [shareButton addTarget:self action:@selector(resultShare:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareIconButton = [[UIBarButtonItem alloc]initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItem = shareIconButton;
    if (_type != 1) {
        if (_rightCount > 17) { //good result
            _resultImage.image  = [UIImage imageNamed:@"cars.png"];
            [_resultImage.layer setBorderColor:[[UIColor colorWithRed:0 / 255.0f green:152 / 255.0f blue:70 / 255.0f alpha:1.0f] CGColor]];
            [_resultImage.layer setBorderWidth:1.0];
            _resultLabel.text = @"Экзамен сдан!";
            _resultLabel.textColor = [UIColor colorWithRed:0 / 255.0f green:152 / 255.0f blue:70 / 255.0f alpha:1.0f];
            _rightCountImage.image  = [UIImage imageNamed:@"good.png"];
            _rightCountLabel.text = [NSString stringWithFormat:@"%lu / 20", (unsigned long)_rightCount];
            _timeImage.image  = [UIImage imageNamed:@"clock.png"];
            _timeLabel.textAlignment = NSTextAlignmentCenter;
            _timeLabel.text = [NSString stringWithFormat:@"%@ : %@", minutes, seconds];
        } else { // bad result
            _resultImage.image  = [UIImage imageNamed:@"crash.png"];
            [_resultImage.layer setBorderColor:[[UIColor colorWithRed:236 / 255.0f green:30 / 255.0f blue:36 / 255.0f alpha:1.0f] CGColor]];
            [_resultImage.layer setBorderWidth:1.0];
            _resultLabel.text = @"Экзамен не сдан!";
            _resultLabel.textColor = [UIColor colorWithRed:236 / 255.0f green:30 / 255.0f blue:36 / 255.0f alpha:1.0f];
            _rightCountImage.image  = [UIImage imageNamed:@"bad.png"];
            _rightCountLabel.text = [NSString stringWithFormat:@"%lu / 20", (unsigned long)_rightCount];
            _timeImage.image  = [UIImage imageNamed:@"clock.png"];
            _timeLabel.textAlignment = NSTextAlignmentCenter;
            _timeLabel.text = [NSString stringWithFormat:@"%@ : %@", minutes, seconds];
        }
        if (_type == 0) {
            _themeLabel.text = [NSString stringWithFormat:@"Билет № %d", _biletNumber + 1];
        }
    } else { // theme
        _resultImage.image  = [UIImage imageNamed:@"theme_complete.png"];
        _resultLabel.text = @"Тема пройдена!";
        if (_rightCount > _themeCommon - _rightCount) {
            _rightCountImage.image  = [UIImage imageNamed:@"good.png"];
        } else {
            _rightCountImage.image  = [UIImage imageNamed:@"bad.png"];
        }
        _rightCountLabel.text = [NSString stringWithFormat:@"%lu / %lu", (unsigned long)_rightCount, (unsigned long)_themeCommon];
        _timeImage.image  = [UIImage imageNamed:@"clock.png"];
        _timeLabel.text = [NSString stringWithFormat:@"%@ : %@", minutes, seconds];
        _themeLabel.text = [NSString stringWithFormat:@"Тема %d. %@", _themeNumber + 1, _themeName[_themeNumber]];
    }
    if (_type == 2) {
        [_reloadImage setImage:[UIImage imageNamed:@"reload.png"]];
        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
        [singleTap setNumberOfTapsRequired:1];
        [_reloadImage addGestureRecognizer:singleTap];
        _reloadLabel.text = @"Начать заново";
    }
    _timeString = [NSString stringWithFormat:@"%@ : %@", minutes, seconds];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)singleTapping:(UIGestureRecognizer *)recognizer {
    [self performSegueWithIdentifier:@"examenAgain" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"examenAgain"]) {
        NSMutableArray *rightArray = [[NSMutableArray alloc] init];
        NSMutableArray *wrongArray = [[NSMutableArray alloc] init];
        NSMutableArray *wrongSelectedArray = [[NSMutableArray alloc] init];
        ExamenViewController *detailViewController = [segue destinationViewController];
        detailViewController.wrongArray = wrongArray;
        detailViewController.rightArray = rightArray;
        detailViewController.wrongSelectedArray = wrongSelectedArray;
    }
}

- (IBAction)resultShare:(id)sender {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                        message:@"Проверьте свое интернет-соединение!"
                                                       delegate:self
                                              cancelButtonTitle:@"ОК"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"There IS NO internet connection");
    } else {
        if (_type != 1) {
            VKontakteActivity *vkontakteActivity = [[VKontakteActivity alloc] initWithParent:self];
            _shareItems = @[[NSString stringWithFormat:@"Мой результат в тесте по ПДД - %d/20 со временем %@.\n #ЗнатокПДД \n", _rightCount, _timeString], [self screenshot],[NSURL URLWithString:@"http://itunes.apple.com/app/id865961195"]];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                    initWithActivityItems:_shareItems
                                                    applicationActivities:@[vkontakteActivity]];
            [activityVC setValue:@"Мой результат в приложении Знаток ПДД" forKey:@"subject"];
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                activityVC.excludedActivityTypes = @[UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
            } else {
                activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
            }
            [self presentViewController:activityVC animated:YES completion:nil];
        } else {
            VKontakteActivity *vkontakteActivity = [[VKontakteActivity alloc] initWithParent:self];
            _shareItems = @[[NSString stringWithFormat:@"Мой результат в тематическом тесте по ПДД - %d / %d со временем %@.\n #ЗнатокПДД \n", _rightCount, _themeCommon, _timeString], [self screenshot],[NSURL URLWithString:@"http://itunes.apple.com/app/id865961195"]];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                    initWithActivityItems:_shareItems
                                                    applicationActivities:@[vkontakteActivity]];
            [activityVC setValue:@"Мой результат в приложении Знаток ПДД" forKey:@"subject"];
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                activityVC.excludedActivityTypes = @[UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeAssignToContact, UIActivityTypeMessage, UIActivityTypeCopyToPasteboard, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
            } else {
                activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMessage, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll];
            }
            [self presentViewController:activityVC animated:YES completion:nil];
        }
    }
}

- (UIImage *)screenshot {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 1.0);
        [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    } else {
        CGSize imageSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
        UIGraphicsBeginImageContext(imageSize);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backToBiletList {
    UIViewController *prevVC = [self.navigationController.viewControllers objectAtIndex:1];
    [self.navigationController popToViewController:prevVC animated:YES];
}

- (void)backToThemeList {
    UIViewController *prevVC = [self.navigationController.viewControllers objectAtIndex:1];
    [self.navigationController popToViewController:prevVC animated:YES];
}

- (void)backToMenu {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end