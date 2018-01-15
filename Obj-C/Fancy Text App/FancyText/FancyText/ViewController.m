//
//  ViewController.m
//  FancyText
//
//  Created by Aaron on 30/12/17.
//  Copyright © 2017 Aaron. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    shadowFlag = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)submitText:(id)sender {
    self.label.text = self.textField.text;
}

- (IBAction)red:(id)sender {
    self.label.textColor = [UIColor redColor];
}

- (IBAction)blue:(id)sender {
    self.label.textColor = [UIColor blueColor];
}

- (IBAction)green:(id)sender {
    //self.label.textColor = [UIColor greenColor];
    self.label.textColor = [UIColor colorWithRed:0.0/255.0 green:124.0/255.0 blue:29.0/255.0 alpha:1.0];//custom green color
}

- (IBAction)font1:(id)sender {
    [self.label setFont:[UIFont fontWithName:@"LemonMilk" size:30]];
}

- (IBAction)font2:(id)sender {
    [self.label setFont:[UIFont fontWithName:@"Courier" size:30]];
}

- (IBAction)font3:(id)sender {
    [self.label setFont:[UIFont fontWithName:@"SugarstyleMillenial-Regular" size:30]];
}

- (IBAction)font4:(id)sender {
    [self.label setFont:[UIFont fontWithName:@"Helvetica" size:30]];
}

- (IBAction)shawdow:(id)sender {
    if(shadowFlag==YES){
        self.label.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.label.layer.shadowOpacity = 1;//0 would be see through like its not even there - kinda like opacity
        self.label.layer.shadowRadius = 1.0f;//size
        self.label.layer.shadowOffset = CGSizeMake(2, 2);//width, height
        shadowFlag=NO;
    }else{
        self.label.layer.shadowOpacity = 0;
        shadowFlag = YES;
    }
}

- (IBAction)small:(id)sender {
    [self.label setFont:[UIFont systemFontOfSize:15]];
}

- (IBAction)medium:(id)sender {
    [self.label setFont:[UIFont systemFontOfSize:30]];
}

- (IBAction)large:(id)sender {
    [self.label setFont:[UIFont systemFontOfSize:45]];
}
@end
