//
//  TodayViewController.m
//  test
//
//  Created by Yoshiyuki Sakamoto on 2013/10/14.
//  Copyright (c) 2013年 HeyaYshirtY. All rights reserved.
//

#import "TodayViewController.h"
#import "QuestionViewController.h"
#import "QuestionNavigationController.h"

@interface TodayViewController ()

@end

@implementation TodayViewController

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
    NSLog(@"%s", __func__);
	// Do any additional setup after loading the view.
    //CGRect screen_rect = [UIScreen mainScreen].applicationFrame;
    
    // 単語を表示するためのビュー (デバッグ用に色をつけてます)
    UIScrollView *tango_view = [[UIScrollView alloc] init];
    tango_view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    tango_view.frame = CGRectMake(0, 0, 320, 320);
    [[self view] addSubview:tango_view];
    
    // 単語5つ
    int position_y = 10;
    for(int i = 0; i < 5; i++){
        // ボタン。実際にはタップして移動するようにする
        UIButton *tango_button = [UIButton buttonWithType:UIButtonTypeCustom];
        tango_button.frame = CGRectMake(0, position_y, 320, 100);
        tango_button.backgroundColor = [UIColor lightGrayColor]; // 分かりやすいように色つける
        [tango_view addSubview:tango_button];
        
        // 単語表示用 UILabel
        UILabel *tango_label = [[UILabel alloc] initWithFrame:CGRectMake(10, position_y, 300, 20)];
        tango_label.text = [NSString stringWithFormat:@"単語%d", i];
        tango_label.font = [UIFont systemFontOfSize:14];
        [tango_view addSubview:tango_label]; // ScrollView に addSubview
        position_y += 20;
        
        // 単語の意味表示
        UILabel *meaning_label = [[UILabel alloc] initWithFrame:CGRectMake(10, position_y, 300, 15)];
        meaning_label.text = @"意味";
        meaning_label.font = [UIFont systemFontOfSize:12];
        [tango_view addSubview:meaning_label]; // ScrollView に addSubview
        position_y += 15;
        
        // 例文
        UILabel *reibun_rabel = [[UILabel alloc] initWithFrame:CGRectMake(10, position_y, 300, 65)];
        reibun_rabel.numberOfLines = 3; // 行数
        reibun_rabel.text = [NSString stringWithFormat:@"”%@”", @"例文テキストーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー"];
        [tango_view addSubview:reibun_rabel];
        position_y += 65;
        
        position_y += 10;
    }
    
    // テスト画面に進むボタン
    UIButton *question_button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    question_button.frame = CGRectMake(100, position_y, 120, 30);
    [question_button setTitle:@"テストへ！" forState:UIControlStateNormal];
    [question_button addTarget:self action:@selector(viewQuestion:)forControlEvents:UIControlEventTouchUpInside];
    [tango_view addSubview:question_button];
    position_y += 30;
    
    position_y += 10;
    // スクロールビューの内部のサイズを決める
    tango_view.contentSize = CGSizeMake(320, position_y);
}

- (void)viewQuestion:(id)sender{
    NSLog(@"%s", __func__);
    // 画面表示
    QuestionViewController *qvc = [[QuestionViewController alloc] init];
    QuestionNavigationController *qnc = [[QuestionNavigationController alloc] initWithRootViewController:qvc];
    [self presentViewController:qnc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
