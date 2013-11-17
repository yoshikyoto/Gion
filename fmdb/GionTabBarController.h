//
//  GionTabBarController.h
//  fmdb
//
//  Created by Yoshiyuki Sakamoto on 2013/10/25.
//  Copyright (c) 2013年 horita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Text.h"
#import "FMDatabase.h"

@interface GionTabBarController : UITabBarController{
}

@property NSMutableArray *texts;
@property FMDatabase *db;

@end
