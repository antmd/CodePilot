//
//  CPXcodeWrapper.m
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 2/9/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import "CPXcodeWrapper.h"
#import "CPCodePilotConfig.h"
#import "CPFileReference.h"
#import "CPSymbol.h"
#import "CPSymbolCache.h"
#import "NSArray+MiscExtensions.h"
#import "NSMutableArray+MiscExtensions.h"
#import "CPUniqueStack.h"
#import "CPWorkspaceSymbolCache.h"
#import "CPResult.h"
#import "XcodeUtils.h"
#import "IDEPegasusSourceEditor/_TtC22IDEPegasusSourceEditor20SourceCodeEditorView.h"
#import "IDEFoundation/IDESourceKitWorkspace.h"
#import "IDEFoundation/IDESourceKitResponseSymbolCollection.h"
#import "IDEFoundation/IDESourceKitResponseSymbolOccurrence.h"
#import <IDEFoundation/IDESourceKitSymbol.h>
#import "IDEWorkspaceDocument+CodePilot.h"

static NSString * const WorkspaceDocumentsKeyPath = @"workspaceDocuments";
static NSString * const IDEIndexWillIndexWorkspaceNotification = @"IDEIndexWillIndexWorkspaceNotification";
static NSString * const IDEIndexDidIndexWorkspaceNotification = @"IDEIndexDidIndexWorkspaceNotification";
static NSString * const IDEEditorAreaLastActiveEditorContextDidChangeContextKey = @"IDEEditorContext";

@interface CPXcodeWrapper ()
@property (strong,readwrite,nonatomic) NSDictionary *tabControllersByURL;
@end


@implementation CPXcodeWrapper

/*
 *
 *
 *================================================================================================*/
#pragma mark - Lifecycle
/*==================================================================================================
 */


- (id)init
{
    self = [super init];
    
    if (self) {
        self.currentlyIndexedWorkspaces = [NSMutableArray array];
        self.workspaceSymbolCaches = [NSMutableArray array];

        // we monitor workspaces open to keep an up-to-date indexDB connections / query providers
        // open, because it requires a lot of resources to open. and monitoring workspaces.
        [[IDEDocumentController sharedDocumentController] addObserver:self
                                                           forKeyPath:WorkspaceDocumentsKeyPath
                                                              options:0
                                                              context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willIndexWorkspace:)
                                                     name:IDEIndexWillIndexWorkspaceNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didIndexWorkspace:)
                                                     name:IDEIndexDidIndexWorkspaceNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[IDEDocumentController sharedDocumentController] removeObserver:self forKeyPath:WorkspaceDocumentsKeyPath];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - Symbols Cache
/*==================================================================================================
 */


- (void)updateWorkspaceSymbolCacheForWorkspace:(IDEWorkspace *)workspace withWorkspaceSymbolCache:(CPWorkspaceSymbolCache *)newWorkspaceSymbolCache
{
    @synchronized (self.workspaceSymbolCaches) {
        CPWorkspaceSymbolCache *oldWorkspaceSymbolCache = [self workspaceSymbolCacheForWorkspace:workspace];
        
        NSUInteger oldWorkspaceSymbolCacheIndex = [self.workspaceSymbolCaches indexOfObject:oldWorkspaceSymbolCache];
        
        if (NSNotFound == oldWorkspaceSymbolCacheIndex) {
            [self.workspaceSymbolCaches addObject:newWorkspaceSymbolCache];
        } else {
            [self.workspaceSymbolCaches replaceObjectAtIndex:oldWorkspaceSymbolCacheIndex withObject:newWorkspaceSymbolCache];
        }
    }
}

- (void)updateWorkspaceSymbolCacheForWorkspace:(IDEWorkspace *)workspace
{
    @try {
        @synchronized (self.workspaceSymbolCaches) {
            [self _setSymbolCachingInProgress:YES];
            NSMutableArray *newSymbolCacheContents = [NSMutableArray array];
            
            NSArray *interestingSymbolKinds = [NSArray arrayWithObjects:
                                               [[DVTSourceCodeSymbolKind classSymbolKind] identifier],
                                               [[DVTSourceCodeSymbolKind containerSymbolKind] identifier],
                                               [[DVTSourceCodeSymbolKind fieldSymbolKind] identifier],
                                               [[DVTSourceCodeSymbolKind globalSymbolKind] identifier],
                                               [[DVTSourceCodeSymbolKind classMethodSymbolKind] identifier],
                                               [[DVTSourceCodeSymbolKind instanceMethodSymbolKind] identifier],
                                               [[DVTSourceCodeSymbolKind instanceVariableSymbolKind] identifier],
                                               [[DVTSourceCodeSymbolKind classVariableSymbolKind] identifier],
                                               [[DVTSourceCodeSymbolKind parameterSymbolKind] identifier],
                                               [[DVTSourceCodeSymbolKind macroSymbolKind] identifier],
                                               [[DVTSourceCodeSymbolKind propertySymbolKind] identifier],
                                               [[DVTSourceCodeSymbolKind unionSymbolKind] identifier],
                                               [[DVTSourceCodeSymbolKind localVariableSymbolKind] identifier], nil];
            
            for (DVTSourceCodeSymbolKind *symbolKind in interestingSymbolKinds) {
                NSError * err = nil;
                IDEIndexCollection *symbolsForKind = nil;
                @try {
                    symbolsForKind = [(IDESourceKitResponseSymbolCollection*)[workspace.index allSymbolsMatchingKind:symbolKind workspaceOnly:YES topLevelOnly:NO error:&err] ide_collection:workspace.index];
                }
                @catch(NSException*ex) {
                    
                }
                
                NSUInteger duplicateSymbols = 0;
                for (IDESourceKitResponseSymbolOccurrence *symbol in [symbolsForKind allObjects]) {
                    if ([newSymbolCacheContents containsObject:symbol]) {
                        duplicateSymbols++;
                    } else {
                        [newSymbolCacheContents addObject:symbol];
                    }
                }
            }
            
            CPWorkspaceSymbolCache *newWorkspaceSymbolCache = [CPWorkspaceSymbolCache symbolCacheWithSymbols:newSymbolCacheContents
                                                                                                forWorkspace:workspace];
            
            [self updateWorkspaceSymbolCacheForWorkspace:workspace withWorkspaceSymbolCache:newWorkspaceSymbolCache];
            
            [self _setSymbolCachingInProgress:NO];
        }
    }
    @catch (NSException *exception) {
        LOG(@"EXCEPTION OCCURRED: %@", exception);
    }
}
- (void)willIndexWorkspace:(NSNotification *)notification
{
    @synchronized (self.currentlyIndexedWorkspaces) {
        IDESourceKitWorkspace *index = (IDESourceKitWorkspace *)[notification object];
        
        for (IDEWorkspace *workspace in [self allOpenedWorkspaces]) {
            if (index == [workspace index]) {
                if (![self.currentlyIndexedWorkspaces containsObject:workspace]) {
                    [self.currentlyIndexedWorkspaces addObject:workspace];
                }
            }
        }
    }
}

- (void)didIndexWorkspace:(NSNotification *)notification
{
    IDEIndex *index = (IDEIndex *)[notification object];
    IDEWorkspace *workspace = [self workspaceForIndex:index];
    
    @synchronized (self.currentlyIndexedWorkspaces) {
        if ([self.currentlyIndexedWorkspaces containsObject:workspace]) {
            [self.currentlyIndexedWorkspaces removeObject:workspace];
        }
    }
    
    [NSThread detachNewThreadSelector:@selector(updateWorkspaceSymbolCacheForWorkspace:)
                             toTarget:self
                           withObject:workspace];
}


// if someone closes workspace while it's being indexed,
// we need to remove it from currentlyIndexedWorkspaces array
- (void)removeClosedWorkspacesFromCurrentlyIndexed
{
    @synchronized (self.currentlyIndexedWorkspaces) {
        NSArray *currentWorkspaces = [self allOpenedWorkspaces];
        for (IDEWorkspace *workspace in [self.currentlyIndexedWorkspaces copy]) {
            if (![currentWorkspaces containsObject:workspace]) {
                [self.currentlyIndexedWorkspaces removeObject:workspace];
            }
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:WorkspaceDocumentsKeyPath] && [object isKindOfClass:NSClassFromString(@"IDEDocumentController")]) {
        [self removeClosedWorkspacesFromCurrentlyIndexed];
    }
    else if ([keyPath isEqualToString:@"document"] && [object isKindOfClass:NSClassFromString(@"IDEEditor")]) {
        // An IDEEditor has been activated -- update recents
        IDEEditorDocument *document = [object document];
        if (document.filePath != nil) {
            NSURL *fileURL = [[object document] fileURL];
            
            if (fileURL != nil) {
                [[[self currentWorkspaceDocument] cp_recentsStack] push:fileURL];
            }
        }
        
    }
}

- (void)reloadAfterPreferencesChange
{
}

- (void)reloadXcodeState
{
}

- (BOOL)hasOpenWorkspace
{
    NSUInteger numberOfOpenWorkspaces = [[[IDEDocumentController sharedDocumentController] workspaceDocuments] count];
    
    return (numberOfOpenWorkspaces > 0);
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - Symbol Lookup
/*==================================================================================================
 */


+ (NSArray *)symbolsForProject:(id)pbxProject
{
    return @[];
}
- (CPWorkspaceSymbolCache *)workspaceSymbolCacheForWorkspace:(IDEWorkspace *)workspace
{
    for (CPWorkspaceSymbolCache *workspaceSymbolCache in self.workspaceSymbolCaches) {
        if (workspaceSymbolCache.workspace == workspace) {
            return workspaceSymbolCache;
        }
    }
    
    return nil;
}


- (NSString *)currentSelectionSymbolString
{
    @try {
        DVTSourceExpression *selectedExpression = XVimLastActiveEditorView().hostingEditor.selectedExpression;
        if (nil != selectedExpression) {
            NSString *selectedString = [selectedExpression textSelectionString];
            if (selectedString.length < MAX_AUTOCOPY_STRING_LENGTH) {
                return selectedString;
            }
        }
    }
    @catch (NSException *exception) {
        LOG(@"EXCEPTION: %@", exception);
    }
    
    return @"";
}


/*
 *
 *
 *================================================================================================*/
#pragma mark - Queries
/*==================================================================================================
 */


- (NSString *)normalizedQueryForQuery:(NSString *)query
{
    NSString *normalizedQuery = nil;
    if (query) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\*\\ \\r\\n\\t]"
                                                                               options:0
                                                                                 error:nil];
        normalizedQuery = [regex stringByReplacingMatchesInString:query
                                                          options:0
                                                            range:NSMakeRange(0, query.length)
                                                     withTemplate:@""];
    }
    return normalizedQuery;
}

- (NSArray *)topLevelCPSymbolsMatchingQuery:(NSString *)query
{
    query = [self normalizedQueryForQuery:query];
    
    CPWorkspaceSymbolCache *workspaceSymbolCache = [self workspaceSymbolCacheForWorkspace:[self currentWorkspace]];
    
    NSMutableArray *symbols = [workspaceSymbolCache.symbols mutableCopy];
    
    [symbols filterWithFuzzyQuery:query forKey:@"name"];
    
    NSArray *result = [self arrayOfCPSymbolsByWrappingIDESymbols:symbols forCPFileReference:nil];
    
    return result;
}


- (NSArray *)cpFileReferencesMatchingQuery:(NSString *)query
{
    query = [self normalizedQueryForQuery:query];
    
    NSMutableArray *projectFiles = [[self flattenedProjectContents] mutableCopy];
    [projectFiles filterWithFuzzyQuery:query forKey:@"name"];
    
    return [self arrayOfCPFileReferencesByWrappingXcodeFileReferences:projectFiles];
}

- (NSArray *)filesAndSymbolsFromProjectForQuery:(NSString *)query
{
    query = [self normalizedQueryForQuery:query];
    
    NSArray *resultArray = [NSArray array];
    NSArray *files = [NSArray array];
    NSArray *symbols = [NSArray array];
    
    files = [self cpFileReferencesMatchingQuery:query];
    
    if ([files count] < MAX_OBJECT_COUNT_FOR_SORT_AND_FILTER) {
        symbols = [self topLevelCPSymbolsMatchingQuery:query];
    } else {
        USER_LOG(@"not adding symbols - we already have %d entries.", MAX_OBJECT_COUNT_FOR_SORT_AND_FILTER);
    }
    
    resultArray = [symbols arrayByAddingObjectsFromArray:files];
    
    // TODO/FIXME: We could add API search here
    resultArray = [self arrayByFilteringAndSortingArray:resultArray
                                         withFuzzyQuery:query
                                                    key:@"name"];
    
    return resultArray;
}

- (NSArray *)contentsForQuery:(NSString *)query fromResult:(CPResult *)result
{
    NSString *normalizedQuery = [self normalizedQueryForQuery:query];
    NSArray *resultArray = [NSArray new];
    
    if ([result isKindOfClass:[CPFileReference class]]) {
        CPFileReference *fileReference = (CPFileReference *)result;
        
        if (fileReference.isGroup) {
            PBXFileReference *pbxSymbol = [self pbxFileReferenceForCPFileReference:fileReference];
            
            resultArray = [pbxSymbol children];
            resultArray = [self arrayByFilteringAndSortingArray:resultArray withFuzzyQuery:normalizedQuery key:@"name"];
            resultArray = [self arrayOfCPFileReferencesByWrappingXcodeFileReferences:resultArray];
            
        } else {
            resultArray = [self cpSymbolsFromFile:fileReference matchingQuery:normalizedQuery];
            resultArray = [self arrayByFilteringAndSortingArray:resultArray withFuzzyQuery:normalizedQuery key:@"name"];
        }
    } else if ([result isKindOfClass:[CPSymbol class]]) {
        CPSymbol *symbol = (CPSymbol *)result;
        
        resultArray = [symbol children];
        resultArray = [self arrayByFilteringAndSortingArray:resultArray withFuzzyQuery:normalizedQuery key:@"name"];
    }
    
    return resultArray;
}


- (NSArray *)arrayByFilteringAndSortingArray:(NSArray *)unsortedArray withFuzzyQuery:(NSString *)query key:(NSString *)key
{
    if ([unsortedArray count] > MAX_OBJECT_COUNT_FOR_SORT_AND_FILTER) {
        return unsortedArray;
    }
    
    if (IsEmpty(query)) {
        return [unsortedArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 valueForKey:key] compare:[obj2 valueForKey:key]];
        }];
        
    }
    
    NSMutableArray *mutableUnsortedArray = [unsortedArray mutableCopy];
    NSArray *scores = [mutableUnsortedArray arrayFilteredAndScoredWithFuzzyQuery:query forKey:key];
    
    NSArray *result = [mutableUnsortedArray sortedArrayUsingComparator:^NSComparisonResult(CPResult *a, CPResult *b) {
        NSUInteger indexA = [mutableUnsortedArray indexOfObject:a];
        NSUInteger indexB = [mutableUnsortedArray indexOfObject:b];
        
        if (indexA >= [scores count] || indexB >= [scores count]) {
            LOG(@"Something's wrong. indexA=%lu indexB=%lu score count=%lu unsorted count=%lu", (unsigned long)indexA, (unsigned long)indexB, (unsigned long)[scores count], (unsigned long)[mutableUnsortedArray count]);
            return NSOrderedSame;
        }
        
        float scoreA = [[scores objectAtIndex:indexA] floatValue] + [a scoreOffset];
        float scoreB = [[scores objectAtIndex:indexB] floatValue] + [b scoreOffset];
        
        if (scoreA > scoreB) {
            return NSOrderedAscending;
            
        } else if (scoreA < scoreB) {
            return NSOrderedDescending;
        }
        
        return NSOrderedSame;
    }];
    
    return result;
}


- (NSArray *)cpSymbolsFromFile:(CPFileReference *)fileObject matchingQuery:(NSString *)query
{
    NSString *normalizedQuery = [self normalizedQueryForQuery:query];
    
    @try {
        NSMutableArray *ideSymbols = [[self allIDEIndexSymbolsFromCPFileReference:fileObject] mutableCopy];
        
        [ideSymbols filterWithFuzzyQuery:normalizedQuery forKey:@"name"];
        
        NSArray *cpSymbols = [self arrayOfCPSymbolsByWrappingIDESymbols:ideSymbols forCPFileReference:fileObject];
        
        return cpSymbols;
        
    } @catch (NSException * e) {
        LOG(@"EXCEPTION OCCURRED: %@", e);
    }
    
    return [NSArray new];
}


/*
 *
 *
 *================================================================================================*/
#pragma mark - Actions
/*==================================================================================================
 */


- (void)openFileOrSymbol:(id)fileOrSymbol tabController:(IDEWorkspaceTabController*)tc openMode:(CPOpenFileMode)openMode;
{
    if (nil != fileOrSymbol && [fileOrSymbol isOpenable]) {
        if ([fileOrSymbol isKindOfClass:[CPSymbol class]]) {
            [self openCPSymbol:fileOrSymbol];
            
        }
        else if ([fileOrSymbol isKindOfClass:[CPFileReference class]]) {
            IDEWorkspaceTabController *tabController = nil;
            IDEWorkspaceWindowController *windowController = nil;
            IDEEditorContext *editorContext = nil;
            NSArray *tcWc = (NSArray*)tc;
            if (tcWc) {
                windowController = tcWc[0];
                tabController = tcWc[1];
                editorContext = tcWc[2];
            }
            if ([fileOrSymbol isOpen] && tabController && windowController && editorContext) {
                // Move focus to already open file
                NSWindow *viewWindow = windowController.window;
                if (viewWindow) {
                    [windowController.window makeKeyAndOrderFront:self];
                    [tabController.windowController.window makeKeyAndOrderFront:self];
                    [editorContext performSelector:@selector(takeFocus) withObject:nil afterDelay:0.001];
                }
            }
            else {
                // Open file in new editor
                [self openCPFileReference:fileOrSymbol openMode:openMode];
            }
        }
    }
}

- (void)openCPFileReference:(CPFileReference *)cpFileReference
{
    [self openCPFileReference:cpFileReference openMode:CP_OPEN_IN_CURRENT_EDITOR];
}


- (void)openCPFileReference:(CPFileReference *)cpFileReference openMode:(CPOpenFileMode)openMode
{
    DVTDocumentLocation *documentLocation = [[DVTDocumentLocation alloc] initWithDocumentURL:[cpFileReference fileURL]
                                                                                   timestamp:nil];
    
    IDEEditorOpenSpecifier *openSpecifier = [IDEEditorOpenSpecifier structureEditorOpenSpecifierForDocumentLocation:documentLocation
                                                                                                        inWorkspace:[self currentWorkspace]
                                                                                                              error:nil];
    IDEWorkspaceWindowController * lastActiveWorkspaceWindowController = [IDEWorkspaceWindow lastActiveWorkspaceWindowController] ;
    IDEWorkspaceTabController *activeWorkspaceTabController = [lastActiveWorkspaceWindowController activeWorkspaceTabController] ;
    
    void (^openContinuation)(IDEEditorContext*) = ^(IDEEditorContext* newEditorContext) {
        // This continuation block is fired after the new window has opened,
        // to set the editor area to edit the selected file
        IDEWorkspaceTabController *tabController = [newEditorContext workspaceTabController] ;
        IDEEditorArea *editorArea = [tabController editorArea] ;
        [editorArea _openEditorOpenSpecifier:openSpecifier editorContext:newEditorContext takeFocus:YES];
        if (openMode == CP_OPEN_IN_NEW_WINDOW && !editorArea.view.window.isZoomed) {
            [editorArea.view.window zoom:self];
        }
    };
    
    switch (openMode) {
        case CP_OPEN_IN_NEW_WINDOW:
            [IDEEditorCoordinator _doOpenIn_NewWindow_withWorkspaceTabController:activeWorkspaceTabController
                                                                     documentURL:cpFileReference.fileURL
                                                                      usingBlock:openContinuation];
            break;
        case CP_OPEN_IN_NEW_TAB:
            [IDEEditorCoordinator _doOpenIn_NewTab_withWorkspaceWindowController:lastActiveWorkspaceWindowController
                                                                      usingBlock:openContinuation];
            break;
        case CP_OPEN_IN_HSPLIT:
        case CP_OPEN_IN_VSPLIT:
            [IDEEditorCoordinator _doOpenIn_AdjacentEditor_withWorkspaceTabController:lastActiveWorkspaceWindowController
                                                                        editorContext:nil
                                                                          documentURL:cpFileReference.fileURL
                                                                           usingBlock:openContinuation];
            break;
        case CP_OPEN_IN_CURRENT_EDITOR:
        default:
            [[self currentEditorContext] openEditorOpenSpecifier:openSpecifier];
            break;
    }
}

- (void)openCPSymbol:(CPSymbol *)symbol
{
    if (!symbol.hasOccurrences) {
        LOG(@"WARNING: Tried to open a symbol without occurrences: %@", symbol);
        return;
    }
    
    @try {
        IDEEditorOpenSpecifier *openSpecifier = [IDEEditorOpenSpecifier structureEditorOpenSpecifierForDocumentLocation:[symbol relatedDocumentLocation]
                                                                                                            inWorkspace:[self currentWorkspace]
                                                                                                                  error:nil];
        
        [[self currentEditorContext] openEditorOpenSpecifier:openSpecifier];
    }
    @catch (NSException * e) {
        LOG(@"EXCEPTION OCCURRED: %@", e);
    }
}


/*
 *
 *
 *================================================================================================*/
#pragma mark - Recent Files
/*==================================================================================================
 */

-(void)updateRecentFiles
{
    self.tabControllersByURL = [self _latestTabControllersByURL];
}


-(NSURL*)activeFileURL
{
    IDEWorkspaceWindowController *activeWc = [IDEWorkspaceWindow lastActiveWorkspaceWindowController];
    IDEWorkspaceTabController *activeTc = [activeWc activeWorkspaceTabController];
    IDEEditorArea *activeEa = [activeTc editorArea];
    IDEEditorContext *activeEc = [activeEa lastActiveEditorContext];
    IDEEditor *activeE = [activeEc editor];
    NSDocument *activeD = [activeE document];
    return [activeD.fileURL isFileURL] ? activeD.fileURL : nil;
}

-(NSDictionary*)_latestTabControllersByURL
{
    NSArray *windowControllers = [IDEWorkspaceWindowController workspaceWindowControllers];
    NSMutableDictionary *newurls = [NSMutableDictionary new];
    
    for (IDEWorkspaceWindowController *wc in windowControllers) {
        for (IDEWorkspaceTabController *tc in [wc workspaceTabControllers]) {
            IDEEditorArea *editorArea = tc.editorArea;
            NSArray *editorContexts = editorArea.editorModeViewController.editorContexts;
            if (editorContexts.count) {
                // TODO
                /*
                 if (editorContexts.count ==1 && [editorContexts[0] originalRequestedDocumentURL] == nil) {
                 // This is a lazily loaded tab -- we can't tell if there are other documents on this tab.
                 newurls[originalURL] = @[wc,tc,editorContexts[0]];
                 continue;
                 }
                 */
                for (IDEEditorContext *ec in editorContexts) {
                    NSURL *url = nil;
                    if ((url = ec.originalRequestedDocumentURL)) {
                        newurls[url] = @[wc,tc,ec];
                    }
                    else if ((url = ec.editor.document.fileURL)) {
                        newurls[url] = @[wc,tc,ec];
                    }
                }
            }
        }
    }
    return newurls;
}

- (NSArray *)recentlyVisitedFiles
{
    CPUniqueStack *recentFileURLs = [self.currentWorkspaceDocument cp_recentsStack];
    [recentFileURLs appendMany:[self.currentWorkspaceDocument.recentEditorDocumentURLs cp_filter:^BOOL(id elt) {
        return[(NSURL*)elt isFileURL];
    }]];
    
    // Currently active file always go at the top
    [recentFileURLs push:self.activeFileURL];
    
    return [self arrayOfCPFileReferencesByWrappingFileURLs:recentFileURLs.array];
}

- (NSArray *)recentlyVisited
{
    return [self recentlyVisitedFiles];
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - Data Adaptors
/*==================================================================================================
 */

// we wrap Xcode's IDE*Symbol into CPSymbol to provide copyWithZone: capabilities
- (NSArray *)arrayOfCPSymbolsByWrappingIDESymbols:(NSArray *)ideSymbols forCPFileReference:(CPFileReference *)fileObject
{
    NSMutableArray *cpSymbols = [NSMutableArray array];
    
    for (id ideSymbol in ideSymbols) {
        @try {
            CPSymbol *cpSymbol = [[CPSymbolCache sharedInstance] symbolForIDEIndexSymbol:ideSymbol relatedFilePath:[fileObject absolutePath]];
            [cpSymbols addObject:cpSymbol];
        }
        @catch (NSException *exception) {
            LOG(@"EXCEPTION OCCURRED: %@", exception);
        }
    }
    
    return cpSymbols;
}

// sometimes comparing absolute path is not enough if the reference
// isn't referencing the actual file, but for example a group of variantgroup (e.g. .xib file)
- (PBXFileReference *)pbxFileReferenceForCPFileReference:(CPFileReference *)cpFileReference
{
    for (PBXFileReference *pbxFileReference in [self flattenedProjectContents]) {
        if ([cpFileReference isEqualToPbxReference:pbxFileReference]) {
            return pbxFileReference;
        }
    }
    
    return nil;
}


- (NSArray *)arrayOfCPFileReferencesByWrappingXcodeFileReferences:(NSArray *)xcodeFileReferences
{
    NSMutableArray *cpFileReferences = [NSMutableArray array];
    for (id xcodeFileReference in xcodeFileReferences) {
        @try {
            CPFileReference *cpFileRef = [[CPFileReference alloc] initWithPBXFileReference:xcodeFileReference];
            if (nil != cpFileRef) {
                [cpFileReferences addObject:cpFileRef];
            }
        }
        @catch (NSException *exception) {
            LOG(@"EXCEPTION OCCURRED: %@", exception);
        }
    }
    
    return cpFileReferences;
}


// used for history document urls
- (NSArray *)arrayOfCPFileReferencesByWrappingFileURLs:(NSArray *)fileURLs
{
    NSArray *cpFileReferences = @[];
    
    for (NSURL *fileURL in fileURLs) {
        @try {
            id newCPFileReference; // declaring as CPFileReference * generates a bunch of WTF warnings
            newCPFileReference = [[CPFileReference alloc] initWithFileURL:fileURL];
            cpFileReferences = [cpFileReferences arrayByAddingObject:newCPFileReference];
        }
        @catch (NSException *exception) {
            LOG(@"EXCEPTION OCCURRED: %@", exception);
        }
    }
    
    return cpFileReferences;
}


/*
 *
 *
 *================================================================================================*/
#pragma mark - Xcode Wrappers
/*==================================================================================================
 */

- (NSArray *)recursiveChildrenOfPBXGroup:(PBXGroup *)pbxGroup
{
    NSMutableArray *objects = [NSMutableArray array];
    
    [objects addObjectsFromArray:[pbxGroup children]];
    
    for (id child in [pbxGroup children]) {
        if ([child isKindOfClass:[PBXGroup class]]) {
            NSArray *children = [self recursiveChildrenOfPBXGroup:child];
            [objects addObjectsFromArray:children];
        }
    }
    
    return objects;
}

- (NSArray *)recursiveGroupsOfPBXGroup:(PBXGroup *)pbxGroup
{
    NSMutableArray *objects = [NSMutableArray array];
    
    for (id child in [pbxGroup children]) {
        if ([child isKindOfClass:[PBXGroup class]]) {
            [objects addObject:child];
            NSArray *children = [self recursiveGroupsOfPBXGroup:child];
            [objects addObjectsFromArray:children];
        }
    }
    
    return objects;
}

- (NSArray *)recursiveChildrenOfIDEIndexSymbol:(IDESourceKitSymbol *)ideIndexSymbol
{
    NSMutableArray *objects = [NSMutableArray array];
    
    if ([ideIndexSymbol isKindOfClass:[IDEIndexContainerSymbol class]]) {
        IDEIndexContainerSymbol *containerSymbol = (IDEIndexContainerSymbol *)ideIndexSymbol;
        
        NSArray *children = [containerSymbol children];
        if ([children isKindOfClass:NSClassFromString(@"IDEIndexCollection")]) {
            children = [(IDEIndexCollection*)children allObjects];
        }
        [objects addObjectsFromArray:children];
        
        for (id child in [containerSymbol children]) {
            NSArray *children = [self recursiveChildrenOfIDEIndexSymbol:child];
            [objects addObjectsFromArray:children];
        }
    }
    
    return objects;
}

- (NSArray *)allIDEIndexSymbolsFromCPFileReference:(CPFileReference *)fileReference
{
    NSMutableArray *objects = [NSMutableArray array];

    PBXFileReference *pbxFileReference = [self pbxFileReferenceForCPFileReference:fileReference];
    
    NSMutableArray *topLevelSymbols = [[[self.currentIndex topLevelClassesWorkspaceOnly:YES] allObjects] mutableCopy];
    [topLevelSymbols addObjectsFromArray:[[self.currentIndex topLevelProtocolsWorkspaceOnly:YES] allObjects]];
    
    for (IDESourceKitSymbol *ideSymbol in topLevelSymbols) {
        DVTFilePath * symbolFile = ideSymbol.file;
        if (![symbolFile.pathString isEqualToString:pbxFileReference.absolutePath]) continue;
        
        [objects addObject:ideSymbol];
        NSArray *children = [self recursiveChildrenOfIDEIndexSymbol:ideSymbol];
        [objects addObjectsFromArray:children];
    }
    
    [objects arrayWithoutElementsHavingNilOrEmptyValueForKey:@"name"];
    
    NSArray *objectsWithRealOccurrences = [NSArray array];
    
    // only add symbols that we know really occur in the file selected
    // TODO/FIXME: add occursInFile or sth to CPSymbol
    for (IDEIndexSymbol *ideSymbol in objects) {
        NSArray *declarations = [[ideSymbol declarations] allObjects];
        NSArray *definitions = [[ideSymbol definitions] allObjects];
        
        for (IDEIndexSymbolOccurrence *occurrence in [declarations arrayByAddingObjectsFromArray:definitions]) {
            if ([[[occurrence file] pathString] isEqualToString:fileReference.absolutePath]) {
                objectsWithRealOccurrences = [objectsWithRealOccurrences arrayByAddingObject:ideSymbol];
                break;
            }
        }
    }
    
    return objectsWithRealOccurrences;
}

- (NSArray *)flattenedProjectContents
{
    NSArray *workspaceReferencedContainers = [[[self currentWorkspace] referencedContainers] allObjects];
    NSArray *contents = [NSArray array];
    
    for (IDEContainer *container in workspaceReferencedContainers) {
        if ([container isKindOfClass:[Xcode3Project class]]) {
            Xcode3Project *xc3Project = (Xcode3Project *)container;
            Xcode3Group *xc3RootGroup = [xc3Project rootGroup];
            PBXGroup *mainPBXGroup = [xc3RootGroup group];
            
            contents = [contents arrayByAddingObjectsFromArray:[self recursiveChildrenOfPBXGroup:mainPBXGroup]];
        }
    }
    
    return contents;
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - Xcode Properties
/*==================================================================================================
 */


- (NSArray *)allOpenedWorkspaces
{
    NSArray *workspaces = [NSArray array];
    
    for (IDEWorkspaceDocument *workspaceDocument in [[IDEDocumentController sharedDocumentController] workspaceDocuments]) {
        workspaces = [workspaces arrayByAddingObject:[workspaceDocument workspace]];
    }
    
    return workspaces;
}

- (IDEWorkspace *)workspaceForIndex:(IDEIndex *)index
{
    for (IDEWorkspace *workspace in [self allOpenedWorkspaces]) {
        if ([workspace index] == index) {
            return workspace;
        }
    }
    
    return nil;
}

- (IDEWorkspace *)currentWorkspace
{
    return [[self currentWorkspaceDocument] workspace];
}

- (IDEWorkspaceDocument *)currentWorkspaceDocument
{
    return [XVimLastActiveWindowController() document];
}

- (IDESourceKitWorkspace *)currentIndex
{
    __typeof(self.currentWorkspace.index) ws = self.currentWorkspace.index;
    NSAssert([ws isKindOfClass:IDESourceKitWorkspace.class], @"Workspace is unknown class");
    return ws;
}

- (IDEEditorContext *)currentEditorContext
{
    return [[[self currentWorkspaceWindowController] editorArea] lastActiveEditorContext];
}

- (IDEWorkspaceWindowController *)currentWorkspaceWindowController
{
    return XVimLastActiveWindowController();
}

- (NSString *)currentProjectName
{
    return [[self currentWorkspace] name];
}
- (NSScreen *)currentScreen
{
    return nil;
}

- (BOOL)currentProjectIsIndexing
{
    return ([self.currentlyIndexedWorkspaces containsObject:[self currentWorkspace]] || [self isSymbolCachingInProgress]);
}

- (BOOL)isSymbolCachingInProgress
{
    return self.symbolCachingInProgress;
}

-(void)_setSymbolCachingInProgress:(BOOL)inProgress {
    __weak CPXcodeWrapper * wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        CPXcodeWrapper *this = wself;
        this.symbolCachingInProgress = inProgress;
    });
}
@end
