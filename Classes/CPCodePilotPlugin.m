//
//  CPCodePilotPlugin.m
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 2/18/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import "CPCodePilotPlugin.h"
#import "CPCodePilotWindowController.h"
#import "CPXcodeWrapper.h"
#import "CPPluginInstaller.h"

#include <sys/stat.h>

@implementation CPCodePilotPlugin {
    id _switcherEventMonitor;
}

+ (void)pluginDidLoad:(id)arg1
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            LOG(@"CODE PILOT: CURRENT_XCODE_VERSION: %@ CURRENT_XCODE_REVISION: %@", CURRENT_XCODE_VERSION, CURRENT_XCODE_REVISION);
            
            // just instantiate the singleton
            (void)[CPCodePilotPlugin sharedInstance];
        });
    }
    
}

+ (instancetype)sharedInstance
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CPCodePilotPlugin alloc] init];
    });
    
    return sharedInstance;
}


- (id)init
{
    self = [super init];
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    
    
    if (self) {
        if ([currentApplicationName isEqual:@"Xcode"])
            dispatch_once(&onceToken, ^{
                
                self.isUserLevelDebugOn = [[NSUserDefaults standardUserDefaults] boolForKey:DEFAULTS_USER_LEVEL_DEBUG_KEY];
                
                [self checkForFirstRun];
                
                self.xcWrapper = [CPXcodeWrapper new];
                self.windowController = [[CPCodePilotWindowController alloc] initWithXcodeWrapper:self.xcWrapper];
                
                // we want to start real installation once the app is fully launched
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(applicationDidFinishLaunching:)
                                                             name:NSApplicationDidFinishLaunchingNotification
                                                           object:nil];
                LOG(@"%@ %@ Plugin loaded.", PRODUCT_NAME, PRODUCT_CURRENT_VERSION);
                
            });
    }
    
    return self;
}

-(void)dealloc
{
    if (_switcherEventMonitor) {
        [NSEvent removeMonitor:_switcherEventMonitor];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    self.installer = [[CPPluginInstaller alloc] init];
    
    [self.installer installPlugin:self];
    
    __typeof(self) __weak weakSelf = self;
    _switcherEventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown
                                                                  handler:^NSEvent *(NSEvent *event) {
                                                                      __typeof(self) this = weakSelf;
                                                                      if (!self.windowController.ourWindowIsOpen
                                                                          && (event.modifierFlags & this.switcherModeModifierFlags)
                                                                          && event.keyCode == this.switcherModeKeyCode) {
                                                                          [this performSelector:@selector(openCodePilotSwitcher) withObject:nil afterDelay:0.0];
                                                                          return nil;
                                                                      }
                                                                      return event;
                                                                  }];
    
}

- (void)openCodePilotWindow
{
    LOGCALL;
    
    if (self.windowController.ourWindowIsOpen) {
        [self.windowController hideWindow];
    }
    
    [self.xcWrapper reloadXcodeState];
    [self.windowController openWindow];
}

- (void)openCodePilotSwitcher
{
    LOGCALL;
    
    if (self.windowController.ourWindowIsOpen) {
        [self.windowController hideWindow];
    }
    
    [self.xcWrapper reloadXcodeState];
    [self.windowController openWindowWithModifierMask:self.switcherModeModifierFlags keyCode:self.switcherModeKeyCode];
}

- (void)checkForFirstRun
{
    self.thisVersionFirstRun = YES;
    self.firstRunEver = YES;
    
    NSString *lastVersionId = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_LAST_VERSION_RUN_KEY];
    if (!IsEmpty(lastVersionId)) {
        self.firstRunEver = NO;
        if ([lastVersionId isEqualToString:PRODUCT_CURRENT_VERSION]) {
            self.thisVersionFirstRun = NO;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:PRODUCT_CURRENT_VERSION forKey:DEFAULTS_LAST_VERSION_RUN_KEY];
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - Properties
/*==================================================================================================
 */

-(NSUInteger)switcherModeKeyCode
{
    NSUInteger keyCode = [NSUserDefaults.standardUserDefaults integerForKey:CPDefaultsSwitcherKeyboardShortcutKeyCode];
    return keyCode;
}

-(void)setSwitcherModeKeyCode:(NSUInteger)switcherModeKeyCode
{
    [NSUserDefaults.standardUserDefaults setInteger:switcherModeKeyCode forKey:CPDefaultsSwitcherKeyboardShortcutKeyCode];
}

-(NSEventModifierFlags)switcherModeModifierFlags
{
    NSUInteger modifierFlags = [NSUserDefaults.standardUserDefaults integerForKey:CPDefaultsSwitcherKeyboardShortcutModifierFlags];
    return modifierFlags;
}

-(void)setSwitcherModeModifierFlags:(NSEventModifierFlags)switcherModeModifierFlags
{
    [NSUserDefaults.standardUserDefaults setInteger:switcherModeModifierFlags forKey:CPDefaultsSwitcherKeyboardShortcutModifierFlags];
}

@end
