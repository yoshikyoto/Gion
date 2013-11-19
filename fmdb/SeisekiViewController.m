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
    //[self updateLabel];
}

-(void)viewWillAppear:(BOOL)animated {
    [self updateLabel];
}

- (void)updateLabel{
    /**********************
     必要なデータを取得し代入していく
     2013.11.19 by horita
     **********************/

    // NSUserDefaultから継続日数と最高継続日数を取得
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    int running = 1;
    int running_max = 1;
    if([ud objectForKey:@"RUNNING"] != NULL) {
        running = [ud integerForKey:@"RUNNING"];
        running_max = [ud integerForKey:@"RUNNINGMAX"];
    }
    _runningLabel.text = [NSString stringWithFormat:@"%d日連続継続中！", running];
    _runningMaxLabel.text = [NSString stringWithFormat:@"(最高記録 %d日)", running_max];
    [_imageComment setImage:[UIImage imageNamed:@"botsu.png"]];
    if(running >=7) {
        [_imageComment setImage:[UIImage imageNamed:@"sonochoshi.png"]];
    }
    if(running >= 30) {
        [_imageComment setImage:[UIImage imageNamed:@"gyafun.png"]];
    }
    if(running<2 && running_max<=3 && running_max>1) {
        [_imageComment setImage:[UIImage imageNamed:@"mikka.png"]];
    }
    if(running<2 && running_max<=7 && running_max>=4) {
        [_imageComment setImage:[UIImage imageNamed:@"ashitakara.png"]];
    }
    
    
    // NSUserDefaultから今日の日付を取得
    NSDate* date = [ud objectForKey:@"DATE"];
    if(date == NULL) date = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]]; // dateが空ならシステムから現在日時取得
    // 今日の日付のフォーマットを修正
    NSDateFormatter* form = [[NSDateFormatter alloc] init];
    [form setDateFormat:@"MM/dd(EEE)"];
    NSString* str = [form stringFromDate:date];
    _todayDateLabel.text = [NSString stringWithFormat:@"%@",str];

    
    // 今日の成績：正解数を取得
    if([ud objectForKey:@"TODAYSRESULT"] != NULL) { // 今日既にテストを受けてある
        int todaysresult = [ud integerForKey:@"TODAYSRESULT"];
        int achToday = (double)todaysresult / 5 * 100;
        //NSLog(@"achToday%d ％", achToday);
        _achievementTodayLabel.text = [NSString stringWithFormat:@"%d ％", achToday];
        _rightAllTodayLabel.text = [NSString stringWithFormat:@"(正解数 %d問 / 全 %d問)", todaysresult, 5];
        if(achToday ==100) {
            _commentTodayLabel.text = @"よくできた！！";
            [_imageToday setImage:[UIImage imageNamed:@"perfect.png"]];
        } else if(achToday >= 60) {
            _commentTodayLabel.text = @"もうちょっと！！";
            [_imageToday setImage:[UIImage imageNamed:@"iikanji.png"]];
        } else if(achToday >= 20) {
            _commentTodayLabel.text = @"まだまだ！！";
            [_imageToday setImage:[UIImage imageNamed:@"mottoganbareru.png"]];
        } else if(achToday >= 0){
            _commentTodayLabel.text = @"うーん…";
            [_imageToday setImage:[UIImage imageNamed:@"motto.png"]];
        } else {
            _commentTodayLabel.text = @"？？？";
            [_imageToday setImage:[UIImage imageNamed:@"right.png"]];
        }
    } else {                                        // 今日まだテストを受けてない
        _commentTodayLabel.numberOfLines =3;
        _commentTodayLabel.text = @"今日の単語を覚えてテストを受けよう！";
        _achievementTodayLabel.text = [NSString stringWithFormat:@"%s ％", "--"];
        _rightAllTodayLabel.text =[NSString stringWithFormat:@"(正解数 %s問 / 全 %d問)", "--", 5];
    }
    
    // 総合成績：問題数，正解数を取得
    GionTabBarController *tabbar = (GionTabBarController *)self.tabBarController;
    NSMutableArray *texts = tabbar.texts;
    int all_texts_count = [texts count];
    int right_texts_count = 0;
    for(int i = 0; i < [texts count]; i++){
        Text *text = [texts objectAtIndex:i];
        if(text.right > 0){
            //NSLog(@"%@ 習得", text.word);
            right_texts_count++;
        }else{
            //NSLog(@"%@　未習得", text.word);
        }
    }
    _rightAllLabel.text = [NSString stringWithFormat:@"(正解数 %d問 / 全 %d問)", right_texts_count, all_texts_count];

    
    // 総合成績：達成度の計算と達成度コメントの設定
    double ach = (double)right_texts_count / (double)all_texts_count * 100;
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
    if(ach>=90) {
        [_imageComment setImage:[UIImage imageNamed:@"sugoi.png"]];
    }

    // 背景色
    _todayView.backgroundColor = lightColor;
    _totalView.backgroundColor = lightColor;
    
    // 画像（とりあえず）
    [_imageTotal setImage:[UIImage imageNamed:@"wrong.png"]];



}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
