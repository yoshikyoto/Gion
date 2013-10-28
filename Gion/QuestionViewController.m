//
//  QuestionViewController.m
//  test
//
//  Created by Yoshiyuki Sakamoto on 2013/10/14.
//  Copyright (c) 2013年 HeyaYshirtY. All rights reserved.
//

#import "QuestionViewController.h"
#import "ResultViewController.h"

@interface QuestionViewController ()

@end

@implementation QuestionViewController

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
    // 背景
    [self view].backgroundColor = [UIColor whiteColor];
    
    // タイトル設定
    self.navigationItem.title = [NSString stringWithFormat:@"%d問目", [[self.navigationController viewControllers] count]];
    
    // 仮のラベル
    UILabel *question_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
    question_label.text = @"問題";
    question_label.textAlignment = NSTextAlignmentCenter; // センタリング
    [[self view] addSubview:question_label];
    
    // 選択肢
    for(int i = 0; i < 4; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(20, 180+40*i, 280, 30);
        NSString *button_text = [NSString stringWithFormat:@"選択肢%d", i]; // ボタンの文字
        [button setTitle:button_text forState:UIControlStateNormal];
         [[button layer] setBorderWidth:1.0f]; // ボタンの境界線
        // タップされた時の処理
        [button addTarget:self action:@selector(answerQuestion:)forControlEvents:UIControlEventTouchUpInside];
        [[self view] addSubview:button];
    }
}

- (void)answerQuestion:(UIButton *)sender{
    // 今までのビューの配列を取得
    NSArray *navigation_views = [self.navigationController viewControllers];
    NSLog(@"%s 画面%d", __func__, [navigation_views count]);
    
    // 5問としておく
    if([navigation_views count] < 5){
        QuestionViewController *qvc = [[QuestionViewController alloc] init];
        [self.navigationController pushViewController:qvc animated:YES];
    }else{
        // 結果画面
        ResultViewController *rvc = [[ResultViewController alloc] init];
        [self presentViewController:rvc animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
