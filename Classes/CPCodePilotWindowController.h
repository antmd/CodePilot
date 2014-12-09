//
//  CPCodePilotWindowController.h
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 2/9/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CPWindow.h"

@class CPSearchController;
@class CPSearchFieldTextView;

@interface CPCodePilotWindowController : NSWindowController <NSWindowDelegate>
@property (strong) IBOutlet CPWindow *window;
@property (nonatomic, strong) IBOutlet CPSearchController *searchController;
@property (nonatomic, assign) BOOL ourWindowIsOpen;
@property (nonatomic, strong) CPSearchFieldTextView *searchFieldTextEditor;

- (id)initWithXcodeWrapper:(CPXcodeWrapper *)xcodeWrapper;

- (void)openWindow;
- (void)openWindowWithModifierMask:(NSEventModifierFlags)modifierMask keyCode:(NSUInteger)keyCode; // Switcher mode
- (void)hideWindow;

//ACTIONS
-(IBAction)performClose:(id)sender;
@end
