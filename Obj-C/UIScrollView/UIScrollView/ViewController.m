//
//  ViewController.m
//  UIScrollView
//
//  Created by Aaron Miller on 1/2/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.scrollView setContentSize:CGSizeMake(0, 1500)];//negative scroll up, positive scroll down
}

@end
