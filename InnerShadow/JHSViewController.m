//
//  JHSViewController.m
//  InnerShadow
//
//  Created by James Snook on 13/07/2013.
//  Copyright (c) 2013 James Snook. All rights reserved.
//

#import "JHSViewController.h"
#import "JHSInnerShadowView.h"

@interface JHSViewController ()

@end

@implementation JHSViewController

@synthesize shadowView;

- (void)viewDidLoad
{
  [super viewDidLoad];
  [shadowView setCornerRadius:10.0];
  
  /* Commented out code here sets up the shadows to make something look embossed
     instead of indented (which is the default).
  [shadowView setInsideShadowColor:[[UIColor whiteColor] CGColor]];
  [shadowView setInsideShadowRadius:1.0];
  [shadowView setInsideShadowSize:CGSizeMake(0.0, 1.0)];
  
  CGColorSpaceRef graySpace = CGColorSpaceCreateDeviceGray ();
  CGFloat darkVals[] = { 0.0, 0.8 };
  CGColorRef darkCol = CGColorCreate (graySpace, darkVals);
  [shadowView setOutsideShadowCol:darkCol];
  CFRelease(darkCol);
  CFRelease (graySpace);
  [shadowView setOutsideShadowRadius:4.0];
  [shadowView setOutsideShadowSize:CGSizeMake (0.0, 3.0)];
  */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
