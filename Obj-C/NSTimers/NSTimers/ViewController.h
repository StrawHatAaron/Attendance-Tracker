//
//  ViewController.h
//  NSTimers
//
//  Created by Aaron Miller on 12/30/17.
//  Copyright © 2017 Aaron Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    NSTimer *timer;
    int countInt;
}

@property (weak, nonatomic) IBOutlet UILabel *label;
- (IBAction)start:(id)sender;
- (IBAction)pause:(id)sender;
- (IBAction)restart:(id)sender;

@end

