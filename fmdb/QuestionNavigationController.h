//
//  QuestionNavigationController.h
//  test
//
//  Created by Yoshiyuki Sakamoto on 2013/10/14.
//  Copyright (c) 2013年 HeyaYshirtY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionNavigationController : UINavigationController

@property NSMutableArray *allTexts;
@property NSMutableArray *selectedTexts;
@property NSMutableArray *answerDetail;
@property(readwrite) int correctCount;

@end
