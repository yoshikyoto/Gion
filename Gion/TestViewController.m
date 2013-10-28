//
//  TestViewController.m
//  Gion
//
//  Created by Yoshiyuki Sakamoto on 2013/10/11.
//  Copyright (c) 2013年 HeyaYshirtY. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

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
    
    // ブランチ sakamoto で作業しました。
    UILabel *label = [[UILabel alloc] init];
    label.text = @"tesuto";
    label.frame = CGRectMake(0, 0, 200, 50);
    [[self view] addSubview:label];
}

/*
 
 インスタンス.メッソド名(引数)
 
 [インスタンス メソッド名:引数]
 
 
 def メソッド名
 　メソッドの内容
 end
 
 -(戻り値の型)メソッド名{
  メソッドの内容
 }
 
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
