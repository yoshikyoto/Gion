//
//  GionTabBarController.m
//  fmdb
//
//  Created by Yoshiyuki Sakamoto on 2013/10/25.
//  Copyright (c) 2013年 horita. All rights reserved.
//

#import "GionTabBarController.h"

#define DB_FILE_NAME @"text.db"

@interface GionTabBarController ()

@end

@implementation GionTabBarController

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
    // 色
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:119/255.0 green:147/255.0 blue:60/255.0 alpha:1.0];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UITabBar appearance].barTintColor = [UIColor colorWithRed:235/255.0 green:241/255.0 blue:222/255.0 alpha:1.0];
    
    // アイコン
    UIImage *today_on = [[UIImage imageNamed:@"today_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *today_off = [[UIImage imageNamed:@"today_off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *today_item = [[UITabBarItem alloc] initWithTitle:@"今日の単語" image:today_off selectedImage:today_on];

    UIImage *seiseki_on = [[UIImage imageNamed:@"seiseki_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *seiseki_off = [[UIImage imageNamed:@"seiseki_off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *seiseki_item = [[UITabBarItem alloc] initWithTitle:@"成績" image:seiseki_off selectedImage:seiseki_on];

    UIImage *dict_on = [[UIImage imageNamed:@"dict_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *dict_off = [[UIImage imageNamed:@"dict_off"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *dict_item = [[UITabBarItem alloc] initWithTitle:@"辞書" image:dict_off selectedImage:dict_on];

    //item.selectedImage = image;
    UIViewController *today = [self.viewControllers objectAtIndex:0];
    UIViewController *seiseki = [self.viewControllers objectAtIndex:1];
    UIViewController *dict = [self.viewControllers objectAtIndex:2];

    today.tabBarItem = today_item;
    seiseki.tabBarItem = seiseki_item;
    dict.tabBarItem = dict_item;
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // このへんは呪文（サンプルのコピペ）
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DB_FILE_NAME];
    BOOL success = [fileManager fileExistsAtPath:writableDBPath];
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_FILE_NAME];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    }
    if(!success){
        NSAssert1(0, @"failed to create writable db file with message '%@'.", [error localizedDescription]);
    }
    
    // データベースを扱う変数を定義しを初期化
    _db = [FMDatabase databaseWithPath:writableDBPath];
    
    // データベースを開く．開けなかったらログを吐く
    if(![_db open])
    {
        NSLog(@"Err %d: %@", [_db lastErrorCode], [_db lastErrorMessage]);
    }
    
    [_db setShouldCacheStatements:YES];

    // SQL文を生成．ここではすべてをid順に持ってくるという文
    NSString* sql = @"SELECT * FROM text ORDER BY textid DESC;";
    FMResultSet* rs = [_db executeQuery:sql];
    
    // データのTextクラスを初期化
    _texts = [[NSMutableArray alloc] init];
    
    // データベースのデータを1つ1つTextクラスのインスタンスとして保存していく
    while( [rs next] )
    {
        Text *text = [[Text alloc] init];
        
        text.textid = [rs intForColumn:@"textid"];
        text.text = [rs stringForColumn:@"text"];
        text.word = [rs stringForColumn:@"word"];
        text.meaning = [rs stringForColumn:@"meaning"];
        text.right = [rs intForColumn:@"right"];
        text.wrong = [rs intForColumn:@"wrong"];
        
        [_texts addObject:text];
    }
    
    [rs close];
    [_db close];
    
    // 新しいクラスを作成しました。
    //GionDatabaseManager *GDBM = [[GionDatabaseManager alloc] init];
    //_texts = [GDBM executeSQL:@"SELECT * FROM text ORDER BY textid DESC"];
    
    NSLog(@"%s end %d", __func__, [_texts count]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
