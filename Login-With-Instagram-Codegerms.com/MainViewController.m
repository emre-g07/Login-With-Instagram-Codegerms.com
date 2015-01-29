//
//  MainViewController.m
//  Login-With-Instagram-Codegerms.com
//
//  Created by Ammad on 29/01/15.
//  Copyright (c) 2015 CodeGerms.com. All rights reserved.
//

#import "MainViewController.h"
#import "JSON.h"


NSString *client_id;
NSString *secret;
NSString *callback;

@interface MainViewController ()

@end

NSString *client_id;
NSString *secret;
NSString *callback;

@implementation MainViewController
@synthesize webview;
- (void)viewDidLoad {
    [super viewDidLoad];
    client_id = @"5ae66c07eff04e5a983527275ecbcfa6";
    secret = @"7e4d315efe574e3880d6fe9f86af220c";
    callback = @"http://codegerms.com/";
    
    
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code",client_id,callback];
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //    [indicator startAnimating];
    if ([[[request URL] host] isEqualToString:@"codegerms.com"]) {
        
        // Extract oauth_verifier from URL query
        NSString* verifier = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams) {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"code"]) {
                verifier = [keyValue objectAtIndex:1];
                break;
            }
        }
        
        if (verifier) {
            
            NSString *data = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",client_id,secret,callback,verifier];
            
            NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/oauth/access_token"];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
            NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            receivedData = [[NSMutableData alloc] init];
        } else {
            // ERROR!
        }
        
        [webView removeFromSuperview];
        
        return NO;
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // [indicator stopAnimating];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    [receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[NSString stringWithFormat:@"%@", error]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    SBJsonParser *jResponse = [[SBJsonParser alloc]init];
    NSDictionary *tokenData = [jResponse objectWithString:response];
    //  WebServiceSocket *dconnection = [[WebServiceSocket alloc] init];
    //   dconnection.delegate = self;
    
    NSString *pdata = [NSString stringWithFormat:@"type=3&token=%@&secret=123&login=%@", [tokenData objectForKey:@"access_token"], self.isLogin];
    //  NSString *pdata = [NSString stringWithFormat:@"type=3&token=%@&secret=123&login=%@",[tokenData accessToken.secret,self.isLogin];
    //  [dconnection fetch:1 withPostdata:pdata withGetData:@"" isSilent:NO];
  
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Instagram Access TOken"
                              message:pdata
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}


@end
