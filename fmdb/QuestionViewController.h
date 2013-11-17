//
//  QuestionViewController.h
//  test
//
//  Created by Yoshiyuki Sakamoto on 2013/10/14.
//  Copyright (c) 2013年 HeyaYshirtY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodayViewController.h"
#import "Text.h"

@interface QuestionViewController : UIViewController{
    BOOL is_button_tapped;
}

@property Text *text;
@property(readwrite) int questionNum;
@property(readonly) NSMutableArray *answerButtonArray;
@property(readonly) int correctAnswerInt;
@property(readonly) int selectAnswertInt;
@property(readonly) BOOL result;


@end
