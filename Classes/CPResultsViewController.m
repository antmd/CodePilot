//
//  CPResultsViewController.m
//  CodePilot
//
//  Created by Anthony Dervish on 05/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//

#import "CPResultsViewController.h"
#import "CPSymbol.h"
#import "CPFileReference.h"
#import "CPXcodeWrapper.h"
#import "CPSearchController.h"

@interface CPResultsViewController ()

@end

@implementation CPResultsViewController

- (instancetype)initWithSearchController:(CPSearchController *)searchController
{
  self = [super init];
  if (self) {
    self.searchController = searchController;
    self.xcodeWrapper = searchController.xcodeWrapper;
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

-(NSString *)nibName
{
  return @"CPResultsViewController";
}

-(NSBundle *)nibBundle
{
  return [NSBundle bundleForClass:CPResultsViewController.class];
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - CPResultsController Protocol
/*==================================================================================================
 */

-(void)selectNextResult:(id)sender
{
  [self.searchController selectNext:self];
}
-(void)selectPreviousResult:(id)sender
{
  [self.searchController selectPrevious:self];
}
-(void)selectResultPageDown:(id)sender
{
  [self.searchController pageDown:self];
}
-(void)selectResultPageUp:(id)sender
{
  [self.searchController pageUp:self];
}
-(void)performDefaultAction:(id)sender
{
  [self.searchController jumpToSelectedResult:self];
}

-(void)doubleClickedOnResult:(id)sender
{
  
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - NSTableViewDelegate
/*==================================================================================================
 */


-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  id obj = self.resultsArrayController.arrangedObjects[row];
  NSView *view = nil;
  if (self.searchController.extendedDisplay) {
    view = [tableView makeViewWithIdentifier:@"FileOrSymbolResult" owner:self];
  }
  else {
    if ([obj isKindOfClass:CPSymbol.class]) {
      view = [tableView makeViewWithIdentifier:@"SymbolResult" owner:self];
    }
    else if ([obj isKindOfClass:CPFileReference.class]) {
      view = [tableView makeViewWithIdentifier:@"FileResult" owner:self];
    }
  }
  return view;
}

-(NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
  return [tableView makeViewWithIdentifier:@"ResultsRowView" owner:self];
  
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
  if (notification.object == self.resultsTableView) {
    NSTableView *tableView = notification.object;
    [tableView scrollRowToVisible:tableView.selectedRow];
  }
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - Utilities
/*==================================================================================================
 */

-(CPResult*)resultAtRow:(NSInteger)row
{
  CPResult *result = nil;
  if (row >=0 && row < self.resultsTableView.numberOfRows) {
    result = self.resultsArrayController.arrangedObjects[row];
  }
  return result;
}

@end
