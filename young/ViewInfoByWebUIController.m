//
//  ViewInfoByWebUIController.m
//  young
//
//  Created by z Apple on 15/4/17.
//  Copyright (c) 2015年 z. All rights reserved.
//

#import "ViewInfoByWebUIController.h"

@implementation ViewInfoByWebUIController

-(void)viewDidLoad
{
    [super viewDidLoad];
    if (self.strUrl) {
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrl]]];
    }else if (self.strHtml){
        [self.myWebView loadHTMLString: self.strHtml baseURL:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // Set self as the web view's delegate when the view is shown; use the delegate methods to toggle display of the network activity indicator.
    self.myWebView.delegate = self;
    [super viewWillAppear:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.myWebView stopLoading];	// In case the web view is still loading its content.
    self.myWebView.delegate = nil;	// Disconnect the delegate as the webview is hidden.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    else {
        if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            return NO;
        }
    }
    return YES;
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // Starting the load, show the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Finished loading, hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    NSURL *url = [webView.request URL];
//    self.urlField.text = [url absoluteString];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSURL *url = [request URL];
//    self.urlField.text = [url absoluteString];
    return YES;
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // Load error, hide the activity indicator in the status bar.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Report the error inside the webview.
    NSString* errorString = [NSString stringWithFormat:
                             @"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\"><html><head><meta http-equiv='Content-Type' content='text/html;charset=utf-8'><title></title></head><body><div style='width: 100%%; text-align: center; font-size: 36pt; color: red;'>An error occurred:<br>%@</div></body></html>",
                             error.localizedDescription];
    [self.myWebView loadHTMLString:errorString baseURL:nil];
}

@end
