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
    NSLog(@"%s", __func__);
    [super viewDidLoad];
    
    // 単語を表示する部分
    UIScrollView *tango_view = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 70, 300, 280)];
    // tango_view.contentSize = CGSizeMake(300, 300);
    tango_view.backgroundColor = lightColor;
    [[tango_view layer] setCornerRadius:10.0]; // 角を丸く
    [[tango_view layer] setBorderWidth:2.0]; // 境界
    [[tango_view layer] setBorderColor:[darkColor CGColor]];
    [[self view] addSubview:tango_view];
    
    int position_y = -65;
    
    // 単語
    if(!word){
        NSLog(@"%s wordが初期化されてない。初期化します", __func__);
        word = [[UILabel alloc] init];
    }
    word.backgroundColor = darkColor;
    word.frame = CGRectMake(0, position_y, 300, 60);
    word.font = [UIFont boldSystemFontOfSize:24];
    word.textColor = lightTextColor;
    word.text = [NSString stringWithFormat:@"%@", text.word];
    word.textAlignment = NSTextAlignmentCenter;
    [tango_view addSubview:word];
    position_y += 60;
    
    position_y += 20;
    
    // 意味
    UILabel *meaning_border = [[UILabel alloc] initWithFrame:CGRectMake(20, position_y, 260, 3)];
    meaning_border.backgroundColor = darkColor;
    [tango_view addSubview:meaning_border];
    UILabel *meaning_index_label = [[UILabel alloc] initWithFrame:CGRectMake(20, position_y, 60, 30)];
    meaning_index_label.textAlignment = NSTextAlignmentCenter;
    meaning_index_label.backgroundColor = darkColor;
    meaning_index_label.textColor = lightTextColor;
    meaning_index_label.text = @"意味";
    [tango_view addSubview:meaning_index_label];
    position_y += 35;
    
    meaning = [[UILabel alloc] initWithFrame:CGRectMake(20, position_y, 260, 40)];
    meaning.numberOfLines = 2;
    meaning.font = [UIFont systemFontOfSize:16];
    meaning.text = text.meaning;
    [tango_view addSubview:meaning];
    
    position_y += 60;
    
    // 例文
    UILabel *text_border = [[UILabel alloc] initWithFrame:CGRectMake(20, position_y, 260, 3)];
    text_border.backgroundColor = darkColor;
    [tango_view addSubview:text_border];
    UILabel *text_index_label = [[UILabel alloc] initWithFrame:CGRectMake(20, position_y, 60, 30)];
    text_index_label.textAlignment = NSTextAlignmentCenter;
    text_index_label.backgroundColor = darkColor;
    text_index_label.textColor = lightTextColor;
    text_index_label.text = @"例文";
    [tango_view addSubview:text_index_label];
    position_y += 35;
    
    _text = [[UILabel alloc] initWithFrame:CGRectMake(20, position_y, 260, 60)];
    _text.numberOfLines = 3;
    _text.font = [UIFont systemFontOfSize:16];
    _text.text = text.text;
    [tango_view addSubview:_text];
    
    // 正解した！
    UILabel *right_bg = [[UILabel alloc] initWithFrame:CGRectMake(10, 360, 140, 60)];
    right_bg.backgroundColor = buttonColor;
    [[right_bg layer] setCornerRadius:10.0];
    [[self view] addSubview:right_bg];
    
    UILabel *right_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 365, 140, 20)];
    right_label.textColor = buttonTextColor;
    right_label.textAlignment = NSTextAlignmentCenter;
    right_label.text = @"正解した！";
    [[self view] addSubview:right_label];
    
    right = [[UILabel alloc] initWithFrame:CGRectMake(10, 382, 140, 40)];
    right.font = [UIFont boldSystemFontOfSize:18];
    right.textColor = buttonTextColor;
    right.textAlignment = NSTextAlignmentCenter;
    [[self view] addSubview:right];
    right.text = [[NSString alloc] initWithFormat:@"%d回",text.right];
    
    // 間違えた…
    UILabel *wrong_bg = [[UILabel alloc] initWithFrame:CGRectMake(170, 360, 140, 60)];
    wrong_bg.backgroundColor = buttonColor;
    [[wrong_bg layer] setCornerRadius:10.0];
    [[self view] addSubview:wrong_bg];
    
    UILabel *wrong_label = [[UILabel alloc] initWithFrame:CGRectMake(170, 365, 140, 20)];
    wrong_label.textAlignment = NSTextAlignmentCenter;
    wrong_label.text = @"間違えた…";
    wrong_label.textColor = buttonTextColor;
    [[self view] addSubview:wrong_label];
    wrong = [[UILabel alloc] initWithFrame:CGRectMake(170, 382, 140, 40)];
    wrong.font = [UIFont boldSystemFontOfSize:18];
    wrong.textColor = buttonTextColor;
    wrong.textAlignment = NSTextAlignmentCenter;
    [[self view] addSubview:wrong];
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
        
        /*
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
         */
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
