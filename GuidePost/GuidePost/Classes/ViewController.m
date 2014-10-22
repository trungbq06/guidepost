//
//  ViewController.m
//  GuidePost
//
//  Created by Mr Trung on 10/22/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "TFHpple.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _activity.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:232.0/255.0 blue:231.0/255.0 alpha:1.0];
    
    _myLink.placeholder = @"Add card link...";
    _myLink.delegate = self;
    _myTitle.placeholder = @"Add title...";
    _myDesc.placeholder = @"Add description...";
    
    _myLink.text = @"";
    _myTitle.text = @"";
    _myDesc.text = @"";
    
    _myTitle.hidden = YES;
    _myDesc.hidden = YES;
    _myImage.hidden = YES;
    
    _myDesc.font = [UIFont systemFontOfSize:12];
    _myTitle.font = [UIFont systemFontOfSize:16];
    _myLink.font = [UIFont systemFontOfSize:16];
    _myImage.layer.borderWidth = 1;
    _myImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) hideButton
{
    _activity.hidden = NO;
    [_activity startAnimating];
    _btnDownload.hidden = YES;
}

- (BOOL)isValidURL:(NSURL*)url
{
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSHTTPURLResponse *res = nil;
    NSError *err = nil;
    [NSURLConnection sendSynchronousRequest:req returningResponse:&res error:&err];
    return err!=nil && [res statusCode]!=404;
}

- (IBAction)btnGetClick:(id)sender {
    [_myLink resignFirstResponder];
    [NSThread detachNewThreadSelector:@selector(hideButton) toTarget:self withObject:nil];
    
    NSError *error;
    NSURL *url = [NSURL URLWithString:_myLink.text];
    NSData  * data      = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    
    TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:data];
    
    // Title
    NSArray * titleNodes  = [doc searchWithXPathQuery:@"//meta[@property='og:title']"];
    
    if ([titleNodes count] > 0) {
        TFHppleElement *titleElement = [titleNodes objectAtIndex:0];
        
        NSDictionary *titleDict = [titleElement attributes];
        
        if (!titleDict) {
            _activity.hidden = YES;
            // Get site title, description
            NSArray * titleNodes  = [doc searchWithXPathQuery:@"//title"];
            
            TFHppleElement *titleElement = [titleNodes objectAtIndex:0];
            
            NSString *myTitle =  [[titleElement firstChild] content];
            
            _myTitle.text = myTitle;
            _myTitle.hidden = NO;
            
            NSArray * descNodes  = [doc searchWithXPathQuery:@"//description"];
            
            TFHppleElement *descElement = [descNodes objectAtIndex:0];
            
            NSString *myDesc =  [[descElement firstChild] content];
            
            _myDesc.text = myDesc;
            _myDesc.hidden = NO;
            _myImage.hidden = NO;
        } else {
            _activity.hidden = YES;
            NSString *myTitle = [titleDict objectForKey:@"content"];
            
            NSLog(@"Title: %@", myTitle);
            _myTitle.text = myTitle;
            _myTitle.hidden = NO;
            
            // Image
            NSArray * imageNodes  = [doc searchWithXPathQuery:@"//meta[@property='og:image']"];
            
            TFHppleElement *imageElement = [imageNodes objectAtIndex:0];
            
            NSDictionary *imageDict = [imageElement attributes];
            
            NSString *myImage = [imageDict objectForKey:@"content"];
            
            NSLog(@"Image: %@", myImage);
            _myImage.hidden = NO;
            [_myImage sd_setImageWithURL:[NSURL URLWithString:myImage]];
            
            // Description
            NSArray * descNodes  = [doc searchWithXPathQuery:@"//meta[@property='og:description']"];
            
            TFHppleElement *descElement = [descNodes objectAtIndex:0];
            
            NSDictionary *descDict = [descElement attributes];
            
            NSString *myDesc = [descDict objectForKey:@"content"];
            
            NSLog(@"Desc: %@", myDesc);
            _myDesc.text = myDesc;
            _myDesc.hidden = NO;
            
            [_btnDownload setFrame:CGRectMake(_btnDownload.frame.origin.x, _btnDownload.frame.origin.y + 400, _btnDownload.frame.size.width, _btnDownload.frame.size.height)];
        }
    }
}

#pragma mark - TEXT VIEW DELEGATE
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_btnDownload setFrame:CGRectMake(124, 143, _btnDownload.frame.size.width, _btnDownload.frame.size.height)];
    _btnDownload.hidden = NO;
    _activity.hidden = YES;
    
    _myImage.hidden = YES;
    _myDesc.hidden = YES;
    _myTitle.hidden = YES;
}

@end
