//
//  ResultDetailView.m
//  test
//
//  Created by Yoshiyuki Sakamoto on 2013/10/18.
//  Copyright (c) 2013年 HeyaYshirtY. All rights reserved.
//

#import "ResultDetailView.h"
#import "Text.h"
#import "QuestionViewController.h"
#import "DetailViewController.h"

@implementation ResultDetailView

- (id)initWithQNC:(QuestionNavigationController *)qnc{
    NSLog(@"%s", __func__);
    self = [super init];
    if(self) {
        _questionNavigationController = qnc;
        _todayTexts = qnc.selectedTexts;
        NSArray *views_array = qnc.viewControllers;
        // ボタン5つ
        question_array = [[NSMutableArray alloc] init];
        question_button_array = [[NSMutableArray alloc] init];
        
        // ここにすべての選択肢を記録
        all_answer_array = [[NSMutableArray alloc] init];
        
        // y座標
        int position_y = 0;
        
        for(int i = 0; i < 5; i++){
            Text *text = [_todayTexts objectAtIndex:i];
            // 出題されたQuestionviewController
            QuestionViewController *qvc = [views_array objectAtIndex:i];
            
            // 問題文取得
            UIScrollView *question_space = [[UIScrollView alloc] initWithFrame:CGRectMake(0, position_y, 320, 40)];
            [self addSubview:question_space];
            [question_array addObject:question_space];
            question_space.tag = 0;
            // 正解したかどうかで背景を色分けしてみる
            if(qvc.result){
                // 正解
                question_space.backgroundColor =[UIColor colorWithRed:1.0 green:0.85 blue:0.85 alpha:1.0];
            }else{
                // 間違い
                question_space.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:1.0 alpha:1.0];
            }
            position_y += 41;
            
            
            // 問題文
            UIButton *question_button = [UIButton buttonWithType:UIButtonTypeCustom];
            question_button.frame = CGRectMake(0, 0, 320, 40);
            //question_button.backgroundColor = [UIColor grayColor];
            UILabel *question_Label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 310, 40)];
            question_Label.text = text.text;
            question_Label.numberOfLines = 2;
            question_Label.font = [UIFont systemFontOfSize:16];
            question_button.tag = 0;
            [question_button addTarget:self action:@selector(questionButtonTapped:)forControlEvents:UIControlEventTouchUpInside];
            [question_button addSubview:question_Label];
            [question_space addSubview:question_button];
            [question_button_array addObject:question_button];
            
            NSMutableArray *answer_array = [qnc.answerDetail objectAtIndex:i];
            // 選択肢
            for(int j = 0; j < 4; j++){
                Text *answer_text = [answer_array objectAtIndex:j];
                [all_answer_array addObject:answer_text]; // 全答え配列にテキストを追加
                
                UIButton *selection_button = [UIButton buttonWithType:UIButtonTypeCustom];
                selection_button.frame = CGRectMake(0, 41*(j+1), 320, 40);
                selection_button.backgroundColor = [UIColor whiteColor];
                selection_button.tag = i*4 + j;
                UILabel *selection_label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 310, 40)];
                selection_label.text = answer_text.word;//[NSString stringWithFormat:@"ふわふわ%d", j+1];
                [selection_button addTarget:self action:@selector(answerButtonTapped:)forControlEvents:UIControlEventTouchUpInside];
                [selection_button addSubview:selection_label];
                
                UIButton *answer_button = [qvc.answerButtonArray objectAtIndex:j];
                if(answer_button.tag == qvc.correctAnswerInt){
                    // 正解の選択肢だった場合、◯を表示
                    UILabel *result_label = [[UILabel alloc] initWithFrame:CGRectMake(280, 0, 40, 40)];
                    result_label.text = @"◯";
                    [selection_button addSubview:result_label];
                }else if(qvc.selectAnswertInt == j){
                    UILabel *result_label = [[UILabel alloc] initWithFrame:CGRectMake(280, 0, 40, 40)];
                    result_label.text = @"×";
                    [selection_button addSubview:result_label];
                }
                [question_space addSubview:selection_button];
            }
            
            
        }

        /*
        int position_y = 0;
        question_array = [[NSMutableArray alloc] init];
        for(int i = 0; i < 5; i++){
            UIButton *question_button = [UIButton buttonWithType:UIButtonTypeCustom];
            question_button.frame = CGRectMake(0, position_y, 320, 40);
            question_button.backgroundColor = [UIColor lightGrayColor];
            UILabel *question_Label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 310, 40)];
            question_Label.text = [NSString stringWithFormat:@"問題%d", i];
            [question_button addTarget:self action:@selector(questionButtonTapped:)forControlEvents:UIControlEventTouchUpInside];
            [question_button addSubview:question_Label];
            question_button.tag = 0;
            [self addSubview:question_button];
            [button_array addObject:question_button];
            position_y += 41;
        }
         */
    }
    return self;
}

- (void)questionButtonTapped:(UIButton *)sender{
    NSLog(@"%s", __func__);
    // 送られてきたボタンのタグを
    //アニメーションの対象となるコンテキスト
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    //アニメーションを実行する時間
    [UIView setAnimationDuration:0.2];
    //アニメーションイベントを受け取るview
    [UIView setAnimationDelegate:self];
    //アニメーション終了後に実行される
    //[UIView setAnimationDidStopSelector:@selector(endAnimation)];
    
    if(sender.tag == 0){
        for(int i = 0; i < [question_button_array count]; i++){
            UIButton *button = [question_button_array objectAtIndex:i];
            button.tag = 0;
        }
        sender.tag = 1;
    }else{
        sender.tag = 0;
    }
    
    int position_y = 0;
    for(int i = 0; i < [question_button_array count]; i++){
        UIButton *question_button = [question_button_array objectAtIndex:i];
        if(question_button.tag == 1){
            [question_button superview].frame = CGRectMake(0, position_y, 320, 205);
            position_y += 205;
        }else{
            [question_button superview].frame = CGRectMake(0, position_y, 320, 40);
            position_y += 41;
        }
    }
    self.contentSize = CGSizeMake(320, position_y+40);
    
    // アニメーション開始
    [UIView commitAnimations];
}

- (void)answerButtonTapped:(UIButton *)sender{
    NSLog(@"%d", [all_answer_array count]);
    NSLog(@"%s 選択肢の番号: %d", __func__, sender.tag);
    Text *tapped_text = [all_answer_array objectAtIndex:sender.tag];
    NSLog(@"%@", tapped_text.word);
    DetailViewController *dvc = [[DetailViewController alloc] initWithText:[all_answer_array objectAtIndex:sender.tag]];
    [_questionNavigationController pushViewController:dvc animated:YES];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
