//
//  ResultDetailView.h
//  test
//
//  Created by Yoshiyuki Sakamoto on 2013/10/18.
//  Copyright (c) 2013年 HeyaYshirtY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionNavigationController.h"

@interface ResultDetailView : UIScrollView{
    NSMutableArray *question_array;
    NSMutableArray *question_button_array;
    NSMutableArray *all_answer_array;
    int correct_count;
}

@property NSMutableArray *todayTexts;
@property(readwrite) QuestionNavigationController *questionNavigationController;
//@property QuestionNavigationController *qnc;

- (id)initWithQNC:(QuestionNavigationController *)qnc;

@end
