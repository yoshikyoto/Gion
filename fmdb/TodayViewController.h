//
//  TodayViewController.h
//  test
//
//  Created by Yoshiyuki Sakamoto on 2013/10/14.
//  Copyright (c) 2013年 HeyaYshirtY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GionTabBarController.h"
#import "GionViewController.h"
#import "ResultViewController.h"

@class QuestionViewController;
@class QuestionNavigationController;

@interface TodayViewController : GionViewController{
    UIButton *question_button;
    UIScrollView *tango_view;
    QuestionNavigationController *qnc;
}

@property NSMutableArray *allTexts;
@property NSMutableArray *todaysTexts;

@end
