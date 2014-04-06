//
//  SettingsViewController.h
//  diplom
//
//  Created by Sergey Kiselev on 28.01.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "Reachability.h"
#import "VKontakteActivity.h"

@interface SettingsViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *vibroSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *commentSwitch;

- (IBAction)shareWithFriends:(id)sender;
- (IBAction)vibroSwitchCnahged:(id)sender;
- (IBAction)commentSwitchChanged:(id)sender;
- (IBAction)sendDevMail:(id)sender;

@end
