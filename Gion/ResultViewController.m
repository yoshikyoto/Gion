//
//  ResultViewController.m
//  test
//
//  Created by Yoshiyuki Sakamoto on 2013/10/14.
//  Copyright (c) 2013年 HeyaYshirtY. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 背景
    [self view].backgroundColor = [UIColor whiteColor];
    // タイトル設定
    UILabel *title_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
    title_label.text = @"結果";
    title_label.textAlignment = NSTextAlignmentCenter;
    [[self view] addSubview:title_label];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
