//
//  CPCodePilotPlugin.h
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 2/18/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CPCodePilotWindowController, CPXcodeWrapper, PBXGroup, CPPluginInstaller;

@interface CPCodePilotPlugin : NSObject
@property (nonatomic, strong) CPXcodeWrapper *xcWrapper;
@property (nonatomic, strong) CPCodePilotWindowController *windowController;
@property (nonatomic, strong) CPPluginInstaller *installer;
@property (nonatomic, strong) NSString *userKeyEquivalent;
@property (nonatomic, assign) BOOL thisVersionFirstRun;
@property (nonatomic, assign) BOOL firstRunEver;
@property (nonatomic, assign) BOOL isUserLevelDebugOn;
@property (nonatomic, assign) BOOL isInDocumentationMode;
@property (nonatomic, assign) unsigned long long userKeyEquivalentModifierMask;
@property (nonatomic) NSUInteger switcherModeKeyCode;
@property (nonatomic) NSEventModifierFlags switcherModeModifierFlags;

+ (instancetype)sharedInstance;
+ (void)pluginDidLoad:(id)arg1;

- (void)openCodePilotWindow;
- (void)checkForFirstRun;
@end

#define CODE_PILOT_PLUGIN ([CPCodePilotPlugin sharedInstance])