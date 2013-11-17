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
#import "FMDatabase.h"
//#import "FMResultSet.h"
#import "Text.h"
#import "DetailViewController.h"

#define DB_FILE_NAME @"text.db"

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
    //tango_view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    tango_view.frame = CGRectMake(0, 60, 320, 370);
    [[self view] addSubview:tango_view];
    
    // ここで単語
    GionTabBarController *tab_bar = (GionTabBarController *)self.tabBarController;
    _allTexts = tab_bar.texts;
    //_selectedTexts = tab_bar.texts;

    _todaysTexts = [[NSMutableArray alloc] init];
    [self initTodaysTexts];
    //_todaysTexts = [self randomQuestion:5 :_todaysTexts];
    
    
    // 単語5つ
    int position_y = 10;
    for(int i = 0; i < [_todaysTexts count]; i++){
        Text *text = [_todaysTexts objectAtIndex:i];
        // ボタン。実際にはタップして移動するようにする
        UIButton *tango_button = [UIButton buttonWithType:UIButtonTypeCustom];
        tango_button.frame = CGRectMake(0, position_y, 320, 100);
        tango_button.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]; // 分かりやすいように色つける
        tango_button.tag = i;
        [tango_button addTarget:self action:@selector(tangoTapped:)forControlEvents:UIControlEventTouchUpInside];
        [tango_view addSubview:tango_button];
        
        // 単語表示用 UILabel
        UILabel *tango_label = [[UILabel alloc] initWithFrame:CGRectMake(10, position_y, 300, 20)];
        tango_label.text = text.word; //[NSString stringWithFormat:@"単語%d", i];
        tango_label.textColor = [UIColor darkGrayColor];
        tango_label.font = [UIFont systemFontOfSize:14];
        [tango_view addSubview:tango_label]; // ScrollView に addSubview
        position_y += 20;
        
        // 単語の意味表示
        UILabel *meaning_label = [[UILabel alloc] initWithFrame:CGRectMake(10, position_y, 300, 15)];
        meaning_label.text = text.meaning; //@"意味";
        meaning_label.textColor = [UIColor grayColor];
        meaning_label.font = [UIFont systemFontOfSize:12];
        [tango_view addSubview:meaning_label]; // ScrollView に addSubview
        position_y += 15;
        
        // 例文
        UILabel *reibun_rabel = [[UILabel alloc] initWithFrame:CGRectMake(10, position_y, 300, 65)];
        reibun_rabel.numberOfLines = 3; // 行数
        reibun_rabel.text = text.text; //[NSString stringWithFormat:@"”%@”", @"例文テキストーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー"];
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

// 単語がタップされたとき
- (void)tangoTapped:(UIButton *)sender{
    Text *sender_text = [_todaysTexts objectAtIndex:sender.tag];
    DetailViewController *dvc = [[DetailViewController alloc] initWithText:sender_text];
    //dvc.text = [_todaysTexts objectAtIndex:sender.tag];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)initTodaysTexts{
    // このへんは呪文
    NSLog(@"%s 課題 for 増野 ここから", __func__);
    GionTabBarController *tab = (GionTabBarController *)self.tabBarController;
    FMDatabase *db = tab.db;
    /******************************************************************
     * 課題 For 増野　＠2013/11/11
     * まず定義
     *  ・未習得の単語：正解数と間違え数がともに 0 である単語
     *  ・間違えた単語：正解数が 0 で、間違え数が 1以上 である単語
     *
     * 1. 以下のコメント付きサンプルコードをもとに、以下のアルゴリズムを生成せよ
     *  ・未習得の単語からランダムで3つ選ぶ
     *  ・間違えた単語から2つ選ぶ
     *
     * 2. 結果を _todaysTexts 配列に入れよ
     *
     * オプショナル課題
     * ・間違えた単語が1つ以下しかない場合にも対応しよう
     * ・未習得の単語が2つ以下しかない場合にも対応しよう
     ******************************************************************/
    
    // SQL文を生成　itemというテーブルの right属性と、wrong属性に、正解数、間違い数が入っている。
    // これは、全部のデータを取ってくる文
    NSString *sql_string = [NSString stringWithFormat:@"SELECT * FROM item WHERE right >= 0, wrong >= 0"];
    
    // データベースを開いて、SQL文を実行
    [db open];
    FMResultSet* rs = [db executeQuery:sql_string];
    // 得られた結果を result_texts という配列に入れる
    NSMutableArray *result_texts = [[NSMutableArray alloc] init]; // インスタンス生成
    while([rs next]){
        Text *text = [[Text alloc] init];
        
        text.textid = [rs intForColumn:@"textid"];
        text.text = [rs stringForColumn:@"text"];
        text.word = [rs stringForColumn:@"word"];
        text.meaning = [rs stringForColumn:@"meaning"];
        text.right = [rs intForColumn:@"right"];
        text.wrong = [rs intForColumn:@"wrong"];
        
        [result_texts addObject:text];
    }
    NSLog(@"%d個の単語が見つかりました", [result_texts count]);
    
    // ランダムで5つ選ぶ (PhyoさんのrandomQuestion関数使用) → _todaysTexts に追加する。
    NSMutableArray *random_texts = [self randomQuestion:5 :result_texts];
    [_todaysTexts addObjectsFromArray:random_texts];
    
    // 配列を出力してみる
    [self printArray:_todaysTexts];
    
    // データベースを閉じる
    [db close];
    
    NSLog(@"%s 課題 ここまで", __func__);
}

- (NSMutableArray *)randomQuestion:(int)n :(NSMutableArray *)array{
    NSLog(@"ここからスタート");
    /*------------------------------------------------------------------------------------------------------------------------------------
     Phyo さんへの課題　目標 NSMutableArray の理解
     mTexts は、NSMutableArray というクラスのインスタンス
     Text というクラスがある。
     
     １．新しく NSMutableArray のインスタンスを作る！
     
     ２．arc4random() の値を 5 つ NSLogで出力してみよう！
     ヒント：NSLog(@"%d", arc4random());
     
     ３．そこに、mTexts、からランダムとってきた単語5つを挿入する！
     ランダム関数は arc4random() を使えるはず（多分）
     ヒント：単語がいくつあるのか調べないといけない
     NSMutableArray の count メソッド
     NSMutableArray の objectAtIndex, addObject メソッド
     arc4random()%n　の意味
     
     ４．選ばれた単語の例文を NSLog で出力する
     
     ５．できれば重複がなくなるようにする
     ----------------------------------------------------------------------------------------------------------------------------------*/
    // ここからコードを書き始めてください。
    // １．新しく NSMutableArray のインスタンスを作る！
    _todaysTexts = [[NSMutableArray alloc] init];
    
    
    // ２．arc4random() の値を 5 つ NSLogで出力してみよう！
    // ヒント：NSLog(@"%d", arc4random());
    // http://tryworks-design.com/?p=280
    //重複しない
    NSMutableArray *all = [_allTexts mutableCopy];
    NSMutableArray *result_array = [[NSMutableArray alloc] init];

    int a[n];
    for (int i=0; i<n;i++){
        a[i] = arc4random() % [all count];
        /*
        int x = a[i];
        for (i = 0; i<5; i++){
           if(a[i] ==x)
                break;
        }
         */
        [result_array addObject:[all objectAtIndex:a[i]]];
        [all removeObjectAtIndex:a[i]];
    }
    
    /* 乱数を出力する
    for (int i = 0 ; i<5; i++){
        NSLog(@"%d",a[i]);
    }
     */
    
    /*
    for (int i=0; i<5;i++){
        Text *t = [_allTexts objectAtIndex:a[i]];
        NSLog(@"%@", t.text);
        [_todaysTexts addObject:t];
    }
     */
    return result_array;
}

- (void)viewQuestion:(id)sender{
    NSLog(@"%s", __func__);
    // 画面表示
    QuestionViewController *qvc = [[QuestionViewController alloc] init];
    // 最初の問題
    qvc.questionNum = 0;
    
    /******************************************************************
     * Phyoさんへの課題 11月 6日
     * before っていう NSMutebleArray のインスタンスがある。
     * before には今日の単語が5個入ってます
     * やりたいこと： before の中身を並べ替えた after を作りたい。
     *
     * 0. for 文とかループを使う
     * 1. arc4random() % [before count]
     * 2. [before objectAtIndex:0]; とかで中身を見る
     * 3. [before removeObjectAtIndex:0]; とかで中身が消える
     * 4. [after addObject:なんたらかんたら];  で中身を追加
     *
     * わからなくなったらぐぐるか facebook
     ******************************************************************/
    
    NSMutableArray *before = [_todaysTexts mutableCopy];
    NSMutableArray *after = [[NSMutableArray alloc] init];
    
    // ここからスタート
    int a[5];
    for(int i = 0; i< 5; i++){
        a[i] = arc4random() % [before count];
        Text *nakami = [before objectAtIndex:a[i]];
        [before removeObjectAtIndex :a[i]];
        [after addObject:nakami];
    }
    
    // ここで配列の内容を出力
    NSLog(@"並び替え前");
    [self printArray:before];
    NSLog(@"並び替え後");
    [self printArray:after];
    
    QuestionNavigationController *qnc = [[QuestionNavigationController alloc] initWithRootViewController:qvc];
    qnc.allTexts = _allTexts;
    qnc.selectedTexts = after;
    
    [self presentViewController:qnc animated:YES completion:nil];
}

- (void)printArray:(NSMutableArray *)array{
    for(int i = 0; i < [array count]; i++){
        Text *t = [array objectAtIndex:i];
        NSLog(@"%@", t.word);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
