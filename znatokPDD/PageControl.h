//
//  PageControl.h
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 19.04.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageControlDelegate;

@interface PageControl : UIView

// Set these to control the PageControl.
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;

// Customize these as well as the backgroundColor property.
@property (nonatomic, strong) UIColor *dotColorCurrentPage;
@property (nonatomic, strong) UIColor *dotColorRightPage;
@property (nonatomic, strong) UIColor *dotColorWrongPage;
@property (nonatomic) NSArray *rightArray;
@property (nonatomic) NSArray *wrongArray;

// Optional delegate for callbacks when user taps a page dot.
@property (nonatomic, weak) NSObject<PageControlDelegate> *delegate;

@end

@protocol PageControlDelegate<NSObject>
@optional
- (void)pageControlPageDidChange:(PageControl *)pageControl;

@end
