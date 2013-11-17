//
//  DetailViewController.h
//  fmdb
//
//  Created by horita on 2013/10/14.
//  Copyright (c) 2013年 horita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Text.h"

@interface DetailViewController : UIViewController
{
    Text *text;
    UILabel *_text;
    UILabel *word;
    UILabel *meaning;
    UILabel *right;
    UILabel *wrong;
}
@property (nonatomic,retain) Text *text;
@property (nonatomic,retain) IBOutlet UILabel *_text;
@property (nonatomic,retain) IBOutlet UILabel *word;
@property (nonatomic,retain) IBOutlet UILabel *meaning;
@property (nonatomic,retain) IBOutlet UILabel *right;
@property (nonatomic,retain) IBOutlet UILabel *wrong;

- (id)initWithText:(Text *)t;


@end
