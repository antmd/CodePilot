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

CPOpenSpecifier *openSpecifierForCharacters(NSString* str);

@implementation CPCodePilotWindowController {
  id _localEventMonitor;
}
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

-(void)dealloc
{
  [self hideWindow];
}

-(void)openWindow
{
  [self openWindowWithModifierMask:0 keyCode:0];
}

- (void)openWindowWithModifierMask:(NSEventModifierFlags)modifierMask keyCode:(NSUInteger)keyCode
{
	if (self.ourWindowIsOpen) {
		return;
	}
  if (modifierMask) {
    __typeof(self) __weak weakSelf = self;
    _localEventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSFlagsChangedMask|NSKeyDownMask handler:^NSEvent *(NSEvent *event) {
      __typeof(self) this = weakSelf;
      if (event.type == NSFlagsChanged) {
        if ((event.modifierFlags & modifierMask) == 0) {
          [this hideWindow];
          [this.searchController performSelector:@selector(jumpToSelectedResult:) withObject:nil afterDelay:0.0];
        }
      }
      else { // NSKeyDown
        CPOpenSpecifier *openSpecifier = nil;
        if (event.keyCode == keyCode && (event.modifierFlags & modifierMask)) {
          // Shift + switcher key = move up in result list
          if (event.modifierFlags & NSShiftKeyMask) {
            [this.searchController selectPrevious:this];
          }
          else {
          // switcher key = move down in result list
            [this.searchController selectNext:this];
          }
          return nil;
        }
        else if ( (openSpecifier = openSpecifierForCharacters(event.charactersIgnoringModifiers)) ) {
          [this hideWindow];
          [this.searchController performSelector:@selector(jumpToSelectedResult:) withObject:openSpecifier afterDelay:0.0];
          return nil;
        }
        else { // Any other key hides the window
          [this hideWindow];
          return nil;
        }
      }
      return event;
    }];
  }
  
	[self.searchController windowWillBecomeActive];
    [self.window center];
	[self.window makeKeyAndOrderFront:self];
	[self.searchController windowDidBecomeActive];
  if (modifierMask) {
    // In switcher mode, advance to the file after the current one straight away
    [self.searchController selectNext:self];
  }
	self.ourWindowIsOpen = YES;
}

- (void)hideWindow
{
  if (_localEventMonitor) {
    [NSEvent removeMonitor:_localEventMonitor];
    _localEventMonitor = nil;
  }
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
  [self hideWindow];
}

- (void)windowDidResignMain:(NSNotification *)notification
{
}

- (void)windowWillClose:(NSNotification *)notification
{
  [self.searchController windowDidBecomeInactive];
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - NSResponder
/*==================================================================================================
 */
-(BOOL)acceptsFirstResponder
{
  return YES;
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - Actions
/*==================================================================================================
 */

-(IBAction)performClose:(id)sender
{
  [self hideWindow];
}
@end


CPOpenSpecifier *openSpecifierForCharacters(NSString* str)
{
  if (!str.length) { return nil; }
  switch ([str.lowercaseString characterAtIndex:0]) {
    case (unichar)'w': return CPOpenModeNewWindow;
    case (unichar)'t': return CPOpenModeNewTab;
    case (unichar)'v': case (unichar)'s': case (unichar)'a': return CPOpenModeVerticalSplit;
    case (unichar)'h': return CPOpenModeHorizontalSplit;
  }
  return nil;
}