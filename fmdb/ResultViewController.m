//
//  ResultViewController.m
//  test
//
//  Created by Yoshiyuki Sakamoto on 2013/10/14.
//  Copyright (c) 2013年 HeyaYshirtY. All rights reserved.
//

#import "ResultViewController.h"
#import "ResultDetailView.h"
#import "QuestionNavigationController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

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
    // 戻るボタン消す
    [self.navigationItem setHidesBackButton:YES];
    // 背景
    [self view].backgroundColor = [UIColor whiteColor];
    // タイトル設定
    self.navigationItem.title = @"結果";
    
    // 結果
    UILabel *result_label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 70, 80, 30)];
    result_label1.text = @"5問中";
    [[self view] addSubview:result_label1];
    
    // NavigationController から正解数を取得
    QuestionNavigationController *qnc = (QuestionNavigationController *)self.navigationController;
    UILabel *result_label2 = [[UILabel alloc] initWithFrame:CGRectMake(120, 70, 80, 30)];
    result_label2.text = [NSString stringWithFormat:@"%d", qnc.correctCount];
    [[self view] addSubview:result_label2];
    

    UILabel *result_label3 = [[UILabel alloc] initWithFrame:CGRectMake(200, 70, 80, 30)];
    result_label3.text = @"問正解";
    [[self view] addSubview:result_label3];
    
    // 結果詳細（間違えた問題とか）
    ResultDetailView *detail_view = [[ResultDetailView alloc] initWithQNC:qnc];
    detail_view.frame = CGRectMake(0, 100, 320, 320);
    // detail_view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    [[self view] addSubview:detail_view];
    
    // 閉じるボタン
    UIButton *close_button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [close_button setTitle:@"とじる" forState:UIControlStateNormal];
    close_button.frame = CGRectMake(60, 420, 200, 30);
    [close_button addTarget:self action:@selector(close:)forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:close_button];
    
    [self updateRunningDate];
    
    // テストが終了したことを通知出す（きっと役に立つ）
    NSNotification *n = [NSNotification notificationWithName:@"TestFinished" object:self];
    [[NSNotificationCenter defaultCenter] postNotification:n];
}

- (void)updateRunningDate{
    NSLog(@"%s", __func__);
    // NSUserDefaultsを使って継続日数を管理する
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]]; // タイムゾーンに合わせて現在日時取得
    //NSDate* yesterday = [NSDate dateWithTimeIntervalSinceNow:-1*24*60*60];
    
    // 初回起動時用の初期化
    [md setObject:date forKey:@"DATE"]; // DATEは今回の起動日時を記録．ただし今日2回目以降の起動であれば更新されない．
    [md setObject:date forKey:@"LASTDATE"]; // LASTDATEは前回の起動日時を記録．ただし今日2回目以降の起動であれば更新されない．
    [md setObject:@"0" forKey:@"RUNNING"]; // RUNNINGは今の連続起動日数
    [md setObject:@"0" forKey:@"RUNNINGMAX"]; // RUNNINGMAXは過去で一番長い連続起動日数
    [defaults registerDefaults:md];
    
    
    // この起動が今日1回目かチェック
    NSDate* lastDate = [defaults objectForKey:@"DATE"];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy/MM/dd";
    NSString *str1 = [df stringFromDate:date]; // 今回起動（日付のみ）
    NSString *str2 = [df stringFromDate:lastDate]; // 前回起動（日付のみ）
    
    if ([str1 isEqualToString:str2]) {
        // 今日2回目以降の起動だったら何もしない
    } else {
        [defaults setObject:lastDate forKey:@"LASTDATE"]; // 前回起動が前日かそれより前であれば前回起動日時を更新
        [defaults setObject:date forKey:@"DATE"]; // 今回起動日時を更新
        
        // 連続起動日数を確認する
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        NSString *nowDateStr = [dateFormatter stringFromDate:date];
        NSString *lastDateStr = [dateFormatter stringFromDate:lastDate];
        NSDate *nowDate1 = [dateFormatter dateFromString:nowDateStr]; // 今回起動（日付のみ）
        NSDate *lastDate1 = [dateFormatter dateFromString:lastDateStr]; // 前回起動（日付のみ）
        NSTimeInterval since =[nowDate1 timeIntervalSinceDate:lastDate1]; // since/(24*60*60)が今回と前回の日付の差分
        //NSLog(@"%f日", since/(24*60*60));//日付の差分
        
        NSInteger running = [defaults integerForKey:@"RUNNING"];
        if(since/(24*60*60) == 1) { // 昨日も起動していたら連続日数を+1する
            [defaults setInteger:++running forKey:@"RUNNING"];
            NSInteger runningmax = [defaults integerForKey:@"RUNNINGMAX"];
            if(runningmax<running) {
                [defaults setInteger:running forKey:@"RUNNINGMAX"];
            }
        } else if(since/(24*60*60) > 1){ // 昨日は起動していなかったら連続日数を0にする
            NSInteger runningmax = [defaults integerForKey:@"RUNNINGMAX"];
            if(runningmax<running) {
                [defaults setInteger:running forKey:@"RUNNINGMAX"];
            }
            [defaults setInteger:0 forKey:@"RUNNING"];
        }
        NSLog( @"最高継続%d日",[defaults integerForKey:@"RUNNINGMAX"]);
    }
    //NSLog( [lastDate description] );
}

- (void)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
