//
//  MasterTableViewController.h
//  fmdb
//
//  Created by horita on 2013/10/14.
//  Copyright (c) 2013年 horita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface MasterTableViewController : UITableViewController
{
    NSMutableArray *mTexts;
    NSMutableArray *aGyo;
    NSMutableArray *kaGyo;
    NSMutableArray *saGyo;
    NSMutableArray *taGyo;
    NSMutableArray *naGyo;
    NSMutableArray *haGyo;
    NSMutableArray *maGyo;
    NSMutableArray *yaGyo;
    NSMutableArray *raGyo;
    NSMutableArray *waGyo;
    
    NSDictionary *dataSource;
}

@end
