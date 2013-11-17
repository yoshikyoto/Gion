//
//  MasterTableViewController.m
//  fmdb
//
//  Created by horita on 2013/10/14.
//  Copyright (c) 2013年 horita. All rights reserved.
//

#import "MasterTableViewController.h"
#import "Text.h"
#import "DetailViewController.h"

#define DB_FILE_NAME @"text.db"

@interface MasterTableViewController ()

@end

@implementation MasterTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//インスタンス宣言
NSArray *sectionList;

// データベースからデータをロードする
- (void)loadDataFromDB
{
    NSLog(@"%s", __func__);
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
    
    // SQL文を生成．ここではすべてをid順に持ってくるという文
    NSString* sql = @"SELECT * FROM text ORDER BY word;";
    FMResultSet* rs = [db executeQuery:sql];
    
    // データのTextクラスを初期化
    mTexts = [[NSMutableArray alloc] init];
    
    aGyo = [[NSMutableArray alloc] init];
    kaGyo = [[NSMutableArray alloc] init];
    saGyo = [[NSMutableArray alloc] init];
    taGyo = [[NSMutableArray alloc] init];
    naGyo = [[NSMutableArray alloc] init];
    haGyo = [[NSMutableArray alloc] init];
    maGyo = [[NSMutableArray alloc] init];
    yaGyo = [[NSMutableArray alloc] init];
    raGyo = [[NSMutableArray alloc] init];
    waGyo = [[NSMutableArray alloc] init];
    
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
        
        [mTexts addObject:text];
        
        if([text.word hasPrefix:@"あ"] == YES || [text.word hasPrefix:@"い"] == YES || [text.word hasPrefix:@"う"] == YES || [text.word hasPrefix:@"え"] == YES || [text.word hasPrefix:@"お"] == YES ) {
            [aGyo addObject:text];
            NSLog(@"A");
        } else if ([text.word hasPrefix:@"か"] == YES || [text.word hasPrefix:@"き"] == YES || [text.word hasPrefix:@"く"] == YES || [text.word hasPrefix:@"け"] == YES || [text.word hasPrefix:@"こ"] == YES || [text.word hasPrefix:@"が"] == YES || [text.word hasPrefix:@"ぎ"] == YES || [text.word hasPrefix:@"ぐ"] == YES || [text.word hasPrefix:@"げ"] == YES || [text.word hasPrefix:@"ご"] == YES ) {
            [kaGyo addObject:text];
        } else if ([text.word hasPrefix:@"さ"] == YES || [text.word hasPrefix:@"し"] == YES || [text.word hasPrefix:@"す"] == YES || [text.word hasPrefix:@"せ"] == YES || [text.word hasPrefix:@"そ"] == YES || [text.word hasPrefix:@"ざ"] == YES || [text.word hasPrefix:@"じ"] == YES || [text.word hasPrefix:@"ず"] == YES || [text.word hasPrefix:@"ぜ"] == YES || [text.word hasPrefix:@"ぞ"] == YES ) {
            [saGyo addObject:text];
        } else if ([text.word hasPrefix:@"た"] == YES || [text.word hasPrefix:@"ち"] == YES || [text.word hasPrefix:@"つ"] == YES || [text.word hasPrefix:@"て"] == YES || [text.word hasPrefix:@"と"] == YES || [text.word hasPrefix:@"だ"] == YES || [text.word hasPrefix:@"ぢ"] == YES || [text.word hasPrefix:@"づ"] == YES || [text.word hasPrefix:@"で"] == YES || [text.word hasPrefix:@"ど"] == YES ) {
            [taGyo addObject:text];
        } else if ([text.word hasPrefix:@"な"] == YES || [text.word hasPrefix:@"に"] == YES || [text.word hasPrefix:@"ぬ"] == YES || [text.word hasPrefix:@"ね"] == YES || [text.word hasPrefix:@"の"] == YES) {
            [naGyo addObject:text];
        } else if ([text.word hasPrefix:@"は"] == YES || [text.word hasPrefix:@"ひ"] == YES || [text.word hasPrefix:@"ふ"] == YES || [text.word hasPrefix:@"へ"] == YES || [text.word hasPrefix:@"ほ"] == YES || [text.word hasPrefix:@"ば"] == YES || [text.word hasPrefix:@"び"] == YES || [text.word hasPrefix:@"ぶ"] == YES || [text.word hasPrefix:@"べ"] == YES || [text.word hasPrefix:@"ぼ"] == YES  || [text.word hasPrefix:@"ぱ"] == YES || [text.word hasPrefix:@"ぴ"] == YES || [text.word hasPrefix:@"ぷ"] == YES || [text.word hasPrefix:@"ぺ"] == YES || [text.word hasPrefix:@"ぽ"] == YES ) {
            [haGyo addObject:text];
        } else if ([text.word hasPrefix:@"ま"] == YES || [text.word hasPrefix:@"み"] == YES || [text.word hasPrefix:@"む"] == YES || [text.word hasPrefix:@"め"] == YES || [text.word hasPrefix:@"も"] == YES) {
            [maGyo addObject:text];
        } else if ([text.word hasPrefix:@"や"] == YES || [text.word hasPrefix:@"ゆ"] == YES || [text.word hasPrefix:@"よ"] == YES) {
            [yaGyo addObject:text];
        } else if ([text.word hasPrefix:@"ら"] == YES || [text.word hasPrefix:@"り"] == YES || [text.word hasPrefix:@"る"] == YES || [text.word hasPrefix:@"れ"] == YES || [text.word hasPrefix:@"ろ"] == YES) {
            [raGyo addObject:text];
        } else if ([text.word hasPrefix:@"わ"] == YES || [text.word hasPrefix:@"を"] == YES || [text.word hasPrefix:@"ん"] == YES) {
            [waGyo addObject:text];
        }
        
        
    }
    
    [rs close];
    [db close];
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"辞書";
    
    // データベースをロード
    [self loadDataFromDB];
    
    sectionList = [NSArray arrayWithObjects:@"あ", @"か", @"さ", @"た", @"な", @"は",@"ま",@"や",@"ら",@"わ",nil];
    //    sectionList = [NSArray arrayWithObjects:@"あ行", @"か行", @"さ行", @"た行", @"な行", @"は行",@"ま行",@"や行",@"ら行",@"わ行",nil];
    //    NSArray *datas = [NSArray arrayWithObjects:aGyo, kaGyo, saGyo, taGyo, naGyo, haGyo, maGyo, yaGyo, raGyo, waGyo, nil];
    //dataSource = [NSDictionary dictionaryWithObjects:datas forKeys:sectionList];
    dataSource = [NSDictionary dictionaryWithObjectsAndKeys:
                  aGyo, @"あ",
                  kaGyo, @"か",
                  saGyo, @"さ",
                  taGyo, @"た",
                  naGyo, @"な",
                  haGyo, @"は",
                  maGyo, @"ま",
                  yaGyo, @"や",
                  raGyo, @"ら",
                  waGyo, @"わ",
                  nil];
    /*
     dataSource = [NSDictionary dictionaryWithObjectsAndKeys:
     aGyo, @"あ行",
     kaGyo, @"か行",
     saGyo, @"さ行",
     taGyo, @"た行",
     naGyo, @"な行",
     haGyo, @"は行",
     maGyo, @"ま行",
     yaGyo, @"や行",
     raGyo, @"ら行",
     waGyo, @"わ行",
     nil];
     */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sectionList count];
}

/**
 * 指定されたセクションのセクション名を返す
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [sectionList objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //    return [mTexts count];
    NSString *sectionName = [sectionList objectAtIndex:section];
    
    return [[dataSource objectForKey:sectionName] count];
}

// 一覧表示部分
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    
    /*
     // 行(intexPath.row)ごとにtextLabelとdetailTextLabelに表示したいデータを代入
     Text *text = [mTexts objectAtIndex:indexPath.row];
     cell.textLabel.text = text.word;
     //    cell.detailTextLabel.text = text.text;
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     */
    
    
    // セクション名を取得する
    NSString *sectionName = [sectionList objectAtIndex:indexPath.section];
    
    // セクション名をキーにしてそのセクションの項目をすべて取得
    NSArray *items = [dataSource objectForKey:sectionName];
    
    // セルにテキストを設定
    Text *text = [items objectAtIndex:indexPath.row];
    cell.textLabel.text = text.word;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}

#pragma mark - Table view delegate

// データが選択されたときに詳細画面に移動する
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionName = [sectionList objectAtIndex:indexPath.section];
    NSArray *items = [dataSource objectForKey:sectionName];
    Text *sender_text = [items objectAtIndex:indexPath.row];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithText:sender_text];
    //DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
    //NSString *sectionName = [sectionList objectAtIndex:indexPath.section];
    //NSArray *items = [dataSource objectForKey:sectionName];
    
    //detailViewController.title = @"辞書 - ";
    //detailViewController.text = [items objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

/*
 //ヘッダーにつける文字列を指定する。ここでは配列を作ってその文字列を表示させている。
 -(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 return sectionList[section];
 }
 */
//TableViewのインデックスリストに表示させたい文字列を設定する。
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return sectionList;
}


@end
