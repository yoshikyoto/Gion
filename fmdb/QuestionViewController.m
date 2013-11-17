//
//  QuestionViewController.m
//  test
//
//  Created by Yoshiyuki Sakamoto on 2013/10/14.
//  Copyright (c) 2013年 HeyaYshirtY. All rights reserved.
//

#import "QuestionViewController.h"
#import "ResultViewController.h"
#import "QuestionNavigationController.h"

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
    [self.navigationItem setHidesBackButton:YES];
    
    // 問題
    QuestionNavigationController *qnc = (QuestionNavigationController *)self.navigationController;
    _text = [qnc.selectedTexts objectAtIndex:_questionNum];
    NSString *qsentence = [_text.text stringByReplacingOccurrencesOfString :_text.word withString:@"_____"];
    NSMutableArray *all_texts = [qnc.allTexts mutableCopy];
    [all_texts removeObject:_text];
    NSMutableArray *answer_detail_array = [[NSMutableArray alloc] init];
    
    UILabel *questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 300, 60)];
    questionLabel.numberOfLines = 3;
    questionLabel.text = qsentence;
    [[self view] addSubview:questionLabel];
    
    // タイトル設定
    self.navigationItem.title = [NSString stringWithFormat:@"%d問目", [[self.navigationController viewControllers] count]];
    
    // 選択肢
    // 正解の位置をランダムで決定
    _correctAnswerInt = arc4random()%4;
    // 選択肢記憶用の配列の初期化
    _answerButtonArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < 4; i++){
        // ボタン初期化
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(20, 180+50*i, 280, 40);
         [[button layer] setBorderWidth:1.0f]; // ボタンの境界線
        button.tag = i; // 何番目の選択肢か
        // タップされた時の処理
        [button addTarget:self action:@selector(answerQuestion:)forControlEvents:UIControlEventTouchUpInside];
        [[self view] addSubview:button];
        
        // 正解 or 間違い
        if(i == _correctAnswerInt){
            // 正解
            [button setTitle:_text.word forState:UIControlStateNormal];
            [answer_detail_array addObject:_text];
        }else{
            // 間違い
            // 間違いの単語をランダムで選ぶ
            Text *incorrect_text = [all_texts objectAtIndex:arc4random()%[all_texts count]];
            NSString *button_text = incorrect_text.word;
            [button setTitle:button_text forState:UIControlStateNormal];
            // 選ばれたテキストは array から除去
            [all_texts removeObject:incorrect_text];
            [answer_detail_array addObject:incorrect_text];
        }
        // ボタンをarrayに追加
        [_answerButtonArray addObject:button];
    }
    [qnc.answerDetail addObject:answer_detail_array];
    
    is_button_tapped = false;
}

- (void)answerQuestion:(UIButton *)sender{
    if(is_button_tapped) return;
    is_button_tapped = true;
    
    NSLog(@"%s 選ばれた答え: %d", __func__, sender.tag);
    
    // 選択した答えを記録
    _selectAnswertInt = sender.tag;
    
    /*
    UILabel *result_label = [[UILabel alloc] initWithFrame:CGRectMake(110, 160, 100, 100)];
    result_label.textColor = [UIColor redColor];
    result_label.textAlignment = NSTextAlignmentCenter;
    
    UILabel *result_text_label = [[UILabel alloc] initWithFrame:CGRectMake(60, 260, 200, 40)];
    result_text_label.textColor = [UIColor redColor];
    result_text_label.textAlignment = NSTextAlignmentCenter;
    result_text_label.font = [UIFont boldSystemFontOfSize:40];
     */
    UIImageView *result_image = [[UIImageView alloc] initWithFrame:CGRectMake(60, 200, 200, 240)];
    
    if(sender.tag == _correctAnswerInt){
        // 正解した場合
        [result_image setImage:[UIImage imageNamed:@"right.png"]];
        _result = true; // 正解したことを記憶
        // 正解のカウントを増やす
        [_text rightAnswerSelected];
        QuestionNavigationController *qnc = (QuestionNavigationController *)self.navigationController;
        qnc.correctCount++;
    }else{
        // 間違えた場合
        [result_image setImage:[UIImage imageNamed:@"wrong.png"]];
        _result = false; // 間違えたことを記憶
        [_text wrongAnswerSelected];
    }
    [[self view] addSubview:result_image];
    // ◯×表示してから少し時間おく
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    
    QuestionNavigationController *qnc = (QuestionNavigationController *)self.navigationController;

    // 5問としておく
    if(_questionNum < [qnc.selectedTexts count]-1){
        QuestionViewController *qvc = [[QuestionViewController alloc] init];
        qvc.questionNum = _questionNum + 1;
        [self.navigationController pushViewController:qvc animated:YES];
    }else{
        // 結果画面
        ResultViewController *rvc = [[ResultViewController alloc] init];
        //UINavigationController *qnc = [[UINavigationController alloc] initWithRootViewController:rvc];
        
        [self.navigationController pushViewController:rvc animated:YES];
        //[self presentViewController:rvc animated:YES completion:nil];
        //[self presentViewController:qnc animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
