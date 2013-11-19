//
//  ResultViewController.h
//  test
//
//  Created by Yoshiyuki Sakamoto on 2013/10/14.
//  Copyright (c) 2013年 HeyaYshirtY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GionViewController.h"

@class QuestionViewController;
@interface ResultViewController : GionViewController{
    QuestionViewController *parent_question_view;
}

@end
