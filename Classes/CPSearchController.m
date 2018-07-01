//
//  SearchController.m
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 2/9/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import "CPSearchController.h"
#import "CPCodePilotWindowController.h"
#import "CPXcodeWrapper.h"
#import "CPCodePilotConfig.h"
#import "CPSearchField.h"
#import "CPFileReference.h"
#import "CPStatusLabel.h"
#import "CPSymbol.h"
#import "CPResult.h"

static void *RESULT_SELECTION_CHANGED = &RESULT_SELECTION_CHANGED;
static void *QUERY_CHANGED = &QUERY_CHANGED;

CPOpenSpecifier *CPOpenModeNewWindow;
CPOpenSpecifier *CPOpenModeNewTab;
CPOpenSpecifier *CPOpenModeCurrentEditor;
CPOpenSpecifier *CPOpenModeVerticalSplit;
CPOpenSpecifier *CPOpenModeHorizontalSplit;

@interface CPSearchController()
@property (nonatomic) NSUInteger resultSelectionIndex;
@property (nonatomic,copy,readonly) NSIndexSet *indexesOfSelectableResults;
@end
@implementation CPSearchController {
    NSDictionary *_urlToTabController;
}

+ (void)initialize
{
    if (self == [CPSearchController class]) {
        CPOpenModeNewWindow = [CPOpenSpecifier openSpecifierWithMode:CP_OPEN_IN_NEW_WINDOW];
        CPOpenModeNewTab = [CPOpenSpecifier openSpecifierWithMode:CP_OPEN_IN_NEW_TAB];
        CPOpenModeVerticalSplit = [CPOpenSpecifier openSpecifierWithMode:CP_OPEN_IN_VSPLIT];
        CPOpenModeHorizontalSplit = [CPOpenSpecifier openSpecifierWithMode:CP_OPEN_IN_HSPLIT];
        CPOpenModeCurrentEditor = [CPOpenSpecifier openSpecifierWithMode:CP_OPEN_IN_CURRENT_EDITOR];
    }
}
- (id)init
{
    self = [super init];
    
    if (self) {
        self.suggestedObjects = [NSArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(noteQueriesChanged)
                                                     name:MCXcodeWrapperReloadedIndex
                                                   object:nil];
        [self addObserver:self
               forKeyPath:@"resultSelectionIndex"
                  options:NSKeyValueObservingOptionInitial
                  context:RESULT_SELECTION_CHANGED];
        [self addObserver:self
               forKeyPath:@"selectedObject"
                  options:0
                  context:QUERY_CHANGED];
        [self addObserver:self
               forKeyPath:@"searchString"
                  options:0
                  context:QUERY_CHANGED];
    }
    
    return self;
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"resultSelectionIndex"];
    [self removeObserver:self forKeyPath:@"selectedObject"];
    [self removeObserver:self forKeyPath:@"searchString"];
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - Properties
/*==================================================================================================
 */


-(NSIndexSet *)resultSelectionIndexes
{
    return self.resultSelectionIndex != NSNotFound
    ? [NSIndexSet indexSetWithIndex:self.resultSelectionIndex]
    : [NSIndexSet indexSet];
}

-(void)setResultSelectionIndexes:(NSIndexSet *)resultSelectionIndexes
{
    if (!resultSelectionIndexes.count) { _resultSelectionIndex = NSNotFound; return; }
    _resultSelectionIndex = resultSelectionIndexes.firstIndex;
}
+(NSSet *)keyPathsForValuesAffectingResultSelectionIndexes
{
    return [NSSet setWithObjects:@"resultSelectionIndex", nil];
}
+(NSSet *)keyPathsForValuesAffectingResultSelectionIndex
{
    return [NSSet setWithObjects:@"resultSelectionIndexes", nil];
}

-(NSIndexSet*)indexesOfSelectableResults
{
    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.suggestedObjects.count) ];
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - KVO
/*==================================================================================================
 */

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == RESULT_SELECTION_CHANGED) {
        self.selectedElement = self.resultSelectionIndex < self.suggestedObjects.count
        ? self.suggestedObjects[self.resultSelectionIndex]
        : nil;
    }
    else if (context == QUERY_CHANGED) {
        [self noteQueriesChanged];
    }
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - Actions
/*==================================================================================================
 */

-(void)selectNext:(id)sender
{
    if (self.indexesOfSelectableResults.count == 0) return ;
    if (self.resultSelectionIndex != NSNotFound) {
        NSUInteger newIdx = [self.indexesOfSelectableResults indexGreaterThanIndex:self.resultSelectionIndex ] ;
        if (newIdx != NSNotFound) {
            self.resultSelectionIndex = newIdx;
        }
    }
    else {
        self.resultSelectionIndex = [self.indexesOfSelectableResults indexGreaterThanOrEqualToIndex:0];
    }
}

-(void)selectPrevious:(id)sender
{
    if (self.indexesOfSelectableResults.count == 0) return ;
    if (self.resultSelectionIndex != NSNotFound) {
        NSUInteger newIdx = [ self.indexesOfSelectableResults indexLessThanIndex:self.resultSelectionIndex ] ;
        if (newIdx != NSNotFound) {
            self.resultSelectionIndex = newIdx;
        }
    }
    else {
        self.resultSelectionIndex = [self.indexesOfSelectableResults indexLessThanOrEqualToIndex:(self.suggestedObjects.count-1)];
    }
}
-(void)pageDown:(id)sender { /* TODO */; }
-(void)pageUp:(id)sender { /* TODO */; }

-(IBAction)jumpToSelectedResult:(id)sender
{
    CPOpenFileMode openMode = CP_OPEN_IN_CURRENT_EDITOR;
    if ([sender isKindOfClass:CPOpenSpecifier.class]) {
        openMode = [(CPOpenSpecifier*)sender openMode];
    }
    else {
        openMode = [CPOpenSpecifier openSpecifierForCurrentModifierFlags].openMode;
    }
    [self jumpToResult:self.selectedElement openMode:openMode];
}
/*
 *
 *
 *================================================================================================*/
#pragma mark - Etc.
/*==================================================================================================
 */


- (void)noteQueriesChanged
{
    if (OUR_WINDOW_IS_OPEN) {
        [self updateContentsWithSearchField];
    }
}

// called whenever project index building was finished
- (void)noteProjectIndexChanged
{
    [self noteQueriesChanged];
}

- (void)selectRowAtIndex:(NSUInteger)rowIndex
{
    NSIndexSet *selectedRowIndexSet = [NSIndexSet indexSetWithIndex:rowIndex];
    [self.tableView selectRowIndexes:selectedRowIndexSet byExtendingSelection:NO];
    [self.tableView scrollRowToVisible:[self.tableView selectedRow]];
}

- (void)windowDidBecomeInactive
{
    _urlToTabController = nil;
}

// before the window is on screen
- (void)windowWillBecomeActive
{
    [self.searchField reset];
    
    [_xcodeWrapper updateRecentFiles];
    _urlToTabController = _xcodeWrapper.tabControllersByURL;
    
    [self updateContentsWithSearchField];
    [self selectRowAtIndex:0];
}

// after the window appeared on the screen
- (void)windowDidBecomeActive
{
    [[self.searchField window] makeFirstResponder:self.searchField];
    
    NSNumber *autocopySelection = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULTS_AUTOCOPY_SELECTION_KEY] ?: @(DEFAULT_AUTOCOPY_SELECTION_VALUE);
    
    if ([autocopySelection boolValue]) {
        NSString *currentSelection = [self.xcodeWrapper currentSelectionSymbolString];
        
        if (!IsEmpty(currentSelection)) {
            [self.searchField pasteString:currentSelection];
        }
    }
}

- (void)saveSelectedElement
{
    self.selectedElement = self.resultSelectionIndex != NSNotFound ? self.suggestedObjects[self.resultSelectionIndex] : nil;
}


// tries to remain selection, or selects first element
- (void)updateSelectionAfterDataChange
{
#ifdef PRESERVE_SELECTION
    NSInteger currentObjectIndex = self.selectedElement ? [self indexOfObjectIsSuggestedCurrentlyForObject:self.selectedElement] : NSNotFound;
    
    if (NSNotFound != currentObjectIndex) {
        [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:currentObjectIndex] byExtendingSelection:0];
        [self saveSelectedElement];
        
    } else if ([self.suggestedObjects count] > 0) {
        [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:0];
        [self saveSelectedElement];
    }
#else
    if ([self.suggestedObjects count] > 0) {
        [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:0];
        [self saveSelectedElement];
        
    } else {
        self.selectedElement = nil;
    }
#endif
}

#ifdef PRESERVE_SELECTION
- (NSInteger)indexOfObjectIsSuggestedCurrentlyForObject:(id)object
{
    for (id suggestedObject in self.suggestedObjects) {
        if ([[suggestedObject name] isEqualToString:[object name]]) {
            return [self.suggestedObjects indexOfObject:suggestedObject];
        }
    }
    
    return NSNotFound;
}
#endif

#pragma mark - Data Setup
- (void)setupRecentJumpsData
{
    self.currentDataMode = DataModeRecentJumps;
    self.extendedDisplay = NO; // Must come before setting 'suggestedObjects'!
    self.suggestedObjects = [self.xcodeWrapper recentlyVisited];
    for (CPFileReference *fileRef in self.suggestedObjects) {
        fileRef.isOpen = (_urlToTabController[fileRef.fileURL] != nil);
    }
}

- (void)setupMatchingFilesAndSymbolsData
{
    self.currentDataMode = DataModeMatchingFiles;
    self.extendedDisplay = YES; // Must come before setting 'suggestedObjects'!
    self.suggestedObjects = [self.xcodeWrapper filesAndSymbolsFromProjectForQuery:self.searchString];
    
}

- (void)setupMatchingSymbolsData
{
    self.currentDataMode = DataModeMatchingSymbols;
    self.extendedDisplay = NO; // Must come before setting 'suggestedObjects'!
    self.suggestedObjects = [self.xcodeWrapper contentsForQuery:self.searchString
                                                     fromResult:self.selectedObject];
}

#pragma mark - Status Labels
- (NSDictionary *)infoStatusLabelUnregisteredStringAttributes
{
    NSMutableParagraphStyle *leftAlignedParagraphStyle = [NSMutableParagraphStyle new];
    leftAlignedParagraphStyle.alignment = NSTextAlignmentCenter;
    
    return [[NSDictionary alloc] initWithObjectsAndKeys: leftAlignedParagraphStyle, NSParagraphStyleAttributeName,
            WINDOW_INFO_LABEL_UNREGISTERED_FONT_COLOR, NSForegroundColorAttributeName,
            nil];
}

- (NSDictionary *)infoStatusLabelNextVersionAvailableStringAttributes
{
    NSMutableParagraphStyle *leftAlignedParagraphStyle = [NSMutableParagraphStyle new];
    leftAlignedParagraphStyle.alignment = NSTextAlignmentCenter;
    
    return [[NSDictionary alloc] initWithObjectsAndKeys: leftAlignedParagraphStyle, NSParagraphStyleAttributeName,
            WINDOW_INFO_LABEL_NEW_VERSION_AVAILABLE_FONT_COLOR, NSForegroundColorAttributeName,
            nil];
}

- (NSDictionary *)upperStatusLabelStringAttributes
{
    NSMutableParagraphStyle *leftAlignedParagraphStyle = [NSMutableParagraphStyle new];
    leftAlignedParagraphStyle.alignment = NSTextAlignmentLeft;
    
    return [[NSDictionary alloc] initWithObjectsAndKeys: leftAlignedParagraphStyle, NSParagraphStyleAttributeName,
            [self statusLabelFont], NSFontAttributeName,
            nil];
}

- (NSDictionary *)lowerStatusLabelStringAttributes
{
    NSMutableParagraphStyle *rightAlignedParagraphStyle = [NSMutableParagraphStyle new];
    rightAlignedParagraphStyle.alignment = NSTextAlignmentRight;
    
    return [[NSDictionary alloc] initWithObjectsAndKeys: rightAlignedParagraphStyle, NSParagraphStyleAttributeName,
            [self statusLabelFont], NSFontAttributeName,
            nil];
}

- (NSMutableAttributedString *)boldFacedStatusLabelString:(NSString *)str
{
    if (IsEmpty(str)) {
        return [[NSMutableAttributedString alloc] init];
    }
    
    NSMutableDictionary *boldAttributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           [NSColor secondaryLabelColor], NSForegroundColorAttributeName,
                                           [NSNumber numberWithFloat:0.8],  NSKernAttributeName,
                                           [self boldStatusLabelFont], NSFontAttributeName,
                                           nil];
    
    return [[NSMutableAttributedString alloc] initWithString:str attributes:boldAttributes];
}

- (NSMutableAttributedString *)normalFacedStatusLabelString:(NSString *)str
{
    if (IsEmpty(str)) {
        return [[NSMutableAttributedString alloc] init];
    }
    
    NSMutableDictionary *normalAttributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                             [NSColor secondaryLabelColor], NSForegroundColorAttributeName,
                                             [self statusLabelFont], NSFontAttributeName,
                                             nil];
    
    return [[NSMutableAttributedString alloc] initWithString:str attributes:normalAttributes];
}

- (NSFont *)statusLabelFont
{
    return [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSControlSizeRegular]];
}
- (NSFont *)boldStatusLabelFont
{
    return [NSFont boldSystemFontOfSize:[NSFont systemFontSizeForControlSize:NSControlSizeRegular]];
}

- (void)setupRecentJumpsStatusLabels
{
    if ([self.suggestedObjects count] > 0) {
        NSMutableAttributedString *attributedLabel = [self normalFacedStatusLabelString:@"Recently opened files in "];
        
        [attributedLabel appendAttributedString:[self boldFacedStatusLabelString:[self.xcodeWrapper currentProjectName]]];
        [attributedLabel appendAttributedString:[self normalFacedStatusLabelString:@":"]];
        
        [self.upperStatusLabel setAttributedStringValue:attributedLabel];
        
        [self setupLowerStatusLabelForMatchingFiles];
    } else {
        [self.upperStatusLabel setHidden:YES];
        [self.lowerStatusLabel setHidden:YES];
    }
}

- (void)setupLowerStatusLabelForMatchingFiles
{
    NSMutableAttributedString *attributedLabel = [NSMutableAttributedString new];
    
    if (nil != self.selectedElement) {
        attributedLabel = [[NSMutableAttributedString alloc] initWithString:@" " // to set the alignment
                                                                 attributes:[self lowerStatusLabelStringAttributes]];
        
        [attributedLabel appendAttributedString:[self normalFacedStatusLabelString:@"Press "]];
        
        if ([self.selectedElement isSearchable]) {
            [attributedLabel appendAttributedString:[self boldFacedStatusLabelString:@"[space]"]];
            [attributedLabel appendAttributedString:[self normalFacedStatusLabelString:@" for contents"]];
        }
        
        if ([self.selectedElement isOpenable]) {
            if ([self.selectedElement isSearchable]) {
                [attributedLabel appendAttributedString:[self normalFacedStatusLabelString:@", "]];
            }
            [attributedLabel appendAttributedString:[self boldFacedStatusLabelString:@"[enter]"]];
            [attributedLabel appendAttributedString:[self normalFacedStatusLabelString:@" to open"]];
        }
    }
    
    [self.lowerStatusLabel setAttributedStringValue:attributedLabel];
}

- (void)setupMatchingFilesStatusLabels
{
    NSInteger count = [self.suggestedObjects count];
    
    NSString *basicString = [NSString nounWithCount:count forNoun:@"match"];
    
    NSMutableAttributedString *attributedLabel = [self normalFacedStatusLabelString:basicString];
    
    [attributedLabel appendAttributedString:[self normalFacedStatusLabelString:@" found in "]];
    [attributedLabel appendAttributedString:[self boldFacedStatusLabelString:[self.xcodeWrapper currentProjectName]]];
    [attributedLabel appendAttributedString:[self normalFacedStatusLabelString:@":"]];
    [self.upperStatusLabel setAttributedStringValue:attributedLabel];
    [self setupLowerStatusLabelForMatchingFiles];
}

- (void)setupMatchingSymbolsStatusLabels
{
    NSString *basicString = [NSString nounWithCount:[self.suggestedObjects count] forNoun:@"matching symbol"];
    
    NSMutableAttributedString *attributedLabel = [self normalFacedStatusLabelString:basicString];
    
    
    [attributedLabel appendAttributedString:[self normalFacedStatusLabelString:@" found in "]];
    [attributedLabel appendAttributedString:[self boldFacedStatusLabelString:[self.selectedObject name]]];
    
    NSString *suffix = @":";
    if ([self.selectedObject isKindOfClass:[CPSymbol class]]) {
        suffix = [NSString stringWithFormat:@" %@:", [(CPSymbol *)self.selectedObject symbolTypeName]];
    }
    
    [attributedLabel appendAttributedString:[self normalFacedStatusLabelString:suffix]];
    
    
    [self.upperStatusLabel setAttributedStringValue:attributedLabel];
    
    attributedLabel = [[NSMutableAttributedString alloc] initWithString:@" "
                                                             attributes:[self lowerStatusLabelStringAttributes]];
    
    [attributedLabel appendAttributedString:[self boldFacedStatusLabelString:@"[backspace]"]];
    [attributedLabel appendAttributedString:[self normalFacedStatusLabelString:@": go back"]];
    
    if ([self.selectedElement isSearchable]) {
        [attributedLabel appendAttributedString:[self normalFacedStatusLabelString:@", "]];
        [attributedLabel appendAttributedString:[self boldFacedStatusLabelString:@"[space]"]];
        [attributedLabel appendAttributedString:[self normalFacedStatusLabelString:@": contents"]];
    }
    
    if ([self.selectedElement isOpenable]) {
        [attributedLabel appendAttributedString:[self normalFacedStatusLabelString:@", "]];
        [attributedLabel appendAttributedString:[self boldFacedStatusLabelString:@"[enter]"]];
        [attributedLabel appendAttributedString:[self normalFacedStatusLabelString:@": open"]];
    }
    
    [self.lowerStatusLabel setAttributedStringValue:attributedLabel];
}

- (void)setupTooMuchResultsStatusLabels
{
    [self.lowerStatusLabel setHidden:YES];
    [self.upperStatusLabel setHidden:NO];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:TOO_MANY_RESULTS_STRING
                                                                           attributes:[self upperStatusLabelStringAttributes]];
    
    [self.upperStatusLabel setAttributedStringValue:attributedString];
}

- (void)setupStatusLabels
{
    [self.upperStatusLabel setAttributedStringValue:[[NSAttributedString alloc] init]];
    [self.lowerStatusLabel setAttributedStringValue:[[NSAttributedString alloc] init]];
    [self.upperStatusLabel setHidden:NO];
    [self.lowerStatusLabel setHidden:NO];
    [self setupInfoStatusLabel];
    
    if ([self numberOfRowsInTableView:self.tableView] > MAX_OBJECT_COUNT_FOR_SORT_AND_FILTER) {
        [self setupTooMuchResultsStatusLabels];
    } else {
        switch (self.currentDataMode) {
            case DataModeMatchingFiles:
                [self setupMatchingFilesStatusLabels];
                break;
            case DataModeMatchingSymbols:
                [self setupMatchingSymbolsStatusLabels];
                break;
            case DataModeRecentJumps:
                [self setupRecentJumpsStatusLabels];
                break;
        }
    }
}

- (void)setupInfoStatusLabel
{
    if (nil != self.infoStatusLabel) {
        [self.infoStatusLabel setStringValue:@""];
        self.infoStatusLabel.clickUrl = nil;
    }
}

- (void)updateContentsWithSearchField
{
    if (self.selectedObject) {
        [self setupMatchingSymbolsData];
        
    } else if (IsEmpty(self.searchString)) {
        [self setupRecentJumpsData];
        
    } else {
        [self setupMatchingFilesAndSymbolsData];
    }
    
    [self.tableView reloadData];
    [self.tableView noteHeightOfRowsWithIndexesChanged:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self.suggestedObjects count])]];
    
    BOOL shouldHideEnclosingScrollView = 0 == [self numberOfRowsInTableView:self.tableView] || [self numberOfRowsInTableView:self.tableView] > MAX_OBJECT_COUNT_FOR_SORT_AND_FILTER;
    [[self.tableView enclosingScrollView] setHidden:shouldHideEnclosingScrollView];
    
    [self updateSelectionAfterDataChange];
    [self setupStatusLabels];
    
}

#pragma mark - Search Field Delegate
- (BOOL)spacePressedForSearchField:(CPSearchField *)searchField
{
    if (self.selectedElement && [self.selectedElement isSearchable]) {
        self.searchField.label = self.selectedElement.name;
        self.selectedObject = self.selectedElement;
        self.searchString = @"";
    }
    
    return YES; // it wasn't handled.
}

- (BOOL)cmdBackspacePressedForSearchField:(CPSearchField *)searchField
{
    //TODO:
    return NO;
    
}

-(BOOL)deleteLabelForSearchField:(CPSearchField*)searchField
{
    if (self.selectedObject) {
        self.selectedObject = nil;
        self.searchField.label = nil;
        return YES;
    }
    return NO;
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)command
{
    if (@selector(moveDown:) == command) {
        NSInteger nextRowIndex = [self.tableView selectedRow]+1;
        if (nextRowIndex < [self numberOfRowsInTableView:self.tableView]) {
            [self selectRowAtIndex:nextRowIndex];
            [self saveSelectedElement];
            [self setupStatusLabels];
        }
        return YES;
    }
    
    if (@selector(moveUp:) == command) {
        NSInteger prevRowIndex = [self.tableView selectedRow]-1;
        if (prevRowIndex >= 0) {
            [self selectRowAtIndex:prevRowIndex];
            [self saveSelectedElement];
            [self setupStatusLabels];
        }
        return YES;
    }
    
    if (@selector(insertLineBreak:) == command) {
        return YES;
    }
    
    if (@selector(insertContainerBreak:) == command) {
        return YES;
    }
    
    // enter - file opening
    if (@selector(insertNewline:) == command || @selector(PBX_insertNewlineAndIndent:) == command) {
        if (self.selectedElement) {
            [(CPCodePilotWindowController *)[[self.searchField window] delegate] hideWindow];
            [self jumpToSelectedResult:self];
        }
        
        return YES;
    }
    
    // escape - we step aside
    if (@selector(cancelOperation:) == command) {
        [(CPCodePilotWindowController *)[[self.searchField window] delegate] hideWindow];
        return YES;
    }
    
    if ([self.tableView respondsToSelector:command]) {
        if (@selector(scrollToBeginningOfDocument:) == command) {
            [self.tableView scrollToBeginningOfDocument:self];
            return YES;
        }
        
        if (@selector(scrollToEndOfDocument:) == command) {
            [self.tableView scrollToEndOfDocument:self];
            return YES;
        }
    }
    
    
    if (@selector(scrollPageUp:) == command) {
        [[self.tableView enclosingScrollView] pageUp:self];
        return YES;
    }
    
    if (@selector(scrollPageDown:) == command) {
        [[self.tableView enclosingScrollView] pageDown:self];
        return YES;
    }
    
    return NO;
}

-(void)jumpToResult:(CPResult*)result openMode:(CPOpenFileMode)openMode
{
    if (result) {
        id tabController = [result isKindOfClass:CPFileReference.class] ? _urlToTabController[[(CPFileReference*)result fileURL]] : nil;
        [self.xcodeWrapper openFileOrSymbol:result tabController:tabController openMode:openMode];
    }
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [self.suggestedObjects count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    @try {
        return [self.suggestedObjects objectAtIndex:rowIndex];
    }
    @catch (NSException * e) {
    }
    return nil;
}

#pragma mark - Table View Delegate
- (NSString *)tableView:(NSTableView *)aTableView toolTipForCell:(NSCell *)aCell rect:(NSRectPointer)rect tableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)row mouseLocation:(NSPoint)mouseLocation
{
    return nil;
}

@end

@implementation CPOpenSpecifier
+(instancetype)openSpecifierWithMode:(CPOpenFileMode)mode
{
    return [[self alloc] initWithMode:mode];
}
+(instancetype)openSpecifierForCurrentModifierFlags
{
    CPOpenFileMode openMode = CP_OPEN_IN_CURRENT_EDITOR;
    NSEventModifierFlags modifiers = [[NSApp currentEvent] modifierFlags];
    if ((modifiers & NSEventModifierFlagControl) != 0) {
        openMode = [NSUserDefaults.standardUserDefaults integerForKey:DEFAULTS_CTRL_OPEN_ACTION_KEY];
    }
    return [[self alloc] initWithMode:openMode];
    
}
- (instancetype)initWithMode:(CPOpenFileMode)mode
{
    self = [super init];
    if (self) {
        self.openMode = mode;
    }
    return self;
}
@end
