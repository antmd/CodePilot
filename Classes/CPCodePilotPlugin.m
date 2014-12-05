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

@implementation CPCodePilotPlugin
+ (void)pluginDidLoad:(id)arg1
{
}

+ (void)load
{
  LOG(@"CODE PILOT: CURRENT_XCODE_VERSION: %@ CURRENT_XCODE_REVISION: %@", CURRENT_XCODE_VERSION, CURRENT_XCODE_REVISION);
  
  // just instantiate the singleton
  (void)[CPCodePilotPlugin sharedInstance];
}

- (id)init
{
  self = [super init];
  
  if (self) {
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
	}
  
  return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
  self.installer = [[CPPluginInstaller alloc] init];
  
  [self.installer installPlugin:self];
  
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

+ (instancetype)sharedInstance
{
  static id sharedInstance;
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    sharedInstance = [[CPCodePilotPlugin alloc] init];
  });
  
  return sharedInstance;
}
@end
