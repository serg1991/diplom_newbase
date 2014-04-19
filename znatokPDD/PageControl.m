//
//  PageControl.m
//  ZnatokPDD
//
//  Created by Sergey Kiselev on 19.04.14.
//  Copyright (c) 2014 Sergey Kiselev. All rights reserved.
//

#import "PageControl.h"


// Tweak these or make them dynamic.
#define kDotDiameter 7.0
#define kDotSpacer 7.0

@implementation PageControl

@synthesize dotColorCurrentPage;
@synthesize dotColorWrongPage;
@synthesize dotColorRightPage;
@synthesize currentPage;
@synthesize numberOfPages;
@synthesize delegate;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setCurrentPage:(NSInteger)page {
    currentPage = MIN(MAX(0, page), self.numberOfPages-1);
    [self setNeedsDisplay];
}

- (void)setNumberOfPages:(NSInteger)pages {
    numberOfPages = MAX(0, pages);
    currentPage = MIN(MAX(0, self.currentPage), numberOfPages-1);
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Default colors.
        self.backgroundColor = [UIColor clearColor];
        self.dotColorCurrentPage = [UIColor lightGrayColor];
        self.dotColorRightPage = [UIColor colorWithRed:0 / 255.0f green:152 / 255.0f blue:70 / 255.0f alpha:1.0f];
        self.dotColorWrongPage = [UIColor colorWithRed:236 / 255.0f green:30 / 255.0f blue:36 / 255.0f alpha:1.0f];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.dotColorCurrentPage = [UIColor lightGrayColor];
        self.dotColorRightPage = [UIColor colorWithRed:0 / 255.0f green:152 / 255.0f blue:70 / 255.0f alpha:1.0f];
        self.dotColorWrongPage = [UIColor colorWithRed:236 / 255.0f green:30 / 255.0f blue:36 / 255.0f alpha:1.0f];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionAnsweredRight:) name:@"AnsweredRight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionAnsweredWrong:) name:@"AnsweredWrong" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(questionAnsweredWrong:) name:@"ClosedComment" object:nil];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    
    CGRect currentBounds = self.bounds;
    CGFloat dotsWidth = self.numberOfPages * kDotDiameter + MAX(0, self.numberOfPages - 1) * kDotSpacer;
    CGFloat x = CGRectGetMidX(currentBounds) - dotsWidth / 2;
    CGFloat y = CGRectGetMidY(currentBounds) - kDotDiameter / 2;
    for (int i = 0; i < self.numberOfPages; i++) {
        CGRect circleRect = CGRectMake(x, y, kDotDiameter, kDotDiameter);
        if (i == self.currentPage) {
            CGContextSetFillColorWithColor(context, self.dotColorCurrentPage.CGColor);
            CGContextFillEllipseInRect(context, circleRect);
        } else if ([_rightArray containsObject:[NSNumber numberWithInt:i + 1]]) {
            CGContextSetFillColorWithColor(context, self.dotColorRightPage.CGColor);
            CGContextFillEllipseInRect(context, circleRect);
        } else if ([_wrongArray containsObject:[NSNumber numberWithInt:i + 1]]) {
            CGContextSetFillColorWithColor(context, self.dotColorWrongPage.CGColor);
            CGContextFillEllipseInRect(context, circleRect);
        } else {
            CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
            CGContextFillEllipseInRect(context, circleRect);
        }
        x += kDotDiameter + kDotSpacer;
    }
}

- (void)questionAnsweredRight:(NSNotification *)notification {
    NSArray *theArray = [[notification userInfo] objectForKey:@"rightAnswersArray"];
    _rightArray = theArray;
}

- (void)questionAnsweredWrong:(NSNotification *)notification {
    NSArray *theArray = [[notification userInfo] objectForKey:@"wrongAnswersArray"];
    _wrongArray = theArray;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.delegate) {
        return;
    }
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
    CGFloat dotSpanX = self.numberOfPages * (kDotDiameter + kDotSpacer);
    CGFloat dotSpanY = kDotDiameter + kDotSpacer;
    CGRect currentBounds = self.bounds;
    CGFloat x = touchPoint.x + dotSpanX / 2 - CGRectGetMidX(currentBounds);
    CGFloat y = touchPoint.y + dotSpanY / 2 - CGRectGetMidY(currentBounds);
    if ((x < 0) || (x > dotSpanX) || (y < 0) || (y > dotSpanY)) {
        return;
    }
    self.currentPage = floor(x / (kDotDiameter + kDotSpacer));
    if ([self.delegate respondsToSelector:@selector(pageControlPageDidChange:)]) {
        [self.delegate pageControlPageDidChange:self];
    }
}

@end
