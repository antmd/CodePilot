//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

#import <IDEKit/IDEViewController.h>

typedef void (^CDUnknownBlockType) (void);
#if 0
#import <IDEKit/DVTFindBarHostable-Protocol.h>
#import <IDEKit/DVTScopeBarHost-Protocol.h>
#import <IDEKit/DVTStateRepositoryDelegate-Protocol.h>
#import <IDEKit/IDEEditorContextProtocol-Protocol.h>
#import <IDEKit/IDEEditorDelegate-Protocol.h>
#import <IDEKit/IDEEditorSplittingControllerDelegate-Protocol.h>
#import <IDEKit/IDENavigableItemCoordinatorDelegate-Protocol.h>
#import <IDEKit/IDEPathCellDelegate-Protocol.h>
#import <IDEKit/NSAnimationDelegate-Protocol.h>
#import <IDEKit/NSMenuDelegate-Protocol.h>
#import <IDEKit/NSPathControlDelegate-Protocol.h>
#endif

@class CALayer, DVTBindingToken, DVTBorderedView, DVTFileDataType, DVTFindBar, DVTGradientImagePopUpButton,
            DVTNotificationToken, DVTObservingToken, DVTScopeBarsManager, DVTStackBacktrace, DVTStateRepository,
            IDEEditor, IDEEditorArea, IDEEditorGeniusResults, IDEEditorHistoryController, IDEEditorHistoryItem,
            IDEEditorIssueMenuController, IDEEditorMultipleContext, IDEEditorNavigableItemCoalescingState,
            IDEEditorReadOnlyIndicatorController, IDEEditorSplittingController, IDEEditorStepperView, IDENavBar,
            IDENavigableItem, IDENavigableItemCoordinator, NSArray, NSArrayController, NSDictionary, NSIndexSet,
            NSMutableArray, NSScrollView, NSString, NSURL, NSView, _IDEGeniusResultsContext;
@protocol DVTCancellable
, IDEEditorContextDelegate;

@interface IDEEditorContext : IDEViewController // <NSMenuDelegate, IDEEditorContextProtocol,
                                                // IDEEditorSplittingControllerDelegate, DVTFindBarHostable,
                                                // NSPathControlDelegate, IDEPathCellDelegate, DVTScopeBarHost,
                                                // IDENavigableItemCoordinatorDelegate, IDEEditorDelegate,
                                                // DVTStateRepositoryDelegate, NSAnimationDelegate>
{
    NSView* _editorAndNavBarView; // 104 = 0x68
    IDENavBar* _navBar; // 112 = 0x70
    DVTBorderedView* _editorBorderedView; // 120 = 0x78
    DVTGradientImagePopUpButton* _relatedItemsPopUpButton; // 128 = 0x80
    IDEEditorStepperView* _stepperView; // 136 = 0x88
    DVTStateRepository* _stateRepository; // 144 = 0x90
    IDENavigableItem* _greatestDocumentAncestor; // 152 = 0x98
    NSURL* _greatestDocumentAncestor_DocumentURL; // 160 = 0xa0
    DVTFileDataType* _cacheFromNavigation_greatestDocumentAncestorFileDataType; // 168 = 0xa8
    NSArray* _documentSelectedItems; // 176 = 0xb0
    DVTNotificationToken* _editorContextWillOpenNavigableItemNotificationToken; // 184 = 0xb8
    DVTNotificationToken* _editorDocumentForNavBarStructureDidChangeNotificationToken; // 192 = 0xc0
    DVTNotificationToken* _editorDocumentForNavBarStructureWillCloseNotificationToken; // 200 = 0xc8
    DVTNotificationToken* _editorDocumentIsEditedStatusDidChangeNotificationToken; // 208 = 0xd0
    DVTNotificationToken* _editorDocumentWillCloseNotificationToken; // 216 = 0xd8
    DVTNotificationToken* _findStringChangedNotificationToken; // 224 = 0xe0
    DVTNotificationToken* _navigableItemPropertyObserver; // 232 = 0xe8
    DVTNotificationToken* _navigableItemCoordinatorWillForgetItemsNotificationToken; // 240 = 0xf0
    DVTNotificationToken* _navigableItemCoordinatorDidForgetItemsNotificationToken; // 248 = 0xf8
    DVTNotificationToken* _workspaceWillWriteNotificationToken; // 256 = 0x100
    DVTObservingToken* _editorDocumentForNavBarStructureChangedObservingToken; // 264 = 0x108
    DVTObservingToken* _windowMainViewControllerChangedObservingToken; // 272 = 0x110
    DVTNotificationToken* _windowDidBecomeKeyObserverToken; // 280 = 0x118
    DVTObservingToken* _lastActiveEditorContextChangedObservingToken; // 288 = 0x120
    DVTObservingToken* _currentSelectedItemsObservingToken; // 296 = 0x128
    id<DVTCancellable> _deferredUpdateSubDocumentNavigableItemsCancellableToken; // 304 = 0x130
    DVTBindingToken* _navBarNavigableItemRootChildItemsBindingToken; // 312 = 0x138
    DVTBindingToken* _navBarNavigableItemBindingToken; // 320 = 0x140
    IDEEditorNavigableItemCoalescingState* _coalescingState; // 328 = 0x148
    IDENavigableItem* _geniusResultsRootNavigableItem; // 336 = 0x150
    DVTObservingToken* _counterpartsObservingToken; // 344 = 0x158
    IDEEditorHistoryController* _historyController; // 352 = 0x160
    NSArrayController* _navigableItemSiblingsController; // 360 = 0x168
    IDEEditorReadOnlyIndicatorController* _readOnlyIndicatorController; // 368 = 0x170
    DVTObservingToken* _showReadOnlyIndicatorObserver; // 376 = 0x178
    DVTFindBar* _findBar; // 384 = 0x180
    NSDictionary* _editorStateDictionaryPreviousToFind; // 392 = 0x188
    IDEEditorIssueMenuController* _issueMenuController; // 400 = 0x190
    DVTObservingToken* _showIssueMenuControllerObserver; // 408 = 0x198
    IDEEditorSplittingController* _splittingController; // 416 = 0x1a0
    DVTObservingToken* _workspaceLoadingObservingToken; // 424 = 0x1a8
    IDEEditorHistoryItem* _beforeUninstallHistoryItem; // 432 = 0x1b0
    NSString* _emptyContentString; // 440 = 0x1b8
    NSMutableArray* _commandExtensions; // 448 = 0x1c0
    DVTStackBacktrace* _beganChangingNavigableItemBacktrace; // 456 = 0x1c8
    BOOL _changingNavBarNavigableItem; // 464 = 0x1d0
    BOOL _viewIsInstalled; // 465 = 0x1d1
    BOOL _shouldObserveDocumentChanges; // 466 = 0x1d2
    BOOL _editorProvidesPathCellMenuItems; // 467 = 0x1d3
    BOOL _isPerformingStateRestoration; // 468 = 0x1d4
    BOOL _isReplacingClosedDocument; // 469 = 0x1d5
    BOOL _isDraggingPathCell; // 470 = 0x1d6
    BOOL _isFetchingCurrentSelectedItems; // 471 = 0x1d7
    BOOL _shouldImmediatleyProcessCurrentSelectedItemsChange; // 472 = 0x1d8
    unsigned long long _currentSwipeAnimationGeneration; // 480 = 0x1e0
    CDUnknownBlockType _swipeAnimationAbortBlock; // 488 = 0x1e8
    BOOL _disableGeniusResultUpdatesDuringSwipeAnimation; // 496 = 0x1f0
    NSView* _swipeLayerView; // 504 = 0x1f8
    CALayer* _swipeBackgroundLayer; // 512 = 0x200
    CALayer* _swipeForegroundLayer; // 520 = 0x208
    CDUnknownBlockType _swipeCompletionBlock; // 528 = 0x210
    NSDictionary* _editorStateDictionaryPreviousToSwipe; // 536 = 0x218
    BOOL _showNavBar; // 544 = 0x220
    BOOL _showRelatedItemsControl; // 545 = 0x221
    BOOL _showNavBarHistoryStepperControls; // 546 = 0x222
    BOOL _showSiblingStepperControl; // 547 = 0x223
    BOOL _showMiniIssueNavigator; // 548 = 0x224
    BOOL _showSplittingControls; // 549 = 0x225
    BOOL _canAddSplit; // 550 = 0x226
    BOOL _canRemoveSplit; // 551 = 0x227
    BOOL _hideWorkspaceLoadingProgressIndicator; // 552 = 0x228
    BOOL _isCallingNewEditorDocumentWithClass; // 553 = 0x229
    int _borderSides; // 556 = 0x22c
    IDEEditorArea* _editorArea; // 560 = 0x230
    id<IDEEditorContextDelegate> _delegate; // 568 = 0x238
    IDENavigableItemCoordinator* _navigableItemCoordinator; // 576 = 0x240
    IDENavigableItem* _navigableItem; // 584 = 0x248
    NSArray* _defaultEditorCategories; // 592 = 0x250
    NSArray* _validEditorCategories; // 600 = 0x258
    DVTScopeBarsManager* _scopeBarsManager; // 608 = 0x260
    IDENavigableItem* _navBarNavigableItem; // 616 = 0x268
    IDENavigableItem* _navBarNavigableItemRoot; // 624 = 0x270
    NSArray* _navigableItemSiblings; // 632 = 0x278
    NSIndexSet* _navigableItemSiblingsSelectionIndexes; // 640 = 0x280
    IDEEditor* _editor; // 648 = 0x288
    CDUnknownBlockType _retryOpenOperationBlock; // 656 = 0x290
    IDEEditorGeniusResults* _editorGeniusResults; // 664 = 0x298
    NSString* _documentExtensionIdentifier; // 672 = 0x2a0
    IDEEditorMultipleContext* _multipleContext; // 680 = 0x2a8
    _IDEGeniusResultsContext* _geniusResultsContext; // 688 = 0x2b0
    NSURL* _originalRequestedDocumentURL; // 696 = 0x2b8
}

+ (BOOL)_canEditDocumentURL:(id)arg1
                           fileDataType:(id)arg2
            documentExtensionIdentifier:(id)arg3
                   withEditorCategories:(id)arg4;
+ (BOOL)_canEditEditorHistoryItem:(id)arg1 withEditorCategories:(id)arg2;
+ (id)_createSpacerViewWithWidth:(double)arg1;
+ (id)_defaultDocumentExtensionForDocumentURL:(id)arg1 fileDataType:(id)arg2 withEditorCategories:(id)arg3;
+ (id)_titleForNavigationUserInterfaceItem:(id)arg1
                                forEventBehavior:(int)arg2
                        fromPrimaryEditorContext:(BOOL)arg3
                              isWindowFullscreen:(BOOL)arg4;
+ (BOOL)automaticallyNotifiesObserversOfGreatestDocumentAncestor;
+ (BOOL)automaticallyNotifiesObserversOfNavBarNavigableItem;
+ (BOOL)automaticallyNotifiesObserversOfNavigableItem;
+ (void)initialize;
+ (id)keyPathsForValuesAffectingIsLastActiveEditorContext;
+ (id)keyPathsForValuesAffectingNavBarNavigableItemRootChildItems;
+ (id)keyPathsForValuesAffectingOutputSelection;
+ (id)navigationLogAspect;
//- (void).cxx_destruct;
- (void)_adjustSubviewBorders;
- (void)_applyEditorStateDictionary:(id)arg1
            forDocumentExtensionIdentifier:(id)arg2
              atDocumentURLToCurrentEditor:(id)arg3;
- (BOOL)_canAskDocumentToClose;
- (BOOL)_canChangeNavigableItem;
- (BOOL)_canEditEditorHistoryItem:(id)arg1;
- (BOOL)_canEditEditorOpenSpecifier:(id)arg1;
- (BOOL)_canEditEditorOpenSpecifier:(id)arg1 withEditorCategories:(id)arg2;
- (void)_changeMaximumRecentFilesLimit:(id)arg1;
- (void)_checkShouldCoalesceUpdatesForCurrentSelectedItemsChanged;
- (void)_clearRecentEditorDocumentsList:(id)arg1;
- (void)_clearWorkspaceloadingObservation;
- (id)_currentSelectedDocumentLocations;
- (void)_currentSelectedItemsChanged;
- (id)_defaultDocumentExtensionForNavigableItem:(id)arg1;
- (id)_defaultEditorStateDictionaryForDocumentExtensionIdentifier:(id)arg1 forDocumentURL:(id)arg2;
- (void)_didForgetNavigableItemsNotification:(id)arg1;
- (BOOL)_editorGeniusResultsGenerationEnabled;
- (BOOL)_editorHasFocus;
- (BOOL)_enableJumpToCounterpartMenuItems;
- (id)_findBar;
- (BOOL)_findBarHasFocus;
- (id)_findScopeBar;
- (id)_generateNodeAndAddMappingToWorkspaceTabControllerLayoutTree:(id)arg1;
- (void)_giveEditorFocusIfNeeded;
- (void)_greatestDocumentAncestorWillBeForgotten;
- (id)_hiddenMenuItemForCommandExtension:(id)arg1;
- (void)_hideFindBarAndRestoreSelection:(BOOL)arg1 animate:(BOOL)arg2;
- (void)_hideSwipeOverlay;
- (id)_imageOfCurrentEditor;
- (void)_importNavigableItem:(id)arg1;
- (void)_installFindBar;
- (BOOL)_isCurrentEventARepeatKeyDownEvent;
- (void)_jumpToCounterpartUp:(BOOL)arg1;
- (id)_jumpToCounterpartsCategoryNavigableItem;
- (void)_mainViewControllerChanged;
- (void)_moveOverlayToMatchGestureAmount:(double)arg1 imageOfCurrentEditorOnTop:(BOOL)arg2;
- (void)_navigableItemChanged;
- (id)_navigableItemForEditingFromArchivedRepresentation:(id)arg1 error:(id*)arg2;
- (void)_navigateAwayFromCurrentDocumentWithURL:(id)arg1;
- (void)_navigateAwayFromDocument:(id)arg1 historyItem:(id)arg2;
- (void)_navigateToRelatedNavigableItem:(id)arg1;
- (id)_newEditorDocumentWithClass:(Class)arg1
                                 forURL:(id)arg2
                      withContentsOfURL:(id)arg3
                                 ofType:(id)arg4
                              extension:(id)arg5
                                  error:(id*)arg6;
- (BOOL)_notifyDelegateAndOpenEditorHistoryItem:(id)arg1
                                   previousHistoryItemOrNil:(id)arg2
                         alwaysReplaceExistingNavigableItem:(BOOL)arg3
            skipSubDocumentNavigationUnlessEditorIsReplaced:(BOOL)arg4;
- (BOOL)_notifyDelegateAndOpenEditorHistoryItem:(id)arg1
                                              updateHistory:(BOOL)arg2
            skipSubDocumentNavigationUnlessEditorIsReplaced:(BOOL)arg3;
- (BOOL)_notifyDelegateAndOpenEditorOpenSpecifier:(id)arg1 updateHistory:(BOOL)arg2;
- (BOOL)_notifyDelegateAndOpenNavigableItem:(id)arg1
                                            withContentsURL:(id)arg2
                                documentExtensionIdentifier:(id)arg3
                                           locationToSelect:(id)arg4
                                annotationRepresentedObject:(id)arg5
                                            stateDictionary:(id)arg6
                          annotationWantsIndicatorAnimation:(BOOL)arg7
                         exploreAnnotationRepresentedObject:(id)arg8
                                         highlightSelection:(BOOL)arg9
                         alwaysReplaceExistingNavigableItem:(BOOL)arg10
            skipSubDocumentNavigationUnlessEditorIsReplaced:(BOOL)arg11;
- (BOOL)_openEditorHistoryItem:(id)arg1
                                   previousHistoryItemOrNil:(id)arg2
                         alwaysReplaceExistingNavigableItem:(BOOL)arg3
            skipSubDocumentNavigationUnlessEditorIsReplaced:(BOOL)arg4;
- (BOOL)_openEditorHistoryItem:(id)arg1 updateHistory:(BOOL)arg2;
- (void)_openEditorHistoryItemFromStateSaving:(id)arg1;
- (BOOL)_openEmptyEditor;
- (void)_openInAdjacentEditorWithEventBehavior:(int)arg1;
- (int)_openNavigableItem:(id)arg1
                   documentExtension:(id)arg2
                            document:(id)arg3
            shouldInstallEditorBlock:(CDUnknownBlockType)arg4;
- (int)_openNavigableItem:(id)arg1
                   withContentsOfURL:(id)arg2
                   documentExtension:(id)arg3
            shouldInstallEditorBlock:(CDUnknownBlockType)arg4;
- (int)_openNavigableItem:(id)arg1 withContentsOfURL:(id)arg2 shouldInstallEditorBlock:(CDUnknownBlockType)arg3;
- (void)_performBlockInsideReentrantGuard:(CDUnknownBlockType)arg1;
- (void)_popUpMenuForNavigableItem:(id)arg1;
- (void)_preloadSwipeInfrastructure;
- (void)_primitiveSetNavBarRootNavigableItem:(id)arg1 selectedNavigableItem:(id)arg2;
- (void)_rebuildLeftControlGroup;
- (void)_rebuildRightControlGroup;
- (id)_recentEditorDocumentsCapacityPreferenceMenuItem;
- (void)_registerForDocumentNotificationsForDocument:(id)arg1;
- (void)_removeFromLastActiveEditorContexts;
- (void)_selectNavigableItem:(id)arg1 updateOutputSelection:(id)arg2;
- (void)_setCanAddSplit:(BOOL)arg1;
- (void)_setCanRemoveSplit:(BOOL)arg1;
- (void)_setEditorGeniusResultsGenerationEnabled:(BOOL)arg1;
- (void)_setEditorView;
- (void)_setEmptyRootNavigableItem;
- (void)_setShowMiniIssueNavigator:(BOOL)arg1;
- (void)_setShowNavBarHistoryStepperControls:(BOOL)arg1;
- (void)_setShowRelatedItemsControl:(BOOL)arg1;
- (void)_setShowSiblingStepperControl:(BOOL)arg1;
- (void)_setShowSplittingControls:(BOOL)arg1;
- (void)_setSupportsReadOnlyIndicator:(BOOL)arg1;
- (BOOL)_showSwipeOverlayForDirection:(BOOL)arg1 imageOfCurrentEditorOnTop:(char*)arg2;
- (struct CGRect)_swipeLayerViewFrame;
- (void)_swipeToGoForward:(BOOL)arg1;
- (void)_teardownDocumentNotifications;
- (void)_testAssertions;
- (void)_uninstallFindBar;
- (void)_updateNavBarNavigableItemForNavItem:(id)arg1;
- (void)_updateSiblingInfoFromNavigableItem;
- (void)_updateSiblingStepperControlVisibility;
- (void)_updateSubDocumentNavigableItems;
- (BOOL)_validateOpenInAdjacentEditorCommandForUserInterfaceItem:(id)arg1 forEventBehavior:(int)arg2;
- (void)_verifyURLsForDocumentAndDocumentNavItem;
- (BOOL)_viewHasFocus:(id)arg1;
- (void)_writeCurrentStateToLastUsedDictionaryIfNeeded;
- (void)addSplitForSplittingController:(id)arg1;
@property (nonatomic) int borderSides; // @synthesize borderSides=_borderSides;
@property (nonatomic) BOOL canAddSplit; // @synthesize canAddSplit=_canAddSplit;
- (BOOL)canBecomeMainViewController;
- (BOOL)canGoBackInHistory;
- (BOOL)canGoForwardInHistory;
- (BOOL)canJumpToIssue:(id)arg1;
@property (nonatomic) BOOL canRemoveSplit; // @synthesize canRemoveSplit=_canRemoveSplit;
- (void)closeDocument:(id)arg1;
- (BOOL)commitEditingForAction:(int)arg1 errors:(id)arg2;
- (id)currentHistoryItem;
- (id)currentHistoryItemWithImageOfCurrentEditor;
- (id)currentHistoryStack;
@property (copy) NSArray* defaultEditorCategories; // @synthesize defaultEditorCategories=_defaultEditorCategories;
@property (retain) id<IDEEditorContextDelegate> delegate; // @synthesize delegate=_delegate;
- (void)discardEditing;
- (void)dismissFindBar:(id)arg1 andRestoreSelection:(BOOL)arg2;
@property (readonly) NSString*
            documentExtensionIdentifier; // @synthesize documentExtensionIdentifier=_documentExtensionIdentifier;
- (unsigned long long)draggingSourceOperationMaskForLocal:(BOOL)arg1;
- (void)dvtFindBar:(id)arg1 didUpdateCurrentResult:(id)arg2;
- (void)dvtFindBar:(id)arg1 didUpdateResults:(id)arg2;
- (BOOL)dvtFindBar:(id)arg1 validateUserInterfaceItem:(id)arg2;
@property (retain, nonatomic) IDEEditor* editor; // @synthesize editor=_editor;
@property (retain, nonatomic) IDEEditorArea* editorArea; // @synthesize editorArea=_editorArea;
@property (readonly)
            IDEEditorGeniusResults* editorGeniusResults; // @synthesize editorGeniusResults=_editorGeniusResults;
- (void)find:(id)arg1;
- (void)findAndReplace:(id)arg1;
- (void)findNext:(id)arg1;
- (void)findPrevious:(id)arg1;
- (void)fixNextIssue:(id)arg1;
- (void)fixPreviousIssue:(id)arg1;
@property (retain)
            _IDEGeniusResultsContext* geniusResultsContext; // @synthesize geniusResultsContext=_geniusResultsContext;
- (void)goBackInHistoryByCommand:(id)arg1;
- (void)goBackInHistoryByCommandWithAlternate:(id)arg1;
- (void)goBackInHistoryByCommandWithShiftPlusAlternate:(id)arg1;
- (void)goBackInHistoryWithCurrentEvent:(id)arg1;
- (void)goForwardInHistoryByCommand:(id)arg1;
- (void)goForwardInHistoryByCommandWithAlternate:(id)arg1;
- (void)goForwardInHistoryByCommandWithShiftPlusAlternate:(id)arg1;
- (void)goForwardInHistoryWithCurrentEvent:(id)arg1;
- (struct CGRect)grabRect;
@property (readonly) IDENavigableItem* greatestDocumentAncestor;
- (void)hideFindBar:(id)arg1;
@property BOOL
            hideWorkspaceLoadingProgressIndicator; // @synthesize
                                                   // hideWorkspaceLoadingProgressIndicator=_hideWorkspaceLoadingProgressIndicator;
- (void)ide_unlockDocument:(id)arg1;
- (id)initWithNibName:(id)arg1 bundle:(id)arg2;
@property BOOL
            isCallingNewEditorDocumentWithClass; // @synthesize
                                                 // isCallingNewEditorDocumentWithClass=_isCallingNewEditorDocumentWithClass;
- (BOOL)isLastActiveEditorContext;
@property (readonly) BOOL isPrimaryEditorContext;
- (void)jumpToInstructionPointer:(id)arg1;
- (void)jumpToNextCounterpart:(id)arg1;
- (void)jumpToNextCounterpartWithAlternate:(id)arg1;
- (void)jumpToNextCounterpartWithShiftPlusAlternate:(id)arg1;
- (void)jumpToNextIssue:(id)arg1;
- (void)jumpToPreviousCounterpart:(id)arg1;
- (void)jumpToPreviousCounterpartWithAlternate:(id)arg1;
- (void)jumpToPreviousCounterpartWithShiftPlusAlternate:(id)arg1;
- (void)jumpToPreviousIssue:(id)arg1;
- (void)loadView;
- (void)menuNeedsUpdate:(id)arg1;
@property (retain) IDEEditorMultipleContext* multipleContext; // @synthesize multipleContext=_multipleContext;
@property (readonly) IDENavigableItem* navBarNavigableItem; // @synthesize navBarNavigableItem=_navBarNavigableItem;
@property (readonly)
            IDENavigableItem* navBarNavigableItemRoot; // @synthesize navBarNavigableItemRoot=_navBarNavigableItemRoot;
- (id)navBarNavigableItemRootChildItems;
@property (retain, nonatomic) IDENavigableItem* navigableItem; // @synthesize navigableItem=_navigableItem;
- (id)navigableItemArchivableRepresentationInSelectedGeniusCategoryForRepresentedObject:(id)arg1;
@property (readonly) IDENavigableItemCoordinator*
            navigableItemCoordinator; // @synthesize navigableItemCoordinator=_navigableItemCoordinator;
- (id)navigableItemCoordinator:(id)arg1 editorDocumentForNavigableItem:(id)arg2;
@property (readonly) NSArray* navigableItemSiblings; // @synthesize navigableItemSiblings=_navigableItemSiblings;
@property (readonly) NSIndexSet*
            navigableItemSiblingsSelectionIndexes; // @synthesize
                                                   // navigableItemSiblingsSelectionIndexes=_navigableItemSiblingsSelectionIndexes;
- (BOOL)openEditorHistoryItem:(id)arg1;
- (BOOL)openEditorOpenSpecifier:(id)arg1;
- (BOOL)openEditorOpenSpecifier:(id)arg1 updateHistory:(BOOL)arg2;
- (void)openInAdjacentEditorWithAlternate:(id)arg1;
- (void)openInAdjacentEditorWithShiftPlusAlternate:(id)arg1;
@property (retain) NSURL*
            originalRequestedDocumentURL; // @synthesize originalRequestedDocumentURL=_originalRequestedDocumentURL;
- (id)outputSelection;
- (BOOL)pathCell:(id)arg1 beginDragForComponentCell:(id)arg2;
- (id)pathCell:(id)arg1 childItemsForItem:(id)arg2;
- (void)pathCell:(id)arg1 didEndDragForComponentCell:(id)arg2;
- (void)pathCell:(id)arg1 didUpdateMenu:(id)arg2;
- (id)pathCell:(id)arg1 menuItemForNavigableItem:(id)arg2 defaultMenuItem:(id)arg3;
- (BOOL)pathCell:(id)arg1 shouldDisplayChildrenForItem:(id)arg2;
- (BOOL)pathCell:(id)arg1 shouldEnableSelection:(id)arg2;
- (BOOL)pathCell:(id)arg1 shouldInitiallyShowMenuSearch:(id)arg2;
- (BOOL)pathCell:(id)arg1 shouldPopUpMenuForPathComponentCell:(id)arg2 item:(id)arg3;
- (BOOL)pathCell:(id)arg1 shouldSeparateDisplayOfChildItemsForItem:(id)arg2;
- (BOOL)pathControl:(id)arg1 acceptDrop:(id)arg2;
- (unsigned long long)pathControl:(id)arg1 validateDrop:(id)arg2;
- (id)pathControlPasteboardReadingOptions;
- (BOOL)presentError:(id)arg1;
- (void)presentError:(id)arg1
                modalForWindow:(id)arg2
                      delegate:(id)arg3
            didPresentSelector:(SEL)arg4
                   contextInfo:(void*)arg5;
- (void)primitiveInvalidate;
- (void)removeSplitForSplittingController:(id)arg1;
- (void)replace:(id)arg1;
- (void)replaceAll:(id)arg1;
- (void)replaceAndFindNext:(id)arg1;
- (void)replaceAndFindPrevious:(id)arg1;
@property (copy)
            CDUnknownBlockType retryOpenOperationBlock; // @synthesize retryOpenOperationBlock=_retryOpenOperationBlock;
@property (readonly) NSScrollView* scopeBarsAdjustableScrollView;
@property (readonly) NSView* scopeBarsBaseView;
@property (readonly) DVTScopeBarsManager* scopeBarsManager; // @synthesize scopeBarsManager=_scopeBarsManager;
- (id)scopeBarsManagerForEditor:(id)arg1;
- (void)scrollWheel:(id)arg1;
- (struct _NSRange)selectedRangeForFindBar:(id)arg1;
- (void)setEmptyContentString:(id)arg1;
- (void)setGreatestDocumentAncestor:(id)arg1;
- (void)setNavBarNavigableItem:(id)arg1;
- (void)setNavigableItemSiblingsSelectionIndexes:(id)arg1;
- (void)setOutputSelection:(id)arg1;
@property (nonatomic) BOOL showMiniIssueNavigator; // @synthesize showMiniIssueNavigator=_showMiniIssueNavigator;
@property (nonatomic) BOOL showNavBar; // @synthesize showNavBar=_showNavBar;
@property (nonatomic) BOOL
            showNavBarHistoryStepperControls; // @synthesize
                                              // showNavBarHistoryStepperControls=_showNavBarHistoryStepperControls;
@property (nonatomic) BOOL showRelatedItemsControl; // @synthesize showRelatedItemsControl=_showRelatedItemsControl;
@property (nonatomic)
            BOOL showSiblingStepperControl; // @synthesize showSiblingStepperControl=_showSiblingStepperControl;
@property (nonatomic) BOOL showSplittingControls; // @synthesize showSplittingControls=_showSplittingControls;
@property (copy) NSArray* validEditorCategories; // @synthesize validEditorCategories=_validEditorCategories;
- (void)setupNewEditor:(id)arg1;
- (void)showDocumentItemsMenu:(id)arg1;
- (void)showGroupFilesMenu:(id)arg1;
- (void)showMiniIssuesNavigatorMenu:(id)arg1;
- (void)showNextFilesHistoryMenu:(id)arg1;
- (void)showNextHistoryMenu:(id)arg1;
- (void)showPreviousFilesHistoryMenu:(id)arg1;
- (void)showPreviousHistoryMenu:(id)arg1;
- (void)showRelatedItemsMenu:(id)arg1;
- (void)showTopLevelItemsMenu:(id)arg1;
- (id)startingLocationForFindBar:(id)arg1 findingBackwards:(BOOL)arg2;
- (void)stateRepositoryDidChange:(id)arg1;
- (id)supplementalMainViewController;
- (void)swipeWithEvent:(id)arg1;
- (void)takeFocus;
- (void)updateWithHistoryStack:(id)arg1;
- (BOOL)validateUserInterfaceItem:(id)arg1;
- (id)view;
- (void)viewDidInstall;
- (id)viewToShowWrapOrEndOfFileBezelOn:(id)arg1;
- (void)viewWillUninstall;
- (BOOL)wantsScrollEventsForSwipeTrackingOnAxis:(long long)arg1;
- (id)willPresentError:(id)arg1;
- (id)workspace;

// Remaining properties
@property (readonly, copy) NSString* debugDescription;
@property (readonly, copy) NSString* description;
@property (readonly) unsigned long long hash;
@property (readonly) Class superclass;

@end
