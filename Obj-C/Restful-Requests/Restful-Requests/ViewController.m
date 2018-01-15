//
//  ViewController.m
//  Restful-Requests
//
//  Created by Aaron Miller on 1/14/18.
//  Copyright © 2018 Aaron Miller. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    NSString *post = @"varPOST={ access_token: 'EAAM87eushSYBAP6dfxC0ZC4JzNiTt4R8pxnn4Qq4YRBprGrJpcnWEK0fDynAHeZBY0u8HcGZCTbJvQ7ATkZASfONSreV2nsZB1oCdj8WACU7W39TdTqkU5zYqACMJQEuSOXBtfkMrT1P9u0DnZCutFZBpC3Cbv8XETBIIjOGutM3eHJtqyWIHcs3sZBa4qshFbN2ScvZBDXttFZCQIdLX7bwSPojwZBdgccmnvZAcRaZAac0hMQZDZD' }";
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", ( unsigned long )[postData length]];//long unsinged int = @"%lu"
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    // insert whatever URL you would like to connect to
    //[request setURL:[NSURL URLWithString:@"http://sonarsystems.co.uk/DeveloperTools/Tutorials/iOS_SDK/SendData.php?varGET=hello"]];
    [request setURL:[NSURL URLWithString:@"https://prod1.mytcheck.com/auth/facebook"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *task = [[self getURLSession] dataTaskWithRequest:request completionHandler:^( NSData *data, NSURLResponse *response, NSError *error )
                                  {
                                      dispatch_async( dispatch_get_main_queue(),
                                                     ^{
                                                         // parse returned data
                                                         NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                                                         NSLog( @"%@", result );
                                                     } );
                                  }];
    [task resume];
}

- ( NSURLSession * )getURLSession{
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken,
                  ^{
                      NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                      session = [NSURLSession sessionWithConfiguration:configuration];
                  } );
    
    return session;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
