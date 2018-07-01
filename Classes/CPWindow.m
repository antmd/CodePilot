//
//  SearchWindow.m
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 2/14/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import "CPWindow.h"
#import "CPCodePilotConfig.h"
#import "CPXcodeWrapper.h"
#import "CPResultsViewController.h"

@implementation CPWindow
- (id)initWithDefaultSettings
{
    return [[CPWindow alloc] initWithContentRect:NSMakeRect(100, 100, WINDOW_WIDTH, 500)
                                       styleMask:NSWindowStyleMaskTitled
                                         backing:NSBackingStoreBuffered
                                           defer:0];
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect
                            styleMask:NSWindowStyleMaskBorderless|NSWindowStyleMaskResizable
                              backing:bufferingType
                                defer:flag];
    
    if (self) {
        self.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
        [self setBackgroundColor:[NSColor clearColor]];
        [self setHasShadow:YES];
        [self setOpaque:NO];
        self.movableByWindowBackground = YES;
        
        [self setCollectionBehavior:NSWindowCollectionBehaviorMoveToActiveSpace];
    }
    
    return self;
}


- (NSScreen *)destinationScreen
{
    NSScreen *xCodeCurrentScreen = [[[CPCodePilotPlugin sharedInstance] xcWrapper] currentScreen];
    
    return xCodeCurrentScreen ?: [NSScreen mainScreen];
}


// Normally windows with the NSBorderlessWindowMask can't become the key window
- (BOOL)canBecomeKeyWindow
{
    return YES;
}
@end
