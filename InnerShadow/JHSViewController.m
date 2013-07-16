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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
