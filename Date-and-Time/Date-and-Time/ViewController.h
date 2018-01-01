//
//  ViewController.h
//  Date-and-Time
//
//  Created by Aaron Miller on 12/31/17.
//  Copyright © 2017 Aaron Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    NSTimer *timer;
    NSDate *date;
}

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

