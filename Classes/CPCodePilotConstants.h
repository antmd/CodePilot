//
//  CPCodePilotConstants.h
//  CodePilot
//
//  Created by Anthony Dervish on 07/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CPOpenFileMode) {
  CP_OPEN_IN_CURRENT_EDITOR
  , CP_OPEN_IN_NEW_WINDOW
  , CP_OPEN_IN_NEW_TAB
  , CP_OPEN_IN_VSPLIT
  , CP_OPEN_IN_HSPLIT
};

extern NSString * CPDefaultsSwitcherKeyboardShortcutKeyCode;
extern NSString * CPDefaultsSwitcherKeyboardShortcutModifierFlags;