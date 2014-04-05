//
//  SettingsViewController.m
//  diplom
//
//  Created by Sergey Kiselev on 28.01.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UINavigationBarBackIndicatorDefault"]];
    UILabel *labelback = [[UILabel alloc] init];
    [labelback setText:@"Меню"];
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
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    BOOL vibration = [settings boolForKey:@"needVibro"];
    BOOL comment = [settings boolForKey:@"showComment"];
    [_vibroSwitch setOn:vibration];
    [_commentSwitch setOn:comment];
}

- (void)confirmCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)shareWithFriends:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Рассказать друзьям о приложении" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:
                            @"ВКонтакте",
                            @"Facebook",
                            @"Twitter",
                            @"Одноклассники",
                            @"Мой Мир",
                            @"E-mail",
                            @"SMS",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
//                    [self VKShare];
                    break;
                case 1:
                    [self FBShare];
                    break;
                case 2:
                    [self TwitterShare];
                    break;
                case 3:
    //                [self ODShare];
                    break;
                case 4:
      //              [self MyMirShare];
                    break;
                case 5:
        //            [self MailShare];
                    break;
                case 6:
          //          [self SMSShare];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)TwitterShare {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"Подготовка к экзамену в ГАИ! Знаток ПДД для #iPhone http://itunes.apple.com/RU/lookup?bundleId=ru.sergekiselev.znatokpdd"];
        [tweetSheet addImage:[UIImage imageNamed:@"logo.png"]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (void)FBShare {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"Подготовка к экзамену в ГАИ! Знаток ПДД для #iPhone"];
        [controller addURL:[NSURL URLWithString:@"http://itunes.apple.com/RU/lookup?bundleId=ru.sergekiselev.znatokpdd"]];
        [controller addImage:[UIImage imageNamed:@"logo.png"]];
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

- (IBAction)vibroSwitchCnahged:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:_vibroSwitch.isOn forKey:@"needVibro"];
    [defaults synchronize];
}

- (IBAction)commentSwitchChanged:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:_commentSwitch.isOn forKey:@"showComment"];
    [defaults synchronize];
}

@end
