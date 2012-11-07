//
//  MyViewController.m
//  Bonjour02
//
//  Created by もさお on 12/11/05.
//  Copyright (c) 2012年 もさお. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"iMosao";

    // ビューのインスタンス生成
    _mosaoView = [[MosaoView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    // ビューコンに貼っつける
    [self.view addSubview:_mosaoView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [_mosaoView removeFromSuperview];
}

@end
