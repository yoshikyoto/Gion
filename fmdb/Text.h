//
//  Text.h
//  fmdb
//
//  Created by horita on 2013/10/14.
//  Copyright (c) 2013年 horita. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Text : NSObject
{
    NSInteger textid;
    NSString *text;
    NSString *word;
    NSString *meaning;
    NSInteger right;
    NSInteger wrong;
}

@property(nonatomic,assign)NSInteger textid;
@property(nonatomic,retain)NSString *text;
@property(nonatomic,retain)NSString *word;
@property(nonatomic,retain)NSString *meaning;
@property(nonatomic,assign)NSInteger right;
@property(nonatomic,assign)NSInteger wrong;

- (void)rightAnswerSelected;
- (void)wrongAnswerSelected;


@end
