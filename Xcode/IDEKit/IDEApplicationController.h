//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

#import <objc/NSObject.h>

@class DVTDelayedInvocation, DVTNotificationToken, DVTObservingToken, IDESourceControlUIHandler, NSArray, NSDictionary, NSMenuItem, NSMutableDictionary, NSString;
@protocol NSMenuDelegate;

@interface IDEApplicationController : NSObject <NSApplicationDelegate, NSMenuDelegate>
{
    BOOL _haveScannedForPlugins;	// 8 = 0x8
    NSDictionary *_extensionIdToMenuDict;	// 16 = 0x10
    BOOL _closeKeyEquivalentClosesTab;	// 24 = 0x18
    NSString *_extensionIdForCurrentEditorAndNavigateMenus;	// 32 = 0x20
    NSString *_currentEditorMenuExtensionId;	// 40 = 0x28
    id <NSMenuDelegate> _editorMenuDelegate;	// 48 = 0x30
    NSString *_currentNavigateMenuExtensionId;	// 56 = 0x38
    long long _originalNavigateMenuItemCount;	// 64 = 0x40
    NSArray *_currentDebuggingAdditonUIExtensions;	// 72 = 0x48
    NSMenuItem *_shiftedCloseMenuItem;	// 80 = 0x50
    NSMenuItem *_shiftedCloseAllMenuItem;	// 88 = 0x58
    IDESourceControlUIHandler *_sourceControlUIHandler;	// 96 = 0x60
    DVTDelayedInvocation *_tabStateContextDelayedSaveInvocation;	// 104 = 0x68
    NSMutableDictionary *_tabStateContextForTabNameMap;	// 112 = 0x70
    DVTObservingToken *_lastActiveEditorToken;	// 120 = 0x78
    DVTNotificationToken *_lastActiveEditorContextNotificationToken;	// 128 = 0x80
    id _keyBindingSetWillActivateObserver;	// 136 = 0x88
    id _keyBindingSetDidActivateObserver;	// 144 = 0x90
    BOOL _isSafeToLoadMobileDevice;	// 152 = 0x98
    BOOL _hasScheduledMobileDeviceLoadBlock;	// 153 = 0x99
    BOOL _applicationIsTerminatingDuringLaunch;	// 154 = 0x9a
    BOOL _applicationShouldTerminateRecursionGuard;	// 155 = 0x9b
    BOOL _currentEditorAndNavigatorMenusAreBackstop;	// 156 = 0x9c
    BOOL _forceUpdateOfEditorAndNavigateMenus;	// 157 = 0x9d
}

+ (void)initialize;
+ (id)sharedAppController;
- (void)_activateMenuKeyBindingSetWithMenuDefinitionExtensionIdentifiers:(id)arg1;
- (id)_cachedMenuDefinitionExtensionIdentifiers;
- (id)_cachedMenuForDefinitionExtensionIdentifier:(id)arg1;
- (id)_closeMenuItem;
- (id)_closeWindowAsTabMenuItem;
- (id)_debugMenu;
- (id)_editMenu;
- (id)_editorForMenuContent;
- (id)_editorMenu;
- (id)_editorMenuProviderExtension;
- (id)_fileMenu;
- (void)_handleGetURLEvent:(id)arg1 withReplyEvent:(id)arg2;
- (void)_incrementCountForKey:(id)arg1 in:(id)arg2;
- (void)_modifyMenu:(id)arg1 withItemsFromMenu:(id)arg2 replace:(BOOL)arg3;
- (id)_navigateMenu;
- (void)_pruneEditorMenu;
- (void)_pruneNavigateMenu;
- (BOOL)_saveTabStateContextForTabNameMapToFilePath:(id)arg1;
- (void)_setKeyEquivalentForMenuItem:(id)arg1 toIncludeShiftKey:(BOOL)arg2;
- (void)_setTabStateContext:(id)arg1 forTabNamed:(id)arg2;
- (void)_setUpGetURLAppleEventHandler;
- (void)_setUpMainMenu;
- (void)_setUpOpenDocumentAppleEventHandler;
- (unsigned long long)_shouldTerminateClosingDocuments;
- (id)_tabStateContextForTabNameMapByInstantiatingIfNeeded;
- (id)_tabStateContextForTabNameMapFromFilePath:(id)arg1;
- (id)_tabStateContextForTabNamed:(id)arg1;
- (void)_terminateDueToFailureDuringLaunch:(id)arg1;
- (void)_updateCloseKeyEquivalents;
- (void)_updateCloseKeyEquivalentsIfNeeded;
- (void)_updateEditMenuIfNeeded;
- (void)_updateEditorAndNavigateMenusIfNeeded;
- (void)_updateUtilitiesMenuIfNeeded;
- (BOOL)_useOrganizerForMenuContent;
- (id)_utilitiesMenu;
- (id)_viewMenu;
- (BOOL)application:(id)arg1 openFile:(id)arg2;
- (void)application:(id)arg1 openFiles:(id)arg2;
- (void)applicationDidFinishLaunching:(id)arg1;
- (id)applicationDockMenu:(id)arg1;
- (void)applicationIsTerminating:(id)arg1;
@property BOOL applicationIsTerminatingDuringLaunch; // @synthesize applicationIsTerminatingDuringLaunch=_applicationIsTerminatingDuringLaunch;
- (BOOL)applicationOpenUntitledFile:(id)arg1;
- (unsigned long long)applicationShouldTerminate:(id)arg1;
- (void)applicationWillFinishLaunching:(id)arg1;
- (void)applicationWillTerminate:(id)arg1;
- (void)batchFind:(id)arg1 userData:(id)arg2 error:(id *)arg3;
- (void)editorMenuWillOpen:(id)arg1;
@property BOOL forceUpdateOfEditorAndNavigateMenus; // @synthesize forceUpdateOfEditorAndNavigateMenus=_forceUpdateOfEditorAndNavigateMenus;
@property(readonly) NSString *formattedApplicationVersion;
- (void)handleURL:(id)arg1 completionHandler:(void(^)(void))arg2;
@property BOOL haveScannedForPlugins; // @synthesize haveScannedForPlugins=_haveScannedForPlugins;
- (unsigned long long)ide_applicationShouldTerminate:(id)arg1;
- (id)init;
- (id)licenseAgreementFilePathForFileType:(id)arg1;
- (void)menuNeedsUpdate:(id)arg1;
- (void)menuWillOpen:(id)arg1;
- (void)openQuickly:(id)arg1 userData:(id)arg2 error:(id *)arg3;
- (void)openURLs:(id)arg1 completionBlock:(void(^)(void))arg2;
- (void)updateDebugMenuIfNeeded;
- (void)viewMenuWillOpen:(id)arg1;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) NSUInteger hash;
@property(readonly) Class superclass;

@end

