//
//  ViewController.m
//  UIViews
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
    self.theView.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showView:(id)sender {
    self.theView.hidden = NO;
}

- (IBAction)hideView:(id)sender {
    self.theView.hidden = YES;
}
@end
