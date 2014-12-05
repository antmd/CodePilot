//
//  CPCodePilotWindowController.m
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 2/9/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import "CPCodePilotWindowController.h"
#import "CPXcodeWrapper.h"
#import "CPSearchController.h"
#import "CPWindow.h"
#import "CPCodePilotConfig.h"
#import "CPStatusLabel.h"
#import "CPSearchField.h"
#import "CPSearchFieldTextView.h"
#import "CPResultsViewController.h"

@interface CPCodePilotWindowController ()
@property (strong,nonatomic) CPResultsViewController *resultsViewController;
@end

@implementation CPCodePilotWindowController
- (id)initWithXcodeWrapper:(CPXcodeWrapper *)xcodeWrapper
{
	self = [super init];
  
  if (self) {
    self.ourWindowIsOpen = NO;
    
    self.searchController = [CPSearchController new];
    [self.searchController setXcodeWrapper:xcodeWrapper];
    
    self.window = [[CPWindow alloc] initWithDefaultSettings];
    [self.window setDelegate:self];
    
    CPResultsViewController *resultsViewController = [[CPResultsViewController alloc] initWithSearchController:self.searchController];
    self.window.contentView = resultsViewController.view; // Loads the view ... must happen before referring to subviews below
    resultsViewController.searchField.delegate = self.searchController;
    [self.searchController setSearchField:resultsViewController.searchField];
    [self.searchController setIndexingProgressIndicator:(NSControl*)resultsViewController.indexingProgressIndicator];
    [self.searchController setUpperStatusLabel:resultsViewController.upperStatusLabel];
    [self.searchController setLowerStatusLabel:resultsViewController.lowerStatusLabel];
    self.resultsViewController = resultsViewController;
    //    [self.searchController setInfoStatusLabel:[self.window.searchWindowView infoStatusLabel]];
    
	}
  
	return self;
}


- (void)openWindow
{
	if (self.ourWindowIsOpen) {
		return;
	}
  
	[self.searchController windowWillBecomeActive];
    [self.window center];
	[self.window makeKeyAndOrderFront:self];
	[self.searchController windowDidBecomeActive];
	self.ourWindowIsOpen = YES;
}

- (void)hideWindow
{
	[self.window orderOut:self];
	self.ourWindowIsOpen = NO;
}

// we need custom field editor in order to work with search field the way we want
- (id)windowWillReturnFieldEditor:(NSWindow *)sender toObject:(id)anObject
{
	if ([anObject isKindOfClass:[CPSearchField class]]) {
		if (!self.searchFieldTextEditor) {
			self.searchFieldTextEditor = [[CPSearchFieldTextView alloc] init];
			[self.searchFieldTextEditor setFieldEditor:YES];
		}
		return self.searchFieldTextEditor;
	}
	return nil;
}

- (void)windowDidResignKey:(NSNotification *)notification
{
  //[self hideWindow];
}

- (void)windowDidResignMain:(NSNotification *)notification
{
}

- (void)windowWillClose:(NSNotification *)notification
{
  [self.searchController windowDidBecomeInactive];
}
@end