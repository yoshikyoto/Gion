//
//  SeisekiViewController.m
//  fmdb
//
//  Created by Yoshiyuki Sakamoto on 2013/10/25.
//  Copyright (c) 2013年 horita. All rights reserved.
//

#import "SeisekiViewController.h"
#import "GionTabBarController.h"
#import "Text.h"

@interface SeisekiViewController ()


@end

@implementation SeisekiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"成績";
    [self updateLabel];
}

- (void)updateLabel{
    /**********************
     必要なデータを取得し代入していく
     2013.11.19 by horita
     **********************/

    // NSUserDefaultから継続日数と最高継続日数を取得
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    int running = [ud integerForKey:@"RUNNING"];
    int running_max = [ud integerForKey:@"RUNNINGMAX"];
    _runningLabel.text = [NSString stringWithFormat:@"%d日連続継続中！", running];
    _runningMaxLabel.text = [NSString stringWithFormat:@"(最高記録 %d日)", running_max];

    // NSUserDefaultから今日の日付を取得
    NSDate* date = [ud objectForKey:@"DATE"];
    if(date == NULL) date = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]]; // dateが空ならシステムから現在日時取得
    // 今日の日付のフォーマットを修正
    NSDateFormatter* form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"MM/dd(EEE)"];
    NSString* str = [form stringFromDate:date];
    _todayDateLabel.text = [NSString stringWithFormat:@"%@",str];

    
    // 今日の成績：正解数を取得
    if([ud objectForKey:@"TODAYSRESULT"] != NULL) {
        int todaysresult = [ud integerForKey:@"TODAYSRESULT"];
        _rightAllTodayLabel.text =[NSString stringWithFormat:@"(正解数 %d問 / 全 %d問)", todaysresult, 5];
    } else {
        NSLog(@"nullでした");
    }
    
    // 総合成績：問題数，正解数を取得
    GionTabBarController *tabbar = (GionTabBarController *)self.tabBarController;
    NSMutableArray *texts = tabbar.texts;
    int all_texts_count = [texts count];
    int right_texts_count = 0;
    for(int i = 0; i < [texts count]; i++){
        Text *text = [texts objectAtIndex:i];
        if(text.right > 0){
            NSLog(@"%@ 習得", text.word);
            right_texts_count++;
        }else{
            NSLog(@"%@　未習得", text.word);
        }
    }
    _rightAllLabel.text = [NSString stringWithFormat:@"(正解数 %d問 / 全 %d問)", right_texts_count, all_texts_count];

    
    // 総合成績：達成度の計算と達成度コメントの設定
    double ach = right_texts_count / all_texts_count;
    _achivementLabel.text =[NSString stringWithFormat:@"%.2f ％", ach];
    if(ach ==100) {
        _commentTotalLabel.text = @"よくできた！！";
    } else if(ach > 75) {
        _commentTotalLabel.text = @"もうちょっと！！";
    } else if(ach >= 0) {
        _commentTotalLabel.text = @"まだまだ！！";
    } else {
        _commentTotalLabel.text = @"？？？";
    }

    // 背景色
    _todayView.backgroundColor = [UIColor yellowColor];
    _totalView.backgroundColor = [UIColor redColor];
    
    // 画像（とりあえず）
    [_imageToday setImage:[UIImage imageNamed:@"right.png"]];
    [_imageTotal setImage:[UIImage imageNamed:@"wrong.png"]];
    [_imageComment setImage:[UIImage imageNamed:@"icon@120x120.png"]];



}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
