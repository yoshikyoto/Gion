//
//  Text.m
//  fmdb
//
//  Created by horita on 2013/10/14.
//  Copyright (c) 2013年 horita. All rights reserved.
//

#import "Text.h"
#import "FMDatabase.h"

#define DB_FILE_NAME @"text.db"

@implementation Text
@synthesize textid;
@synthesize text;
@synthesize word;
@synthesize meaning;
@synthesize right;
@synthesize wrong;

- (void)rightAnswerSelected{
    NSLog(@"%s", __func__);
	// Do any additional setup after loading the view.
    
    right++;
    [self updateDatabase];
    NSLog(@"right:%d",right);
}

- (void)wrongAnswerSelected{
    
    wrong++;
    [self updateDatabase];
    NSLog(@"wrong:%d",wrong);
}

- (void)updateDatabase{
    NSLog(@"%s　%d %d %d", __func__, textid, right, wrong);
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
    FMDatabase* db = [FMDatabase databaseWithPath:writableDBPath];
    
    // データベースを開く．開けなかったらログを吐く
    if(![db open])
    {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    [db setShouldCacheStatements:YES];
    
    // SQL文を生成
    NSString* sql = [NSString stringWithFormat:@"UPDATE text SET right = %d, wrong = %d WHERE textid = %d", right, wrong, textid];
    if([db executeQuery:sql]){
        NSLog(@"更新できた？");
    }else{
        NSLog(@"更新できなかった");NSLog(@"Error %@ - %d", [db lastErrorMessage], [db lastErrorCode]);

    }
    //更新できなかった時の処理
    NSLog(@"Error %@ - %d", [db lastErrorMessage], [db lastErrorCode]);
    [db close];
}



/* 
 ソート関数
 */
@end
