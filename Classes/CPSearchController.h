//
//  SearchController.h
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 2/9/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CPCodePilotConfig.h"
#import "CPSearchFieldDelegate.h"

@class CPXcodeWrapper,  CPSearchField, CPStatusLabel, CPResult;

enum {
  DataModeRecentJumps = 1,
  DataModeMatchingFiles = 2,
  DataModeMatchingSymbols = 3
  
} DataMode;

@interface CPSearchController : NSObject <NSTextFieldDelegate,NSTableViewDataSource,NSTableViewDelegate,CPSearchFieldDelegate>
@property (nonatomic, weak) NSControl *indexingProgressIndicator;
@property (nonatomic, weak) CPSearchField *searchField;
@property (nonatomic, weak) NSTableView *tableView;
@property (nonatomic, weak) CPStatusLabel *upperStatusLabel;
@property (nonatomic, weak) CPStatusLabel *lowerStatusLabel;
@property (nonatomic, weak) CPStatusLabel *infoStatusLabel;
@property (nonatomic, strong) CPXcodeWrapper *xcodeWrapper;
@property (nonatomic, strong) NSArray *suggestedObjects;
@property (nonatomic, assign) NSUInteger currentDataMode;
@property (nonatomic, strong) CPResult *selectedElement;
@property (nonatomic, copy) NSString *searchString;
@property (nonatomic) BOOL extendedDisplay;
@property (nonatomic,copy) NSIndexSet *resultSelectionIndexes; // For NSArrayController
@property (nonatomic, strong) CPResult *selectedObject;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;
- (void)selectRowAtIndex:(NSUInteger)rowIndex;
- (void)windowDidBecomeActive;
- (void)updateContentsWithSearchField;
- (void)setupRecentJumpsData;
- (void)setupMatchingFilesAndSymbolsData;
- (void)setupMatchingSymbolsData;
- (void)setupStatusLabels;
- (void)setupRecentJumpsStatusLabels;
- (void)setupMatchingFilesStatusLabels;
- (void)setupMatchingSymbolsStatusLabels;
- (NSDictionary *)upperStatusLabelStringAttributes;
- (NSDictionary *)lowerStatusLabelStringAttributes;
- (void)setupLowerStatusLabelForMatchingFiles;
- (NSMutableAttributedString *)boldFacedStatusLabelString:(NSString *)str;
- (void)windowDidBecomeInactive;
- (void)windowWillBecomeActive;
- (void)saveSelectedElement;
- (void)updateSelectionAfterDataChange;
#ifdef PRESERVE_SELECTION
- (NSInteger)indexOfObjectIsSuggestedCurrentlyForObject:(id)object;
#endif
- (void)noteQueriesChanged;
- (void)noteProjectIndexChanged;
- (void)setupInfoStatusLabel;
- (NSDictionary *)infoStatusLabelUnregisteredStringAttributes;
- (NSDictionary *)infoStatusLabelNextVersionAvailableStringAttributes;
- (void)setupTooMuchResultsStatusLabels;

- (NSFont *)statusLabelFont;
- (NSMutableAttributedString *)normalFacedStatusLabelString:(NSString *)str;
-(void)jumpToResult:(CPResult*)result;


// ACTIONS
-(IBAction)selectNext:(id)sender;
-(IBAction)selectPrevious:(id)IBActionsender;
-(IBAction)pageDown:(id)senderIBAction;
-(IBAction)pageUp:(id)sender;
-(IBAction)jumpToSelectedResult:(id)sender;
@end