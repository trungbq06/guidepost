//
//  ViewController.h
//  GuidePost
//
//  Created by Mr Trung on 10/22/14.
//  Copyright (c) 2014 Mr Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMTextView.h"

@interface ViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet SAMTextView *myTitle;
@property (weak, nonatomic) IBOutlet SAMTextView *myLink;
@property (weak, nonatomic) IBOutlet SAMTextView *myDesc;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UIButton *btnDownload;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;


- (IBAction)btnGetClick:(id)sender;

@end

