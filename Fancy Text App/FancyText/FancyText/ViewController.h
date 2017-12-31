//
//  ViewController.h
//  FancyText
//
//  Created by Aaron on 30/12/17.
//  Copyright © 2017 Aaron Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    
    CGFloat fontSize;
    BOOL state;
    BOOL shadowFlag;
}
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)submitText:(id)sender;

- (IBAction)red:(id)sender;
- (IBAction)blue:(id)sender;
- (IBAction)green:(id)sender;

- (IBAction)font1:(id)sender;
- (IBAction)font2:(id)sender;
- (IBAction)font3:(id)sender;
- (IBAction)font4:(id)sender;

- (IBAction)shawdow:(id)sender;

- (IBAction)small:(id)sender;
- (IBAction)medium:(id)sender;
- (IBAction)large:(id)sender;

@end

