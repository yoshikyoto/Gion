//
//  GionDatabaseManager.m
//  Gion
//
//  Created by Yoshiyuki Sakamoto on 2013/11/19.
//  Copyright (c) 2013年 horita. All rights reserved.
//

#import "GionDatabaseManager.h"

@implementation GionDatabaseManager

- (id)init{
    self = [super init];
    if(self){
        NSLog(@"%s", __func__);
        // データベースのファイル名
        NSString *database_filename = @"text.db";
        
        // ファイルマネージャー初期化
        file_manager = [NSFileManager defaultManager];
        // データベースファイルを格納する文書フォルダーのパスを取得
        NSString *workDir_path = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSLog(@"%@", workDir_path);
        // その作業ディレクトリが存在しているかどうかの確認
        if(![file_manager fileExistsAtPath:workDir_path]){
            // ディレクトリが存在していない場合は作成する
            NSLog(@"作業ディレクトリが存在していません %@", workDir_path);
            [file_manager createDirectoryAtPath:workDir_path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        

        // データベースファイルのパスを取得する
        NSString *database_path = [NSString stringWithFormat:@"%@/%@", workDir_path, database_filename];
        
        
        // パスにデータベースが存在しているかを確認
        if(![file_manager fileExistsAtPath:database_path]){
            // データベースのファイルが存在していない場合
            NSLog(@"データベースがありません。作成します。 %@", database_path);
            // テンプレートのデータベースをコピー
            NSString *template_database_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:database_filename];
            if(![file_manager fileExistsAtPath:template_database_path]) NSLog(@"テンプレートファイルが見つからない");
            NSLog(@"テンプレートのパス %@", template_database_path);
            if(![file_manager copyItemAtPath:template_database_path toPath:database_path error:nil]){
                NSLog(@"データベーステンプレートのコピーに失敗しました");
            }
        }
        db = [FMDatabase databaseWithPath:database_path];
    }
    return self;
}

@end
