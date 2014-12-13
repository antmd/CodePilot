//
//  CPXcodeInterfaces.h
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 3/24/10.
//  Copyright 2010 Macoscope. All rights reserved.
//
//

#import "CPCodePilotConfig.h"

@interface DVTSourceCodeSymbolKind : NSObject
+ (id)containerSymbolKind;
+ (id)globalSymbolKind;
+ (id)callableSymbolKind;
+ (id)memberSymbolKind;
+ (id)memberContainerSymbolKind;
+ (id)categorySymbolKind;
+ (id)classMethodSymbolKind;
+ (id)classSymbolKind;
+ (id)enumSymbolKind;
+ (id)enumConstantSymbolKind;
+ (id)fieldSymbolKind;
+ (id)functionSymbolKind;
+ (id)instanceMethodSymbolKind;
+ (id)instanceVariableSymbolKind;
+ (id)classVariableSymbolKind;
+ (id)macroSymbolKind;
+ (id)parameterSymbolKind;
+ (id)propertySymbolKind;
+ (id)protocolSymbolKind;
+ (id)structSymbolKind;
+ (id)typedefSymbolKind;
+ (id)unionSymbolKind;
+ (id)localVariableSymbolKind;
+ (id)globalVariableSymbolKind;
+ (id)ibActionMethodSymbolKind;
+ (id)ibOutletSymbolKind;
+ (id)ibOutletVariableSymbolKind;
+ (id)ibOutletPropertySymbolKind;
+ (id)ibOutletCollectionSymbolKind;
+ (id)ibOutletCollectionVariableSymbolKind;
+ (id)ibOutletCollectionPropertySymbolKind;
+ (id)namespaceSymbolKind;
+ (id)classTemplateSymbolKind;
+ (id)functionTemplateSymbolKind;
+ (id)instanceMethodTemplateSymbolKind;
+ (id)classMethodTemplateSymbolKind;
+ (void)initialize;
+ (id)sourceCodeSymbolKinds;
- (id)icon;
- (id)description;
- (id)conformedToSymbolKinds;
- (id)allConformingSymbolKinds;
- (char)isContainer;
- (id)identifier;
- (id)localizedDescription;
@end

@interface IDEDocumentController : NSObject
+ (id)sharedDocumentController;
- (NSArray *)workspaceDocuments;
-(NSArray*)editorDocuments;
@end

@class DVTDocumentLocation, DVTFileDataType;
@interface DVTFilePath : NSObject
- (NSURL *)fileURL;
- (NSString *)pathString;
- (NSString *)fileName;
+ (DVTFilePath *)filePathForPathString:(NSString *)path;
- (DVTFilePath *)file;
- (NSImage *)navigableItem_image;

- (DVTDocumentLocation *)navigableItem_contentDocumentLocation;
- (DVTFileDataType *)navigableItem_documentType;
- (DVTFilePath *)parentFilePath;
- (DVTFilePath *)volumeFilePath;
@end

@interface IDEIndex : NSObject
- (DVTFilePath *)databaseFile;
- (NSArray *)topLevelSymbolsInFile:(NSString *)filepath;
- (NSArray *)allSymbolsMatchingKind:(DVTSourceCodeSymbolKind *)symbolKind workspaceOnly:(BOOL)wonly;
@end


@class IDEIndexDatabase;
@interface IDEIndexDatabaseQueryProvider : NSObject
- (id)topLevelSymbolsInFile:(NSString *)filePath forIndex:(IDEIndex *)index;
- (id)filesContaining:(NSString *)a anchorStart:(NSString *)b anchorEnd:(NSString *)c subsequence:(NSString *)d ignoreCase:(BOOL)ignoreCase forIndex:(IDEIndex *)wwefwew;
- (IDEIndexDatabase *)database;
@end

@interface IDEIndexDBConnection : NSObject
- (void)close;
- (void)finalize;
- (id)dbConnection;
@end

@interface IDEIndexDatabase : NSObject
- (IDEIndexDatabase *)initWithFileURL:(NSURL *)fileURL;
- (IDEIndexDatabaseQueryProvider *)queryProvider;
- (void)open;
- (void)openReadonly;
- (void)openInDiagnosticMode;
- (void)close;
- (id)mainFilesForTarget:(NSString *)targetNameOrWTF;
- (IDEIndexDBConnection *)newConnection;
- (NSURL *)fileURL;
@end

@interface DVTModelObject : NSObject
@end

@interface IDEContainerItem : DVTModelObject
@end

@interface IDEGroup : IDEContainerItem
- (NSArray *)subitems;
- (NSImage *)navigableItem_image;
@end

@interface IDEContainer : DVTModelObject
- (DVTFilePath *)filePath;
- (IDEGroup *)rootGroup;
- (void)debugPrintInnerStructure;
- (void)debugPrintStructure;
@end

@interface IDEXMLPackageContainer : IDEContainer
@end

@interface IDEWorkspace : IDEXMLPackageContainer
- (IDEIndex *)index;
- (NSString *)name;
- (NSSet *)referencedContainers;
@end

@interface IDEWorkspaceDocument : NSObject
- (IDEWorkspace *)workspace;
- (NSArray *)recentEditorDocumentURLs;
- (id)sdefSupport_fileReferences;
@end

@interface IDEWorkspaceWindow : NSWindow
+ (id)lastActiveWorkspaceWindowController;
- (IDEWorkspaceDocument *)document;
@end

@interface IDEWorkspaceWindow (MissingMethods)
+ (IDEWorkspaceWindow *)mc_lastActiveWorkspaceWindow;
@end

@interface IDEFileReference : NSObject
- (IDEContainer *)referencedContainer;
@end

@interface PBXObject : NSObject
@end

@interface PBXContainer : PBXObject
- (NSString *)name;
@end

@interface PBXContainerItem : PBXObject
@end

@class PBXGroup;
@interface PBXReference : PBXContainerItem
- (BOOL)isGroup;
- (NSString *)name;
- (NSString *)absolutePath;
- (PBXGroup *)group;
- (PBXContainer *)container;
@end

@interface PBXGroup : PBXReference
- (NSArray *)children;
@end

@interface Xcode3Group : IDEGroup
- (PBXGroup *)group;
@end

@interface Xcode3Project : IDEContainer
- (Xcode3Group *)rootGroup;
@end

@interface DVTApplication : NSApplication
@end

@interface IDEApplication : DVTApplication
+ (IDEApplication *)sharedApplication;
@end

@interface IDEApplicationController : NSObject
+ (IDEApplicationController *)sharedAppController;
- (BOOL)application:(IDEApplication *)application openFile:(NSString *)filePath;
@end

@interface XCSpecification : NSObject
@end

@interface PBXFileType : XCSpecification
- (BOOL)isBundle;
- (BOOL)isApplication;
- (BOOL)isLibrary;
- (BOOL)isFramework;
- (BOOL)isProjectWrapper;
- (BOOL)isTargetWrapper;
- (BOOL)isExecutable;
@end

@interface PBXFileReference : PBXReference
- (NSString *)resolvedAbsolutePath;
- (id)fileType;
- (NSArray *)children;
@end

@interface IDEIndexSymbolOccurrence : NSObject
- (id)file;
- (id)location;
- (long long)lineNumber;
@end

@interface IDEIndexCollection : NSObject
- (NSArray *)allObjects;
@end

@interface IDEIndexSymbolOccurrenceCollection : IDEIndexCollection <NSFastEnumeration>
@end

@interface IDEIndexSymbol : NSObject
- (NSString *)name;
- (DVTSourceCodeSymbolKind *)symbolKind;
- (NSString *)displayText;
- (NSString *)completionText;
- (NSString *)displayType;
- (NSString *)descriptionText;
- (NSImage *)icon;

- (IDEIndexSymbolOccurrence *)modelOccurrence;
- (IDEIndexSymbolOccurrenceCollection *)occurrences;
- (IDEIndexSymbolOccurrenceCollection *)declarations;
- (IDEIndexSymbolOccurrenceCollection *)definitions;

- (NSArray *)containerSymbols;
- (id)containerSymbol;

- (unsigned long long)hash;
@end

@interface IDEIndexContainerSymbol : IDEIndexSymbol
- (NSArray *)children;
@end

@interface IDEIndexClassSymbol : IDEIndexContainerSymbol
- (NSArray *)categories;
@end

@interface IDEIndexProtocolSymbol : IDEIndexContainerSymbol
@end

@interface IDEIndexCategorySymbol : IDEIndexContainerSymbol
- (NSArray *)classMethods;
- (NSArray *)instanceMethods;
- (NSArray *)properties;
@end

@interface IDENavigableItem : NSObject
+ (IDENavigableItem *)navigableItemWithRepresentedObject:(id)object;
@end

@interface IDEFileNavigableItem : IDENavigableItem
+ (IDEFileNavigableItem *)navigableItemWithRepresentedObject:(id)object;
@end

@interface IDEFileReferenceNavigableItem : IDEFileNavigableItem
+ (IDEFileReferenceNavigableItem *)navigableItemWithRepresentedObject:(id)object;
@end

@interface DVTDocumentLocation : NSObject
- (DVTDocumentLocation *)initWithDocumentURL:(NSURL *)documentURL timestamp:(NSNumber *)timestamp;
- (NSURL *)documentURL;
@end

@interface DVTTextDocumentLocation : DVTDocumentLocation
- (DVTTextDocumentLocation *)initWithDocumentURL:(NSURL *)documentURL timestamp:(NSNumber *)timestamp lineRange:(NSRange)lineRange;
- (NSRange)characterRange;
- (NSURL *)documentURL;
@end

@interface DVTViewController : NSViewController
@end
@class IDEWorkspaceTabController;
@interface IDEViewController : DVTViewController
@property(retain, nonatomic) IDEWorkspaceTabController *workspaceTabController;
@end


@interface IDEEditorOpenSpecifier : NSObject
- (IDEEditorOpenSpecifier *)initWithNavigableItem:(IDENavigableItem *)navigableItem error:(NSError * __autoreleasing *)error;
- (IDEEditorOpenSpecifier *)initWithNavigableItem:(IDENavigableItem *)navigableItem locationToSelect:(DVTDocumentLocation*)location error:(NSError * __autoreleasing *)error;

+ (IDEEditorOpenSpecifier *)structureEditorOpenSpecifierForDocumentLocation:(DVTDocumentLocation *)documentLocation inWorkspace:(IDEWorkspace *)workspace error:(NSError *)error;
@end

@interface IDEEditorHistoryItem : NSObject
- (NSString *)historyMenuItemTitle;
- (NSURL *)documentURL;
@end

@interface DVTSourceExpression : NSObject
- (NSString *)textSelectionString;
@end

@interface IDEEditorHistoryStack : NSObject
- (NSArray *)previousHistoryItems;
- (NSArray *)nextHistoryItems;
- (IDEEditorHistoryItem *)currentEditorHistoryItem;
@end

@class IDEEditorArea;
@class IDEWorkspaceWindowController;
@interface IDEWorkspaceTabController : IDEViewController <NSTextViewDelegate /*,DVTTabbedWindowTabContentControlling, DVTStatefulObject, DVTReplacementViewDelegate, IDEEditorAreaContainer, IDEStructureEditingWorkspaceTabContext, IDEWorkspaceDocumentProvider, DVTEditor*/>
-(IDEEditorArea*)editorArea;
- (void)changeToAssistantLayout_BH:(id)arg1;
- (void)changeToAssistantLayout_BV:(id)arg1;
- (void)changeToAssistantLayout_LH:(id)arg1;
- (void)changeToAssistantLayout_LV:(id)arg1;
- (void)changeToAssistantLayout_RH:(id)arg1;
- (void)changeToAssistantLayout_RV:(id)arg1;
- (void)changeToAssistantLayout_TH:(id)arg1;
- (void)changeToAssistantLayout_TV:(id)arg1;
- (void)changeToStandardEditor:(id)arg1;
- (void)changeToGeniusEditor:(id)arg1;
- (void)addAssistantEditor:(id)arg1;
- (void)removeAssistantEditor:(id)arg1;

@property(copy) NSString *userDefinedTabLabel;
@property(readonly) IDEWorkspaceWindowController *windowController;
@property(retain) NSDocument *document;
@property(readonly) DVTFilePath *tabFilePath;
@property(readonly) NSString *tabLabel;

@end

@class IDEEditor;

@interface IDEEditorContext : IDEViewController
- (BOOL)openEditorOpenSpecifier:(IDEEditorOpenSpecifier *)openSpecifier;
- (IDEEditorHistoryStack *)currentHistoryStack;
- (IDEEditor *)editor;
- (IDEWorkspaceTabController*)workspaceTabController;
-(NSURL*)originalRequestedDocumentURL;
- (void)takeFocus;
- (NSArray*)_currentSelectedDocumentLocations;
@property(readonly, getter=isPrimaryEditorContext) BOOL primaryEditorContext;
@property(retain, nonatomic) IDENavigableItem *navigableItem;
@end

@class IDEEditorOpenSpecifier;
@interface IDEEditorModeViewController : NSViewController
-(NSArray*)editorContexts;
@property(retain, nonatomic) IDEEditorContext *primaryEditorContext;
@end

@interface IDEEditorMultipleContext : IDEViewController <NSSplitViewDelegate>
- (BOOL)canCloseEditorContexts;
- (BOOL)canCreateAdditionalEditorContexts;
- (void)closeAllEditorContextsKeeping:(id)arg1;
- (void)closeEditorContext:(id)arg1;
- (IDEEditorContext*)firstEditorContext;
- (IDEEditorContext*)secondEditorContext;

@property(retain) IDEEditorContext *selectedEditorContext;
@end

@interface IDEEditorGeniusMode : IDEEditorModeViewController </*IDEEditorContextDelegate, IDEEditorMultipleContextDelegate,*/ NSSplitViewDelegate>
@property(retain) IDEEditorMultipleContext *alternateEditorMultipleContext;
- (BOOL)canRemoveAssistantEditor;
- (void)removeAssistantEditor;
@end

@interface IDEEditorArea : IDEViewController
- (IDEEditorContext *)primaryEditorContext;
- (IDEEditorContext *)lastActiveEditorContext;
@property(nonatomic) int editorMode;
@property(retain) IDEEditorModeViewController *editorModeViewController;
@property(retain, nonatomic) IDEWorkspaceTabController *workspaceTabController;
- (void)_openEditorOpenSpecifier:(IDEEditorOpenSpecifier*)arg1 editorContext:(IDEEditorContext*)arg2 takeFocus:(BOOL)arg3;
@end


@interface IDEWorkspaceWindowController : NSWindowController
+ (NSArray *)workspaceWindowControllers;
+ (IDEWorkspaceWindowController *)workspaceWindowControllerForWindow:(IDEWorkspaceWindow *)window;
- (IDEEditorArea *)editorArea;
- (void)activateWorkspaceTabController:(id)arg1;
@property(readonly) IDEWorkspaceTabController *activeWorkspaceTabController;
- (NSArray*)workspaceTabControllers;

@end

@interface IDEKeyBinding : NSObject
- (NSString *)title;
- (NSString *)group;
- (NSArray *)actions;
- (NSArray *)keyboardShortcuts;
+ (IDEKeyBinding *)keyBindingWithTitle:(NSString *)title group:(NSString *)group actions:(NSArray *)actions keyboardShortcuts:(NSArray *)keyboardShortcuts;
+ (IDEKeyBinding *)keyBindingWithTitle:(NSString *)title parentTitle:(NSString *)parentTitle group:(NSString *)group actions:(NSArray *)actions keyboardShortcuts:(NSArray *)keyboardShortcuts;
@end

@interface IDEMenuKeyBinding : IDEKeyBinding
- (NSString *)commandIdentifier;
+ (IDEMenuKeyBinding *)keyBindingWithTitle:(NSString *)title group:(NSString *)group actions:(NSArray *)actions keyboardShortcuts:(NSArray *)keyboardShortcuts;
+ (IDEMenuKeyBinding *)keyBindingWithTitle:(NSString *)title parentTitle:(NSString *)parentTitle group:(NSString *)group actions:(NSArray *)actions keyboardShortcuts:(NSArray *)keyboardShortcuts;
- (void)setCommandIdentifier:(NSString *)commandIdentifier;
@end

@class IDEKeyBindingPreferenceSetManager;
@class IDEMenuKeyBindingSet;
@interface IDEKeyBindingPreferenceSet : NSObject
+ (IDEKeyBindingPreferenceSetManager *)preferenceSetsManager;
- (IDEMenuKeyBindingSet *)menuKeyBindingSet;
@end

@interface IDEKeyBindingPreferenceSetManager : NSObject
- (IDEKeyBindingPreferenceSet *)currentPreferenceSet;
@end

@interface IDEKeyBindingSet : NSObject
- (void)addKeyBinding:(IDEKeyBinding *)keyBinding;
- (void)insertObject:(IDEKeyBinding *)keyBinding inKeyBindingsAtIndex:(NSUInteger)index;
- (void)updateDictionary;
@end

@interface IDEKeyboardShortcut : NSObject
+ (id)keyboardShortcutFromStringRepresentation:(NSString *)stringRep;
- (NSString *)stringRepresentation;
- (NSString *)keyEquivalent;
- (IDEKeyboardShortcut *)keyboardShortcutFromStringRepresentation:(NSString *)stringRep;
- (unsigned long long)modifierMask;
@end

@interface IDEMenuKeyBindingSet : IDEKeyBindingSet
- (NSArray *)keyBindings;
@end

@interface DVTAutoLayoutView : NSView
@end

@interface DVTReplacementView : DVTAutoLayoutView
@end

@interface IDEPreferencesController : NSWindowController <NSToolbarDelegate>
- (void)setPaneReplacementView:(DVTReplacementView *)replacementView;
- (DVTReplacementView *)paneReplacementView;
@end

@interface DVTExtension : NSObject
@end

@interface IDEEditorDocument : NSDocument
- (NSSet*)_documentEditors;
@end

@interface IDEEditor : IDEViewController
@property(retain) IDEEditorDocument *document;
- (NSArray *)currentSelectedDocumentLocations;
- (DVTSourceExpression *)selectedExpression;
@end

@interface DVTSourceLandmarkItem : NSObject
- (NSString *)name;
@end

@interface IDEDocSymbolUtilities : NSObject
- (NSDictionary *)queryInfoFromIndexSymbol:(IDEIndexSymbol *)symbol;
- (id)typeForSymbol:(IDEIndexSymbol *)symbol;
- (void)queryInfoFromIndexSymbol:(IDEIndexSymbol *)symbol handlerBlock:(void(^)(id foo))block;
@end

@interface IDEQuickHelpQueries : NSObject
@end

extern NSString *IDEEditorDocumentDidChangeNotification;

@interface IDESourceCodeEditor :NSObject
-(NSWindow*)viewWindow;
-(void)takeFocus;
@end



@interface IDESourceCodeDocument : IDEEditorDocument
- (id)knownFileReferences;
-(NSURL*)fileURL;
@end

@interface Xcode3FileReference <NSObject>
- (id)resolvedFilePath;
@end

@interface IDEEditorCoordinator : NSObject
+ (void)_doOpenIn_AdjacentEditor_withWorkspaceTabController:(id)arg1 editorContext:(id)arg2 documentURL:(id)arg3 usingBlock:(id)arg4;
+ (void)_doOpenIn_Ask_withWorkspaceTabController:(id)arg1 editorContext:(id)arg2 documentURL:(id)arg3 initialSelection:(id)arg4 options:(id)arg5 usingBlock:(id)arg6;
+ (void)_doOpenIn_NewEditor_withWorkspaceTabController:(id)arg1 usingBlock:(id)arg2;
+ (void)_doOpenIn_NewTab_withWorkspaceWindowController:(id)arg1 usingBlock:(id)arg2;
+ (void)_doOpenIn_NewWindow_withWorkspaceTabController:(id)arg1 documentURL:(id)arg2 usingBlock:(id)arg3;
+ (void)_doOpenIn_SeparateEditor_withWorkspaceTabController:(id)arg1 documentURL:(id)arg2 usingBlock:(id)arg3;
+ (void)_doOpenIn_SeparateTab_withWorkspaceTabController:(id)arg1 documentURL:(id)arg2 usingBlock:(id)arg3;
+ (void)_doOpenIn_SeparateWindow_withWorkspaceTabController:(id)arg1 documentURL:(id)arg2 usingBlock:(id)arg3;
@end

