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
#pragma mark - NSTableViewDelegate
/*==================================================================================================
 */


-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  id obj = self.resultsArrayController.arrangedObjects[row];
  NSView *view = nil;
  if ([obj isKindOfClass:CPSymbol.class]) {
    view = [tableView makeViewWithIdentifier:@"SymbolResult" owner:self];
  }
  else if ([obj isKindOfClass:CPFileReference.class]) {
    view = [tableView makeViewWithIdentifier:@"FileResult" owner:self];
  }
  else {
    view = [tableView makeViewWithIdentifier:@"FileOrSymbolResult" owner:self];
  }
  return view;
}

@end
