//
//  GoodResultViewController.h
//  diplom
//
//  Created by Sergey Kiselev on 31.03.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodResultViewController : UIViewController
@property (nonatomic) NSUInteger whichController;
@property (nonatomic) NSUInteger rightCount;
@property (nonatomic) NSUInteger time;
@property (weak, nonatomic) IBOutlet UILabel *clockResult;
@property (weak, nonatomic) IBOutlet UILabel *examenResult;

@end
