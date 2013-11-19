//
//  GionViewController.m
//  Gion
//
//  Created by Yoshiyuki Sakamoto on 2013/11/19.
//  Copyright (c) 2013年 horita. All rights reserved.
//

#import "GionViewController.h"

@interface GionViewController ()

@end

@implementation GionViewController

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
    NSLog(@"%s", __func__);
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 背景の指定
    self.view.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:228.0/255.0 blue:189.0/255.0 alpha:1.0];
    lightColor = [UIColor colorWithRed:235/255.0 green:241/255.0 blue:222/255.0 alpha:1.0];
    darkColor = [UIColor colorWithRed:0.31 green:0.384 blue:0.156 alpha:1.0];
    textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    lightTextColor = lightColor;//[UIColor whiteColor];
    buttonTextColor = lightColor;
    buttonColor = [UIColor colorWithRed:119/255.0 green:147/255.0 blue:60/255.0 alpha:0.7];
    screenHeight = [UIScreen mainScreen].applicationFrame.size.height;
    
    //self.view.backgroundColor = lightColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
