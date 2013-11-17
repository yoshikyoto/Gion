//
//  DetailViewController.m
//  fmdb
//
//  Created by horita on 2013/10/14.
//  Copyright (c) 2013年 horita. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize text;
@synthesize _text;
@synthesize word;
@synthesize meaning;
@synthesize right;
@synthesize wrong;


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
    _text.text = text.text;
    word.text = text.word;
    meaning.text = text.meaning;
    right.text = [[NSString alloc] initWithFormat:@"%d回",text.right];
    wrong.text = [[NSString alloc] initWithFormat:@"%d回",text.wrong];

    /*
     目標：objective-cでの文字列操作とかNSLogの使い方を覚える
     
     やりたいこと：単語を選んで詳細画面を表示するときに，NSLogで問題文を吐くようにしたい
     例：単語「ゆらゆら」→問題文「地面が________と揺れた気がした。」
     
     例文は_text.textに入っている
     _text.textは破壊してはいけない
     最後にNSLog(@"%@", mondaibun);とか書くと思う
     
     ぐうぐうの例文だけは特殊っぽいのでまあスルーでもOK
     がんばろう！
     */
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.tableView reloadData];
}


- (id)initWithText:(Text *)t{
    self = [super init];
    if(self){
        NSLog(@"%s", __func__);
        text = t;
        // 背景
        self.view.backgroundColor = [UIColor whiteColor];
        
        // 単語
        UILabel *word_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 320, 40)];
        word_label.font = [UIFont systemFontOfSize:28];
        word_label.textAlignment = NSTextAlignmentCenter;
        word_label.text = text.word;
        [[self view] addSubview:word_label];
        
        // 意味
        UILabel *meaning_index_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 320, 20)];
        meaning_index_label.textAlignment = NSTextAlignmentCenter;
        meaning_index_label.text = @"意味";
        [[self view] addSubview:meaning_index_label];
        
        UILabel *meaning_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, 320, 50)];
        meaning_label.textAlignment = NSTextAlignmentCenter;
        meaning_label.text = text.meaning;
        meaning_label.numberOfLines = 2;
        [[self view] addSubview:meaning_label];
        
        // 例文
        UILabel *text_index_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, 320, 20)];
        text_index_label.textAlignment = NSTextAlignmentCenter;
        text_index_label.text = @"例文";
        [[self view] addSubview:text_index_label];
        
        UILabel *text_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 260, 320, 50)];
        text_label.textAlignment = NSTextAlignmentCenter;
        text_label.text = text.text;
        text_label.numberOfLines = 2;
        [[self view] addSubview:text_label];
        
        // 正解した！
        UILabel *right_index_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 360, 160, 20)];
        right_index_label.textAlignment = NSTextAlignmentCenter;
        right_index_label.text = @"　正解した！";
        [[self view] addSubview:right_index_label];
        
        UILabel *right_count_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 390, 160, 20)];
        right_count_label.textAlignment = NSTextAlignmentCenter;
        right_count_label.text = [NSString stringWithFormat:@"%d回", text.right];
        NSLog(@"right->%d",text.right);
        [[self view] addSubview:right_count_label];
        
        // 間違えた…
        UILabel *wrong_index_label = [[UILabel alloc] initWithFrame:CGRectMake(161, 360, 160, 20)];
        wrong_index_label.textAlignment = NSTextAlignmentCenter;
        wrong_index_label.text = @"　間違えた…";
        [[self view] addSubview:wrong_index_label];
        
        UILabel *wrong_count_label = [[UILabel alloc] initWithFrame:CGRectMake(161, 390, 160, 20)];
        wrong_count_label.textAlignment = NSTextAlignmentCenter;
        wrong_count_label.text = [NSString stringWithFormat:@"%d回", text.wrong];
        NSLog(@"wrong->%d",text.wrong);
        [[self view] addSubview:wrong_count_label];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
