//
//  ViewController.m
//  HybridApp
//
//  Created by Aaron Miller on 1/16/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

#import "ViewController.h"
#import "HybridApp-Bridging-Header.h"
#import "HybridApp-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MySwiftObject * myOb = [MySwiftObject new];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
