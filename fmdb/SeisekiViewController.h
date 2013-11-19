//
//  SeisekiViewController.h
//  fmdb
//
//  Created by Yoshiyuki Sakamoto on 2013/10/25.
//  Copyright (c) 2013年 horita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GionViewController.h"

@interface SeisekiViewController : GionViewController
@property (weak, nonatomic) IBOutlet UILabel *achivementLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightAllLabel;
@property (weak, nonatomic) IBOutlet UILabel *runningLabel;
@property (weak, nonatomic) IBOutlet UILabel *runningMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTodayLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightAllTodayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageToday;
@property (weak, nonatomic) IBOutlet UIImageView *imageTotal;
@property (weak, nonatomic) IBOutlet UILabel *todayDateLabel;
@property (weak, nonatomic) IBOutlet UIView *totalView;
@property (weak, nonatomic) IBOutlet UILabel *achievementTodayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageComment;
@property (weak, nonatomic) IBOutlet UIView *todayView;
@property (weak, nonatomic) IBOutlet UILabel *commentTotalLabel;
@end
