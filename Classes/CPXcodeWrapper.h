//
//  CPXcodeWrapper.h
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 2/9/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CPCodePilotConfig.h"

@class CPFileReference, CPSymbol, CPWorkspaceSymbolCache, CPResult, IDESourceKitWorkspace, IDESourceKitSymbol;

@interface CPXcodeWrapper : NSObject
@property (nonatomic, strong) NSMutableArray *currentlyIndexedWorkspaces;
@property (nonatomic, strong) NSMutableArray *workspaceSymbolCaches;
@property (nonatomic, assign) BOOL symbolCachingInProgress;
@property (readonly,nonatomic) NSURL *activeFileURL; // Focused document URL

- (void)reloadAfterPreferencesChange;
- (void)reloadXcodeState;
- (BOOL)hasOpenWorkspace;
- (NSScreen *)currentScreen;
- (BOOL)currentProjectIsIndexing;
- (void)openFileOrSymbol:(id)fileOrSymbol tabController:(IDEWorkspaceTabController*)tabController openMode:(CPOpenFileMode)openMode;
- (void)openCPSymbol:(CPSymbol *)symbol;
- (void)openCPFileReference:(CPFileReference *)cpFileReference;
- (void)openCPFileReference:(CPFileReference *)cpFileReference openMode:(CPOpenFileMode)openMode;
- (NSString *)currentProjectName;
- (NSString *)normalizedQueryForQuery:(NSString *)query;
- (NSArray *)contentsForQuery:(NSString *)query fromResult:(CPResult *)result;
- (NSArray *)filesAndSymbolsFromProjectForQuery:(NSString *)query;
- (NSArray *)recentlyVisited;
- (NSString *)currentSelectionSymbolString;
+ (NSArray *)symbolsForProject:(id)pbxProject;
- (NSArray *)cpFileReferencesMatchingQuery:(NSString *)query;
- (NSArray *)topLevelCPSymbolsMatchingQuery:(NSString *)query;
- (NSArray *)arrayOfCPFileReferencesByWrappingXcodeFileReferences:(NSArray *)xcodeFileReferences;
- (id)pbxFileReferenceForCPFileReference:(CPFileReference *)cpFileReference;
- (NSArray *)cpSymbolsFromFile:(CPFileReference *)fileObject matchingQuery:(NSString *)query;
- (NSArray *)arrayOfCPSymbolsByWrappingIDESymbols:(NSArray *)ideSymbols forCPFileReference:(CPFileReference *)fileObject;

- (NSArray *)recursiveChildrenOfPBXGroup:(PBXGroup *)pbxGroup;
- (NSArray *)flattenedProjectContents;
- (IDEWorkspace *)currentWorkspace;
- (IDESourceKitWorkspace *)currentIndex;
- (NSArray *)recursiveChildrenOfIDEIndexSymbol:(IDESourceKitSymbol *)ideIndexSymbol;
- (NSArray *)allIDEIndexSymbolsFromCPFileReference:(CPFileReference *)fileReference;
- (IDEEditorContext *)currentEditorContext;
- (IDEWorkspaceDocument *)currentWorkspaceDocument;
- (NSArray *)arrayOfCPFileReferencesByWrappingFileURLs:(NSArray *)fileURLs;
- (IDEWorkspaceWindowController *)currentWorkspaceWindowController;

- (void)willIndexWorkspace:(NSNotification *)notification;
- (void)didIndexWorkspace:(NSNotification *)notification;
- (void)removeClosedWorkspacesFromCurrentlyIndexed;
- (NSArray *)allOpenedWorkspaces;
- (IDEWorkspace *)workspaceForIndex:(IDEIndex *)index;

- (void)updateWorkspaceSymbolCacheForWorkspace:(IDEWorkspace *)workspace;
- (CPWorkspaceSymbolCache *)workspaceSymbolCacheForWorkspace:(IDEWorkspace *)workspace;

- (void)updateWorkspaceSymbolCacheForWorkspace:(IDEWorkspace *)workspace withWorkspaceSymbolCache:(CPWorkspaceSymbolCache *)workspaceSymbolCache;
- (BOOL)isSymbolCachingInProgress;

- (NSArray *)recentlyVisitedFiles;
-(void)updateRecentFiles;
/// Return a map: fileURL --> [ IDEWorkspaceWindowController, IDEWorkspaceTabController, IDEEditorContext ]
/// This can be used to a) select a window, b) select a tab, c) select an edtior area for a given fileURL
/// Note, at Xcode startup, not all IDEWorkspaceTabControllers will be fully loaded, so if those tabs contain
/// multiple editor areas, they will not be found by this routine.
/// The results of this method are used to mark 'already open' files in the Code Pilot file list
@property (readonly,nonatomic) NSDictionary *tabControllersByURL;

@end
