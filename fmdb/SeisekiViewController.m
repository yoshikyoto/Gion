//
//  SeisekiViewController.m
//  fmdb
//
//  Created by Yoshiyuki Sakamoto on 2013/10/25.
//  Copyright (c) 2013年 horita. All rights reserved.
//

#import "SeisekiViewController.h"
#import "GionTabBarController.h"
#import "Text.h"

@interface SeisekiViewController ()


@end

@implementation SeisekiViewController

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
    
    [self updateLabel];
}

- (void)updateLabel{
    // NSUserDefaultから各種値を取得
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    int running_max = [ud integerForKey:@"RUNNINGMAX"];
    int running = [ud integerForKey:@"RUNNING"];
    
    // 正解数とかを取得
    GionTabBarController *tabbar = (GionTabBarController *)self.tabBarController;
    NSMutableArray *texts = tabbar.texts;
    int all_texts_count = [texts count];
    int right_texts_count = 0;
    for(int i = 0; i < [texts count]; i++){
        Text *text = [texts objectAtIndex:i];
        if(text.right > 0){
            NSLog(@"%@ 習得", text.word);
            right_texts_count++;
        }else{
            NSLog(@"%@　未習得", text.word);
        }
    }
    
    // 各種値をラベルにセット
    _runningMaxLabel.text = [NSString stringWithFormat:@"最高記録 %d日", running_max];
    _runningLabel.text = [NSString stringWithFormat:@"%d日連続継続中", running];
    _rightAllLabel.text = [NSString stringWithFormat:@"正解数 %d問 / 全 %d問", right_texts_count, all_texts_count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
