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


-(void)awakeFromNib
{
  NSUInteger keyCode = CODE_PILOT_PLUGIN.switcherModeKeyCode;
  if (keyCode) {
    [self.switcherModeKeyboardShortcutRecorder setKeyCode:keyCode andModifierFlags:CODE_PILOT_PLUGIN.switcherModeModifierFlags];
  }
}
-(NSAttributedString *)hyperlink
{
  return sHyperlink;
}

-(NSString *)productVersion
{
  return PRODUCT_CURRENT_VERSION;
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - GWShortcutRecorderDelegate
/*==================================================================================================
 */

- (void) shortcutRecorder:(GWShortcutRecorder *) recorder didClearFlags:(NSEventModifierFlags) flags andKeyCode:(unsigned short) keycode
{
  CODE_PILOT_PLUGIN.switcherModeKeyCode = 0;
  CODE_PILOT_PLUGIN.switcherModeModifierFlags = 0;
}
- (void) shortcutRecorder:(GWShortcutRecorder *) recorder setFlags:(NSEventModifierFlags) flags andKeyCode:(unsigned short) keycode
{
  CODE_PILOT_PLUGIN.switcherModeKeyCode = keycode;
  CODE_PILOT_PLUGIN.switcherModeModifierFlags = flags;
}
@end
