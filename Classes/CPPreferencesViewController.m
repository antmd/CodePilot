//
//  CPPreferencesViewController.m
//  CodePilot
//
//  Created by Anthony Dervish on 07/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//

#import "CPPreferencesViewController.h"
#import "NSAttributedString+Hyperlink.h"

@interface CPPreferencesViewController ()

@end

static NSAttributedString *sHyperlink = nil;

@implementation CPPreferencesViewController

+ (void)initialize
{
  if (self == [CPPreferencesViewController class]) {
    sHyperlink = [NSAttributedString hyperlinkFromString:@"http://macoscope.com" withURL:[NSURL URLWithString:@"http://macoscope.com"]];
  }
}

-(NSString *)nibName
{
  return @"CPPreferencesViewController";
}

-(NSBundle *)nibBundle
{
  return [NSBundle bundleForClass:CPPreferencesViewController.class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

-(NSAttributedString *)hyperlink
{
  return sHyperlink;
}

-(NSString *)productVersion
{
  return PRODUCT_CURRENT_VERSION;
}
@end
