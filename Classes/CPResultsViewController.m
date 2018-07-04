//
//  CPResultsViewController.m
//  CodePilot
//
//  Created by Anthony Dervish on 05/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//

#import "CPResultsViewController.h"
#import "CPStatusLabel.h"
#import "CPSymbol.h"
#import "CPSearchField.h"
#import "CPFileReference.h"
#import "CPXcodeWrapper.h"
#import "CPSearchController.h"

@interface CPResultsViewController ()
@property (weak) IBOutlet NSLayoutConstraint *resultsTableBottomSpaceConstraint;
@property (weak) IBOutlet NSLayoutConstraint *resultsTableTopSpaceConstraint;
@property (weak) IBOutlet NSLayoutConstraint *resultsTableHeightConstraint;
@property (nonatomic) BOOL hasAwoken;
@end

@implementation CPResultsViewController {
    float _originalBottomSpaceConstant, _originalTopSpaceConstant;
}
@synthesize isSwitcher = _isSwitcher;

- (instancetype)initWithSearchController:(CPSearchController *)searchController
{
    self = [super init];
    if (self) {
        self.searchController = searchController;
        self.xcodeWrapper = searchController.xcodeWrapper;
    }
    return self;
}

-(void)awakeFromNib
{
    if (!self.hasAwoken) {
        self.hasAwoken = YES;
        self.resultsTableView.doubleAction = @selector(doubleClickedOnResult:);
        _originalBottomSpaceConstant = self.resultsTableBottomSpaceConstraint.constant;
        _originalTopSpaceConstant = self.resultsTableTopSpaceConstraint.constant;
    }
}

-(void)setIsSwitcher:(BOOL)isSwitcher {
    if (_isSwitcher && !isSwitcher) {
        // Transform to full search interface
        self.searchController.searchField.hidden = NO;
        self.lowerStatusLabel.isInactive = NO;
        self.resultsTableTopSpaceConstraint.constant = _originalTopSpaceConstant;
        self.resultsTableBottomSpaceConstraint.constant = _originalBottomSpaceConstant;
    }
    else if (!_isSwitcher && isSwitcher) {
        // Transform to switcher
        self.searchController.searchField.hidden = YES;
        self.lowerStatusLabel.isInactive = YES;
        self.resultsTableTopSpaceConstraint.constant -= 50.0;
        self.resultsTableBottomSpaceConstraint.constant = 12.0;
    }
    _isSwitcher = isSwitcher;
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
    [self performClose:self];
}

-(void)doubleClickedOnResult:(id)sender
{
    if (sender==self.resultsTableView) {
        CPResult *clickedResult = [self resultAtRow:self.resultsTableView.clickedRow];
        if (clickedResult) {
            [self.searchController jumpToResult:clickedResult openMode:CPOpenModeCurrentEditor];
            [self performClose:self];
        }
    }
}
-(void)performClose:(id)sender
{
    self.searchController.searchString = @"";
    self.searchController.selectedObject = nil;
    self.searchField.stringValue = @"";
    self.searchField.label = nil;
    [self.view.window.windowController hideWindow];
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

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return self.searchController.extendedDisplay ? 50.0 : 32.0;
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
#pragma mark - Utilities
/*==================================================================================================
 */

-(CPResult*)resultAtRow:(NSInteger)row
{
    CPResult *result = nil;
    if (row >=0 && row < [self.resultsArrayController.arrangedObjects count]) {
        result = self.resultsArrayController.arrangedObjects[row];
    }
    return result;
}

@end
