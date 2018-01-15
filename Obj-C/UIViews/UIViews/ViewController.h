//
//  ViewController.h
//  UIViews
//
//  Created by Aaron Miller on 1/2/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *theView;

- (IBAction)showView:(id)sender;
- (IBAction)hideView:(id)sender;

@end

