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
    
    NSLog(@"%s end", __func__);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
