//
//  CPResultsViewController.h
//  CodePilot
//
//  Created by Anthony Dervish on 05/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CPResultController.h"

@class CPSearchField;
@class CPSearchController;
@class CPStatusLabel;
@class CPXcodeWrapper;

@interface CPResultsViewController : NSViewController <NSTableViewDelegate, CPResultController>
@property (unsafe_unretained) IBOutlet CPSearchField *searchField;
@property (unsafe_unretained) IBOutlet NSTableView *resultsTableView;
@property (strong) IBOutlet NSArrayController *resultsArrayController;
@property (weak) CPSearchController *searchController;
@property (unsafe_unretained) IBOutlet CPStatusLabel *upperStatusLabel;
@property (unsafe_unretained) IBOutlet CPStatusLabel *lowerStatusLabel;
@property (unsafe_unretained) IBOutlet NSProgressIndicator *indexingProgressIndicator;
@property (weak) CPXcodeWrapper *xcodeWrapper;
@property (nonatomic) BOOL isSwitcher;

-(instancetype)initWithSearchController:(CPSearchController*)searchController;

@end
