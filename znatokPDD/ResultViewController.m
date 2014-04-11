//
//  ResultViewController.m
//  diplom
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
    if (myMinute < 10)
        minutes = [NSString stringWithFormat:@"0%d", _time / 60];
    if (mySecond < 10)
        seconds = [NSString stringWithFormat:@"0%d", _time % 60];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"]];
    UILabel *labelback = [[UILabel alloc] init];
    if (!_examen)
        [labelback setText:@"К списку билетов"];
    else [labelback setText:@"В меню"];
    [labelback sizeToFit];
    int space = 6;
    labelback.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + space, labelback.frame.origin.y, labelback.frame.size.width, labelback.frame.size.height);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, labelback.frame.size.width + imageView.frame.size.width + space, imageView.frame.size.height)];
    view.bounds = CGRectMake(view.bounds.origin.x + 8, view.bounds.origin.y - 1, view.bounds.size.width, view.bounds.size.height);
    [view addSubview:imageView];
    [view addSubview:labelback];
    UIButton *button = [[UIButton alloc] initWithFrame:view.frame];
    if (!_examen) {
        [button addTarget:self action:@selector(backToBiletList) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
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
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setBackgroundImage:[UIImage imageNamed:@"UIButtonBarAction"] forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(0, 0, 18, 25);
    [shareButton addTarget:self action:@selector(resultShare:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareIconButton = [[UIBarButtonItem alloc]initWithCustomView:shareButton];
    self.navigationItem.rightBarButtonItem = shareIconButton;
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (_rightCount > 17) {
        if (screenHeight == 480) {
            UIImageView *resultImage = [[UIImageView alloc] initWithFrame:CGRectMake(96, 18, 128, 128)];
            resultImage.image  = [UIImage imageNamed:@"cars.png"];
            [resultImage.layer setBorderColor:[[UIColor colorWithRed:0 / 255.0f green:152 / 255.0f blue:70 / 255.0f alpha:1.0f] CGColor]];
            [resultImage.layer setBorderWidth:1.0];
            [self.view addSubview:resultImage];
            UILabel  *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 166, 118, 22)];
            resultLabel.text = @"Экзамен сдан!";
            [resultImage.layer setBorderColor:[[UIColor colorWithRed:0 / 255.0f green:152 / 255.0f blue:70 / 255.0f alpha:1.0f] CGColor]];
            [self.view addSubview:resultLabel];
            UIImageView *goodImage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 222, 64, 64)];
            goodImage.image  = [UIImage imageNamed:@"good.png"];
            [self.view addSubview:goodImage];
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(114, 242, 152, 22)];
            countLabel.text = [NSString stringWithFormat:@"%lu / 20", (unsigned long)_rightCount];
            countLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:countLabel];
            UIImageView *timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 312, 64, 64)];
            timeImage.image  = [UIImage imageNamed:@"clock.png"];
            [self.view addSubview:timeImage];
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(114, 332, 152, 22)];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            timeLabel.text = [NSString stringWithFormat:@"%@ : %@", minutes, seconds];
            [self.view addSubview:timeLabel];
        }
        else {
            UIImageView *resultImage = [[UIImageView alloc] initWithFrame:CGRectMake(96, 18, 128, 128)];
            resultImage.image  = [UIImage imageNamed:@"cars.png"];
            [resultImage.layer setBorderColor:[[UIColor colorWithRed:0 / 255.0f green:152 / 255.0f blue:70 / 255.0f alpha:1.0f] CGColor]];
            [resultImage.layer setBorderWidth:1.0];
            [self.view addSubview:resultImage];
            UILabel  *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 186, 118, 22)];
            resultLabel.text = @"Экзамен сдан!";
            [resultImage.layer setBorderColor:[[UIColor colorWithRed:0 / 255.0f green:152 / 255.0f blue:70 / 255.0f alpha:1.0f] CGColor]];
            [self.view addSubview:resultLabel];
            UIImageView *goodImage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 252, 64, 64)];
            goodImage.image  = [UIImage imageNamed:@"good.png"];
            [self.view addSubview:goodImage];
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(114, 272, 152, 22)];
            countLabel.text = [NSString stringWithFormat:@"%lu / 20", (unsigned long)_rightCount];
            countLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:countLabel];
            UIImageView *timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 342, 64, 64)];
            timeImage.image  = [UIImage imageNamed:@"clock.png"];
            [self.view addSubview:timeImage];
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(114, 362, 152, 22)];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            timeLabel.text = [NSString stringWithFormat:@"%@ : %@", minutes, seconds];
            [self.view addSubview:timeLabel];
        }
    }
    else {
        if (screenHeight == 480) {
            UIImageView *resultImage = [[UIImageView alloc] initWithFrame:CGRectMake(96, 18, 128, 128)];
            resultImage.image  = [UIImage imageNamed:@"crash.png"];
            [resultImage.layer setBorderColor:[[UIColor colorWithRed:236 / 255.0f green:30 / 255.0f blue:36 / 255.0f alpha:1.0f] CGColor]];
            [resultImage.layer setBorderWidth:1.0];
            [self.view addSubview:resultImage];
            UILabel  *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 166, 150, 22)];
            resultLabel.text = @"Экзамен не сдан!";
            [resultImage.layer setBorderColor:[[UIColor colorWithRed:236 / 255.0f green:30 / 255.0f blue:36 / 255.0f alpha:1.0f] CGColor]];
            [self.view addSubview:resultLabel];
            UIImageView *badImage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 222, 64, 64)];
            badImage.image  = [UIImage imageNamed:@"bad.png"];
            [self.view addSubview:badImage];
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(114, 242, 152, 22)];
            countLabel.text = [NSString stringWithFormat:@"%lu / 20", (unsigned long)_rightCount];
            countLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:countLabel];
            UIImageView *timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 312, 64, 64)];
            timeImage.image  = [UIImage imageNamed:@"clock.png"];
            [self.view addSubview:timeImage];
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(114, 332, 152, 22)];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            timeLabel.text = [NSString stringWithFormat:@"%@ : %@", minutes, seconds];
            [self.view addSubview:timeLabel];
        }
        else {
            UIImageView *resultImage = [[UIImageView alloc] initWithFrame:CGRectMake(96, 18, 128, 128)];
            resultImage.image  = [UIImage imageNamed:@"crash.png"];
            [resultImage.layer setBorderColor:[[UIColor colorWithRed:236 / 255.0f green:30 / 255.0f blue:36 / 255.0f alpha:1.0f] CGColor]];
            [resultImage.layer setBorderWidth:1.0];
            [self.view addSubview:resultImage];
            UILabel  *resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 186, 150, 22)];
            resultLabel.text = @"Экзамен не сдан!";
            [resultImage.layer setBorderColor:[[UIColor colorWithRed:236 / 255.0f green:30 / 255.0f blue:36 / 255.0f alpha:1.0f] CGColor]];
            [self.view addSubview:resultLabel];
            UIImageView *badImage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 252, 64, 64)];
            badImage.image  = [UIImage imageNamed:@"bad.png"];
            [self.view addSubview:badImage];
            UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(114, 272, 152, 22)];
            countLabel.text = [NSString stringWithFormat:@"%lu / 20", (unsigned long)_rightCount];
            countLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:countLabel];
            UIImageView *timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 342, 64, 64)];
            timeImage.image  = [UIImage imageNamed:@"clock.png"];
            [self.view addSubview:timeImage];
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(114, 362, 152, 22)];
            timeLabel.text = [NSString stringWithFormat:@"%@ : %@", minutes, seconds];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:timeLabel];
        }
    }
    _timeString = [NSString stringWithFormat:@"%@ : %@", minutes, seconds];
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
    }
    else {
        NSLog(@"There IS internet connection");
        VKontakteActivity *vkontakteActivity = [[VKontakteActivity alloc] initWithParent:self];
        _shareItems = @[[NSString stringWithFormat:@"Мой результат прохождения теста по ПДД - %d/20 со временем %@.\n Я пользуюсь Знаток ПДД для #iPhone", _rightCount, _timeString], [self screenshot],[NSURL URLWithString:@"http://yandex.ru"]];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                                initWithActivityItems:_shareItems
                                                applicationActivities:@[vkontakteActivity]];
        [activityVC setValue:@"Мой результат в приложении Знаток ПДД" forKey:@"subject"];
        activityVC.excludedActivityTypes = @[UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}

- (UIImage *)screenshot {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backToBiletList {
    UIViewController *prevVC = [self.navigationController.viewControllers objectAtIndex:1];
    [self.navigationController popToViewController:prevVC animated:YES];
}

- (void)backToMenu {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end