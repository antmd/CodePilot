//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2015 by Steve Nygard.
//

#import <DVTKit/DVTApplication.h>

//#import <IDEKit/NSMenuDelegate-Protocol.h>

@class NSString;
@protocol IDEApplicationEventDelegate;

@interface IDEApplication : DVTApplication <NSMenuDelegate>
{
    id _ideEventDelegate;	// 152 = 0x98
}

- (void)_openDocumentURLs:(id)arg1 withCompletionHandler:(void(^)(void))arg2;
- (BOOL)_removeWindowMenuItems;
- (void)_removeWindowMenuItemsIfNeeded;
- (id)_workspaceWindowControllers;
- (void)addWindowsItem:(id)arg1 title:(id)arg2 filename:(BOOL)arg3;
- (void)beginSheet:(id)arg1 modalForWindow:(id)arg2 modalDelegate:(id)arg3 didEndSelector:(SEL)arg4 contextInfo:(void *)arg5;
- (void)changeWindowsItem:(id)arg1 title:(id)arg2 filename:(BOOL)arg3;
- (void)closeAll:(id)arg1;
- (void)endSheet:(id)arg1 returnCode:(long long)arg2;
- (void)enumerateWindowsWithOptions:(long long)arg1 usingBlock:(void(^)(NSWindow*))arg2;
@property(retain) id <IDEApplicationEventDelegate> eventDelegate; // @synthesize eventDelegate=_ideEventDelegate;
- (void)insertInSdefSupport_workspaceDocuments:(id)arg1;
- (void)menuNeedsUpdate:(id)arg1;
- (id)newScriptingObjectOfClass:(Class)arg1 forValueForKey:(id)arg2 withContentsValue:(id)arg3 properties:(id)arg4;
- (void)removeWindowsItem:(id)arg1;
- (void)reportException:(id)arg1;
- (BOOL)restoreWindowWithIdentifier:(id)arg1 state:(id)arg2 completionHandler:(void(^)(void))arg3;
- (id)sdefSupport_activeWorkspaceDocument;
- (id)sdefSupport_workspaceDocuments;
- (void)sendEvent:(id)arg1;
- (void)setSdefSupport_activeWorkspaceDocument:(id)arg1;
- (void)setWindowsMenu:(id)arg1;
- (id)supplementalTargetForAction:(SEL)arg1 sender:(id)arg2;
- (void)terminate:(id)arg1;
- (void)updateWindowsItem:(id)arg1;

@end

