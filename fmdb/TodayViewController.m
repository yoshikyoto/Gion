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
#import "FMResultSet.h"
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
    tango_view.frame = CGRectMake(0, 60, 320, screenHeight - 80);
    [[self view] addSubview:tango_view];
    
    // ここで単語
    GionTabBarController *tab_bar = (GionTabBarController *)self.tabBarController;
    _allTexts = tab_bar.texts;
    //_selectedTexts = tab_bar.texts;
    
    _todaysTexts = [[NSMutableArray alloc] init];

    
    if([self isFirstLaunchToday]){
        NSLog(@"%s 今日初回起動である", __func__);
        [self initTodaysTexts];
        //_todaysTexts = [self randomQuestion:5 :_todaysTexts];
        
        // 今日のテキストをシャッフルして
        _todaysTexts = [self shuffleArray:_todaysTexts];
        
        [self saveTodaysTexts];
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.title = @"今日の単語を更新しました！";
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        // 記録
    }else{
        NSLog(@"%s 今日初回起動でない", __func__);
        [self loadTodaysTexts];
    }
    
    /* 枠付きボタンサンプル
     UIButton *dungeon_button = [UIButton buttonWithType:UIButtonTypeCustom];
     dungeon_button.frame = CGRectMake(10, 5 + 58*i, 300, 50);
     dungeon_button.tag = i;
     [dungeon_button addTarget:self action:@selector(dungeonTouched:)forControlEvents:UIControlEventTouchUpInside];
     dungeon_button.backgroundColor = [UIColor colorWithRed:1.0 green:0.95 blue:0.8 alpha:0.9];
     [[dungeon_button layer] setBorderWidth:2.0];
     [[dungeon_button layer] setCornerRadius:6.0];
     [[dungeon_button layer] setBorderColor:[[UIColor colorWithRed:0.6 green:0.3 blue:0.05 alpha:0.8] CGColor]];
     [dungeonView.dungeonListView addSubview:dungeon_button];
     */
    
    // 単語5つ
    int position_y = 10;
    for(int i = 0; i < [_todaysTexts count]; i++){
        Text *text = [_todaysTexts objectAtIndex:i];
        // ボタン。
        UIButton *tango_button = [UIButton buttonWithType:UIButtonTypeCustom];
        tango_button.frame = CGRectMake(10, position_y+10, 300, 115);
        tango_button.backgroundColor = lightColor; // lightColor は GionViewController で指定
        [[tango_button layer] setCornerRadius:8.0]; // 角をまるく
        [[tango_button layer] setBorderWidth:1.0]; // 境界の太さ
        [[tango_button layer] setBorderColor:[darkColor CGColor]];
        // グラデーション
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = tango_button.bounds;
        gradient.colors = @[
                            (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0] CGColor],
                            (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.05] CGColor]
                            ];
        gradient.cornerRadius = 8;
        [tango_button.layer insertSublayer: gradient atIndex: 0];
        // ここまでグラデーション
        tango_button.tag = i;
        [tango_button addTarget:self action:@selector(tangoTapped:)forControlEvents:UIControlEventTouchUpInside]; // タップしたときの
        [tango_view addSubview:tango_button];
        
        // > ←これ
        UIImageView *migi_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"migi.png"]];
        migi_image.frame = CGRectMake(289, position_y+59, 12, 16);
        [tango_view addSubview:migi_image];
        
        // 単語表示部分背景
        UIImageView *tango_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pentagon_mark2.png"]];
        tango_image.frame = CGRectMake(20, position_y-2, 100, 27);
        [tango_view addSubview:tango_image];
        
        // 単語表示用 UILabel
        UILabel *tango_label = [[UILabel alloc] initWithFrame:CGRectMake(20, position_y-3, 100, 20)];
        tango_label.text = text.word;
        tango_label.textColor = [UIColor whiteColor];
        tango_label.font = [UIFont boldSystemFontOfSize:14];
        tango_label.textAlignment = NSTextAlignmentCenter;
        [tango_view addSubview:tango_label];
        position_y += 24;
        
        // 単語の意味表示
        UILabel *meaning_label = [[UILabel alloc] initWithFrame:CGRectMake(20, position_y, 270, 30)];
        meaning_label.text = [NSString stringWithFormat:@"●%@",text.meaning];
        meaning_label.textColor = [UIColor grayColor];
        meaning_label.font = [UIFont systemFontOfSize:12];
        meaning_label.numberOfLines = 2;
        [tango_view addSubview:meaning_label];
        position_y += 30;
        
        // 例文
        UILabel *reibun_rabel = [[UILabel alloc] initWithFrame:CGRectMake(20, position_y, 270, 65)];
        reibun_rabel.numberOfLines = 3;
        reibun_rabel.text = text.text;
        [tango_view addSubview:reibun_rabel];
        position_y += 65;
        
        position_y += 20;
    }
    
    // テスト画面に進むボタン
    UIButton *question_button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    question_button.frame = CGRectMake(0, screenHeight - 70, 320, 42);
    question_button.backgroundColor = buttonColor;
    [question_button setTitleColor:buttonTextColor forState:UIControlStateNormal];
    [question_button setTitle:@" テストを受ける ＞" forState:UIControlStateNormal];
    [question_button addTarget:self action:@selector(viewQuestion:)forControlEvents:UIControlEventTouchUpInside];
    question_button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [[self view] addSubview:question_button];
    position_y += 50;
    
    //position_y += 10;
    // スクロールビューの内部のサイズを決める
    tango_view.contentSize = CGSizeMake(320, position_y);
    
    UIApplication *application = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(forground) name:UIApplicationDidBecomeActiveNotification object:application];
}

- (void)forground{
    NSLog(@"%s", __func__);
    // TODO: バックグラウンドから復帰したときの処理
    [self viewDidLoad];
}

- (BOOL)isFirstLaunchToday{
    // NSUserDefaultsを使って継続日数を管理する
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]]; // タイムゾーンに合わせて現在日時取得
    //NSDate* yesterday = [NSDate dateWithTimeIntervalSinceNow:-1*24*60*60];
    
    // この起動が今日1回目かチェック
    NSDate* lastDate = [defaults objectForKey:@"LAUNCH_TODAIVIEW_DATE"];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateFormat = @"yyyy/MM/dd";
    NSString *str1 = [df stringFromDate:date]; // 今回起動（日付のみ）
    NSString *str2 = [df stringFromDate:lastDate]; // 前回起動（日付のみ）
    
    if ([str1 isEqualToString:str2]) {
        return false;
    } else {
        NSLog(@"%s LAUNCH_TODAIVIEW_DATE を更新", __func__);
        [defaults setObject:date forKey:@"LAUNCH_TODAIVIEW_DATE"]; // 今回起動日時を更新
        [defaults synchronize];
        return true;
    }
}

// 単語がタップされたとき
- (void)tangoTapped:(UIButton *)sender{
    Text *sender_text = [_todaysTexts objectAtIndex:sender.tag];
    DetailViewController *dvc = [[DetailViewController alloc] initWithText:sender_text];
    //dvc.text = [_todaysTexts objectAtIndex:sender.tag];
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)saveTodaysTexts{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    for(int i = 0; i < [_todaysTexts count]; i++){
        Text *text = [_todaysTexts objectAtIndex:i];
        NSString *key = [NSString stringWithFormat:@"TODAYSTEXT%d", i];
        [defaults setInteger:text.textid forKey:key];
    }
    [defaults synchronize];
}

- (void)loadTodaysTexts{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    GionTabBarController *tab = (GionTabBarController *)self.tabBarController;
    FMDatabase *db = tab.db;
    for(int i = 0; i < 5; i++){
        NSString *key = [NSString stringWithFormat:@"TODAYSTEXT%d", i];
        int textid = [defaults integerForKey:key];
        NSLog(@"%d", textid);
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM text WHERE textid = %d", textid];
        [db open];
        FMResultSet* rs = [db executeQuery:sql];
        
        if([rs next]){
            Text *text = [[Text alloc] init];
            
            text.textid = [rs intForColumn:@"textid"];
            text.text = [rs stringForColumn:@"text"];
            text.word = [rs stringForColumn:@"word"];
            text.meaning = [rs stringForColumn:@"meaning"];
            text.right = [rs intForColumn:@"right"];
            text.wrong = [rs intForColumn:@"wrong"];
            
            [_todaysTexts addObject:text];
        }
        [db close];
        [rs close];
    }
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
    // これは、未収得の単語を取ってくる文
    NSString *sql_unchecked = [NSString stringWithFormat:@"SELECT * FROM text WHERE right = 0 AND wrong = 0"];
    
    // これは、間違えた単語を取ってくる文
    NSString *sql_missString = [NSString stringWithFormat:@"SELECT * FROM text WHERE right = 0 AND wrong >= 1"];
    
    // これは、正解したことのある単語を取ってくる文
    NSString *sql_correctString = [NSString stringWithFormat:@"SELECT * FROM text WHERE right >=1 AND wrong >= 0"];
    
    // データベースを開いて、SQL文を実行
    [db open];
    FMResultSet* rsUC = [db executeQuery:sql_unchecked];
    FMResultSet* rsMS = [db executeQuery:sql_missString];
    
    // 得られた結果を unchecked_texts という配列に入れる
    NSMutableArray *unchecked_texts = [[NSMutableArray alloc] init]; // インスタンス生成
    NSLog(@"unchecked な単語");
    while([rsUC next]){
        Text *text = [[Text alloc] init];
        
        text.textid = [rsUC intForColumn:@"textid"];
        text.text = [rsUC stringForColumn:@"text"];
        text.word = [rsUC stringForColumn:@"word"];
        text.meaning = [rsUC stringForColumn:@"meaning"];
        text.right = [rsUC intForColumn:@"right"];
        text.wrong = [rsUC intForColumn:@"wrong"];
        
        [unchecked_texts addObject:text];
        NSLog(@"%@ %d %d", text.word, text.right, text.wrong);
    }
    NSLog(@"%d個の単語が見つかりました", [unchecked_texts count]);
    
    // 得られた結果を missString_texts という配列に入れる
    NSMutableArray *missString_texts = [[NSMutableArray alloc] init];
    NSLog(@"missing な単語");
    while ([rsMS next]) {
        Text *text = [[Text alloc] init];
        
        text.textid = [rsMS intForColumn:@"textid"];
        text.text = [rsMS stringForColumn:@"text"];
        text.word = [rsMS stringForColumn:@"word"];
        text.meaning = [rsMS stringForColumn:@"meaning"];
        text.right = [rsMS intForColumn:@"right"];
        text.wrong = [rsMS intForColumn:@"wrong"];
        
        [missString_texts addObject:text];
        NSLog(@"%@", text.word);
    }
    NSLog(@"%d個の単語が見つかりました", [missString_texts count]);
    
    // 各配列の要素数を確認
    int UCint = [unchecked_texts count];
    int MSint = [missString_texts count];
    NSLog(@"ucint %d, msint %d", UCint, MSint);
    
    // 合計で5つの単語が表示されるように調整（未収得単語・間違い単語を合わせて5つに満たない場合は正解した単語で穴埋め）
    if (UCint >= 3 && MSint >= 2){
        UCint = 3, MSint = 2;
    }else if (UCint < 3 && UCint + MSint >= 5) {
        MSint = 5 - UCint;
    }else if (MSint < 2 && UCint + MSint >= 5) {
        UCint = 5 - MSint;
    }
    
    NSLog(@"ucint %d, msint %d", UCint, MSint);
    
    // 未収得単語をランダムで3つ選ぶ (PhyoさんのrandomQuestion関数使用) → _todaysTexts に追加する。
    NSMutableArray *randomUC_texts = [self randomQuestion: UCint :unchecked_texts];
    //[_todaysTexts addObjectsFromArray:randomBC_texts];
    
    // 間違えた単語を2つ選ぶ → _todaysTexts に追加する
    NSMutableArray *randomMS_texts = [self randomQuestion: MSint :missString_texts];
    //[_todaysTexts addObjectsFromArray:randomMS_texts];
    
    // _todaysTexts = [randomUC_texts arrayByAddingObjectsFromArray:randomMS_texts];
    [self printArray:randomUC_texts];
    [self printArray:randomMS_texts];
    [_todaysTexts addObjectsFromArray:randomUC_texts];
    [_todaysTexts addObjectsFromArray:randomMS_texts];
    
    NSLog(@"%d", [_todaysTexts count]);
    [self printArray:_todaysTexts];
    
    //正解した単語で穴埋め
    if (UCint + MSint < 5) {
        FMResultSet* rsCS = [db executeQuery:sql_correctString];
        NSMutableArray *correctString_texts = [[NSMutableArray alloc] init];
        while ([rsCS next]) {
            Text *text = [[Text alloc] init];
            
            text.textid = [rsCS intForColumn:@"textid"];
            text.text = [rsCS stringForColumn:@"text"];
            text.word = [rsCS stringForColumn:@"word"];
            text.meaning = [rsCS stringForColumn:@"meaning"];
            text.right = [rsCS intForColumn:@"right"];
            text.wrong = [rsCS intForColumn:@"wrong"];
            
            [correctString_texts addObject:text];
        }
        NSMutableArray *randomCS_texts = [self randomQuestion: 5 - UCint  - MSint :correctString_texts];
        
        /* 増野のコード
         NSMutableArray *todaysTextsPro = [randomUC_texts arrayByAddingObjectsFromArray:randomMS_texts];
         _todaysTexts = [todaysTextsPro arrayByAddingObjectsFromArray:randomCS_texts];
         */
        [self printArray:_todaysTexts];
        [_todaysTexts addObjectsFromArray:randomCS_texts];
        [self printArray:randomCS_texts];
        NSLog(@"不足分追加後 %d", [_todaysTexts count]);
    }
    
    // 配列を出力してみる
    [self printArray:_todaysTexts];
    
    // データベースを閉じる
    [db close];
    
    NSLog(@"%s 課題 ここまで増野範囲", __func__);
}

- (NSMutableArray *)randomQuestion:(int)n :(NSMutableArray *)array{
    NSLog(@"ここからスタートpyoさん範囲");
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
    //_todaysTexts = [[NSMutableArray alloc] init];
    
    
    // ２．arc4random() の値を 5 つ NSLogで出力してみよう！
    // ヒント：NSLog(@"%d", arc4random());
    // http://tryworks-design.com/?p=280
    //重複しない
    NSMutableArray *all = [array mutableCopy];
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
    
    /*
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
     */
    
    QuestionNavigationController *qnc = [[QuestionNavigationController alloc] initWithRootViewController:qvc];
    qnc.allTexts = _allTexts;
    qnc.selectedTexts = [self shuffleArray:_todaysTexts];
    
    [self presentViewController:qnc animated:YES completion:nil];
}

- (NSMutableArray *)shuffleArray:(NSMutableArray *)array{
    NSMutableArray *before = [array mutableCopy];
    NSMutableArray *after = [[NSMutableArray alloc] init];
    
    // ここからスタート
    int a[5];
    for(int i = 0; i< 5; i++){
        a[i] = arc4random() % [before count];
        Text *nakami = [before objectAtIndex:a[i]];
        [before removeObjectAtIndex :a[i]];
        [after addObject:nakami];
    }
    return after;
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
