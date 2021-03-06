//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

#import <AppKit/NSWindowController.h>

#if 0
#import <IDEKit/DVTEditor-Protocol.h>
#import <IDEKit/DVTInvalidation-Protocol.h>
#import <IDEKit/DVTStatefulObject-Protocol.h>
#import <IDEKit/IDEEditorAreaContainer-Protocol.h>
#import <IDEKit/NSTouchBarDelegate-Protocol.h>
#import <IDEKit/NSTouchBarProvider-Protocol.h>
#import <IDEKit/NSWindowDelegate-Protocol.h>
#endif

@class DVTNotificationToken, DVTObservingToken, DVTPerformanceMetric, DVTStackBacktrace, DVTStateToken,
            DVTWeakInterposer, IDEEditorArea, IDEEditorDocument, IDEToolbarDelegate, IDEWorkspace,
            IDEWorkspaceDFRController, IDEWorkspaceTabController, IDEWorkspaceWindow, NSMutableArray, NSString, NSTimer,
            NSTouchBar, _IDEWindowFullScreenSavedDebuggerTransitionValues;

@interface IDEWorkspaceWindowController : NSWindowController // <NSTouchBarProvider, NSTouchBarDelegate,
                                                             // NSWindowDelegate, IDEEditorAreaContainer,
                                                             // DVTStatefulObject, DVTEditor, DVTInvalidation>
{
    NSTimer* _springToFrontTimer; // 80 = 0x50
    int _debugSessionState; // 88 = 0x58
    struct CGRect _restoreFrame; // 96 = 0x60
    struct CGSize _originalMinSize; // 128 = 0x80
    NSMutableArray* _stateChangeObservingTokens; // 144 = 0x90
    IDEEditorDocument* _lastObservedEditorDocument; // 152 = 0x98
    IDEWorkspaceTabController* _activeWorkspaceTabController; // 160 = 0xa0
    IDEToolbarDelegate* _toolbarDelegate; // 168 = 0xa8
    DVTObservingToken* _workspaceSimpleFilesFocusedObservingToken; // 176 = 0xb0
    DVTObservingToken* _workspaceRepresentingFilePathObservingToken; // 184 = 0xb8
    DVTObservingToken* _workspaceFinishedLoadingObservingToken; // 192 = 0xc0
    DVTObservingToken* _navigationTargetedEditorDocumentObservingToken; // 200 = 0xc8
    DVTObservingToken* _tabLabelObservingToken; // 208 = 0xd0
    DVTObservingToken* _themeObserver; // 216 = 0xd8
    DVTObservingToken* _firstResponderValidObservingToken; // 224 = 0xe0
    DVTNotificationToken* _deallocatingFirstResponderNotificationToken; // 232 = 0xe8
    DVTNotificationToken* _editorDocumentIsEditedNotificationToken; // 240 = 0xf0
    IDEWorkspace* _workspace; // 248 = 0xf8
    _IDEWindowFullScreenSavedDebuggerTransitionValues* _fullScreenSavedDebuggerTransitionValues; // 256 = 0x100
    DVTPerformanceMetric* _newWindowControllerMetric; // 264 = 0x108
    unsigned int _coalescedUpdateMask; // 272 = 0x110
    int _contentViewFrozenMode; // 276 = 0x114
    BOOL _performingCoalescedUpdates; // 280 = 0x118
    BOOL _tabBarInTransition; // 281 = 0x119
    BOOL _tabBarShownForTabDrag; // 282 = 0x11a
    BOOL _createdCollapsedRestoreFrame; // 283 = 0x11b
    BOOL _createdMediumRestoreFrame; // 284 = 0x11c
    BOOL _inTotalCollapsedFrame; // 285 = 0x11d
    BOOL _tabBarForcedClosed; // 286 = 0x11e
    BOOL _isClosing; // 287 = 0x11f
    BOOL _didSetActiveWorkspaceTabController; // 288 = 0x120
    BOOL _enteringFullScreenMode; // 289 = 0x121
    BOOL _exitingFullScreenMode; // 290 = 0x122
    DVTStateToken* _stateToken; // 296 = 0x128
    BOOL _createNewTabUponLoadIfNoTabsExist; // 304 = 0x130
    BOOL _shouldPerformWindowClose; // 305 = 0x131
    BOOL _didRestoreFromStateSaving; // 306 = 0x132
    NSString* _uniqueIdentifier; // 312 = 0x138
    NSString* _stateSavingIdentifier; // 320 = 0x140
    DVTStackBacktrace* _windowDidLoadBacktrace; // 328 = 0x148
    DVTWeakInterposer* _firstResponderInterposer; // 336 = 0x150
    IDEWorkspaceDFRController* _standardWorkspaceTouchBarController; // 344 = 0x158
    IDEWorkspaceDFRController* _systemModalWorkspaceTouchBarController; // 352 = 0x160
    long long _visibleSheetsCount; // 360 = 0x168
}

+ (unsigned long long)assertionBehaviorAfterEndOfEventForSelector:(SEL)arg1;
+ (void)configureStateSavingObjectPersistenceByName:(id)arg1;
+ (void)initialize;
+ (id)keyPathsForValuesAffectingEditorArea;
+ (id)keyPathsForValuesAffectingShouldEnableToolbarItems;
+ (id)keyPathsForValuesAffectingUserWantsBreakpointsActivated;
+ (unsigned long long)supplimental23378396AssertionBehaviorForKeyValueObservationsAtEndOfEvent;
+ (long long)version;
+ (id)workspaceWindowControllerForWindow:(id)arg1;
+ (id)workspaceWindowControllers;
// - (void).cxx_destruct;
- (void)_cancelSpringToFront;
- (void)_changeSizeForSimpleEditorWindowLayoutWithEditorDocumentURLOrNil:(id)arg1
                                                               forSingleFile:(BOOL)arg2
                                                      workspaceTabController:(id)arg3;
- (id)_cloneNewWindowController;
- (id)_cloneWindowWithUserDefinedLabel:(id)arg1 addToTabGroup:(BOOL)arg2 activate:(BOOL)arg3;
- (void)_configureStateSavingObservers;
- (void)_convertToSimpleEditorWindowForDocumentURL:(id)arg1;
- (id)_createSimpleEditorWindowControllerForDocumentURL:(id)arg1 activate:(BOOL)arg2;
- (id)_createSystemModalDebuggingFunctionBar;
- (BOOL)_debuggerItemShouldBeSuppressed;
- (id)_editorRunGroupOverrideIdentifier;
- (unsigned long long)_factoryTypeForTracing:(BOOL)arg1;
- (id)_identifierForCurrentDebuggerControls;
- (void)_invokeCurrentActionForButton:(id)arg1;
- (BOOL)_isLastWindowControllerOfDocument;
- (BOOL)_isTargetApplicationActive;
- (void)_makeWindowLookKeyWhenKey;
- (void)_observeInvalidationOfFirstResponder:(id)arg1 firstResponderAssignedBacktrace:(id)arg2;
- (void)_observeToolbarMenuButton:(id)arg1 toUpdateButton:(id)arg2;
- (void)_performCloseAll;
- (void)_performSpringToFront;
- (void)_preventAutomaticallyAddingNewWindowControllerToTabGroup:(id)arg1 duringBlock:(CDUnknownBlockType)arg2;
- (void)_purgeOldIdentifiersFromUserDefaults;
- (void)_pushDefaultPrimaryEditorFrameSizes;
- (void)_recordRestoreFrame;
- (void)_registerWorkspaceWindowControllerObservations;
- (id)_runGroupItem;
- (id)_runItem;
- (void)_scheduleSpringToFront;
- (id)_screenForWindow;
- (void)_selectTabForWindow;
- (void)_setUpWindowController:(id)arg1 withUserDefinedLabel:(id)arg2 addToTabGroup:(BOOL)arg3 activate:(BOOL)arg4;
- (void)_setWindowFrameUsingValueFromStateSaving:(id)arg1;
- (void)_setupActiveWorkspaceTabController;
- (BOOL)_shouldCloseWindowEvaluatingOtherWindows;
- (void)_showWindowBehindWorkspaceWindow:(id)arg1;
- (id)_standardDebugControlsItemWithIdentifier:(id)arg1;
- (void)_switchMenuButton:(id)arg1 toItemWithSelector:(SEL)arg2;
- (id)_systemModalDebugControlsGroupItemWithIdentifier:(id)arg1;
- (id)_tabStateContextForTabController:(id)arg1;
- (id)_touchBarDebugSessionActive;
- (id)_touchBarForCurrentRunState;
- (id)_touchBarIdleSession;
- (id)_uniqueNameForNewWorkspaceTabController;
- (void)_updateTitleRepresentedPath;
- (void)_updateWindowTitle;
- (id)_windowFrameValueForStateSaving;
- (void)_workaround8217584;
@property (retain) IDEWorkspaceTabController* activeWorkspaceTabController;
- (void)autocreateContexts:(id)arg1;
- (BOOL)canCreateNewTab;
- (void)changeFromDebugSessionState:(int)arg1 to:(int)arg2 forLaunchSession:(id)arg3;
- (BOOL)commitEditingForAction:(int)arg1 errors:(id)arg2;
- (void)commitStateToDictionary:(id)arg1;
@property BOOL
            createNewTabUponLoadIfNoTabsExist; // @synthesize
                                               // createNewTabUponLoadIfNoTabsExist=_createNewTabUponLoadIfNoTabsExist;
- (void)dicardEditing;
@property BOOL didRestoreFromStateSaving; // @synthesize didRestoreFromStateSaving=_didRestoreFromStateSaving;
@property (readonly) IDEEditorArea* editorArea;
@property (retain) DVTWeakInterposer*
            firstResponderInterposer; // @synthesize firstResponderInterposer=_firstResponderInterposer;
- (id)ide_lastActiveEditor;
- (id)init;
- (id)instantiateTabControllerAndRegisterForStateSavingWithName:(id)arg1 inDocument:(id)arg2;
- (BOOL)isEnteringOrInFullScreenMode;
- (BOOL)isInFullScreenMode;
- (id)makeTouchBar;
- (void)minimizeDebugBar;
- (void)moveFocusToEditor:(id)arg1;
- (void)newTab:(id)arg1;
- (void)newWindow:(id)arg1;
- (void)newWindowForTab:(id)arg1;
- (void)primitiveInvalidate;
- (void)revertStateWithDictionary:(id)arg1;
- (void)runActiveRunContextWithGesture:(id)arg1;
- (id)runButtonPopoverBar;
- (id)runStopButtonFromToolbar;
@property (readonly) IDEWorkspaceWindowController* selectedTabWorkspaceWindowController;
@property BOOL shouldPerformWindowClose; // @synthesize shouldPerformWindowClose=_shouldPerformWindowClose;
@property (nonatomic) BOOL showToolbar;
@property (retain) IDEWorkspaceDFRController*
            standardWorkspaceTouchBarController; // @synthesize
                                                 // standardWorkspaceTouchBarController=_standardWorkspaceTouchBarController;
@property (copy, nonatomic)
            NSString* stateSavingIdentifier; // @synthesize stateSavingIdentifier=_stateSavingIdentifier;
@property (retain) DVTStateToken* stateToken;
@property (retain) IDEWorkspaceDFRController*
            systemModalWorkspaceTouchBarController; // @synthesize
                                                    // systemModalWorkspaceTouchBarController=_systemModalWorkspaceTouchBarController;
@property (copy, nonatomic) NSString* uniqueIdentifier; // @synthesize uniqueIdentifier=_uniqueIdentifier;
@property BOOL userWantsBreakpointsActivated;
@property long long visibleSheetsCount; // @synthesize visibleSheetsCount=_visibleSheetsCount;
@property (retain)
            DVTStackBacktrace* windowDidLoadBacktrace; // @synthesize windowDidLoadBacktrace=_windowDidLoadBacktrace;
@property (readonly) BOOL shouldEnableToolbarItems;
- (void)standardDFRDebugBarStopAction:(id)arg1;
- (id)standardWorkspaceDFRController;
- (id)supplementalTargetForAction:(SEL)arg1 sender:(id)arg2;
- (void)switchToAndAnalyze:(id)arg1;
- (void)switchToAndProfile:(id)arg1;
- (void)switchToAndRun:(id)arg1;
- (void)switchToAndTest:(id)arg1;
- (void)synchronizeWindowTitleWithDocumentName;
- (id)systemModalFunctionBarForDebugSession;
- (id)systemModalWorkspaceDFRController;
- (void)toggleToolbarShown:(id)arg1;
- (id)touchBar:(id)arg1 makeItemForIdentifier:(id)arg2;
- (void)updateButtonsForDebugSessionState:(int)arg1;
- (void)updateDebuggerControlsGroupOnSystemModalDebugBar:(id)arg1;
- (void)updateSystemModalDebugBar;
- (void)updateTouchBar;
- (BOOL)validateMenuItem:(id)arg1;
- (BOOL)wantsToolbarVisibleInFullScreen;
- (BOOL)window:(id)arg1 shouldRestoreStateForResponder:(id)arg2;
- (unsigned long long)window:(id)arg1 willUseFullScreenPresentationOptions:(unsigned long long)arg2;
- (void)windowDidBecomeMain:(id)arg1;
- (void)windowDidEndSheet:(id)arg1;
- (void)windowDidEnterFullScreen:(id)arg1;
- (void)windowDidExitFullScreen:(id)arg1;
- (void)windowDidLoad;
- (void)windowDidMove:(id)arg1;
- (void)windowDidResignMain:(id)arg1;
- (void)windowDidResize:(id)arg1;
- (BOOL)windowShouldZoom:(id)arg1 toFrame:(struct CGRect)arg2;
- (void)windowWillBeginSheet:(id)arg1;
- (void)windowWillClose:(id)arg1;
- (void)windowWillEnterFullScreen:(id)arg1;
- (void)windowWillExitFullScreen:(id)arg1;
- (struct CGSize)windowWillResize:(id)arg1 toSize:(struct CGSize)arg2;
- (id)workspaceTabControllers;
- (void)workspaceTabDFRShouldBecomeVisible;
@property (readonly) IDEWorkspaceWindow* workspaceWindow;
- (BOOL)workspaceWindow:(id)arg1 interceptAddCursorRect:(struct CGRect)arg2 cursor:(id)arg3 forView:(id)arg4;
- (BOOL)workspaceWindow:(id)arg1 interceptSetCursorForMouseLocation:(struct CGPoint)arg2;
- (void)workspaceWindow:(id)arg1 willInvalidateCursorRectsForView:(id)arg2;
- (id)workspaceWindowControllersForTabGroup;
- (void)workspaceWindowDidRecalculateKeyViewLoop:(id)arg1;
- (void)workspaceWindowIsClosing:(id)arg1;
- (void)workspaceWindowWillInvalidateCursorRectsForViewsWithNoTrackingAreas:(id)arg1;

// Remaining properties
@property (readonly) BOOL canRevertWithEmptyStateDictionary;
@property (retain) DVTStackBacktrace* creationBacktrace;
@property (readonly, copy) NSString* debugDescription;
@property (readonly, copy) NSString* description;
@property (readonly) unsigned long long hash;
@property (readonly) DVTStackBacktrace* invalidationBacktrace;
@property (readonly) Class superclass;
@property (readonly) NSTouchBar* touchBar;
@property (readonly, nonatomic, getter=isValid) BOOL valid;

@end
