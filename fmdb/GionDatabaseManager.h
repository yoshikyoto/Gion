//
//  GionDatabaseManager.h
//  Gion
//
//  Created by Yoshiyuki Sakamoto on 2013/11/19.
//  Copyright (c) 2013年 horita. All rights reserved.
//

#import "FMDatabase.h"

@interface GionDatabaseManager : FMDatabase{
    NSFileManager *file_manager;
    FMDatabase *db;
}

- (NSMutableArray *)executeSQL:(NSString *)sql;

@end
