//
//  XcodeUtils.m
//  XVim2
//
//  Created by Ant on 09/10/2017.
//  Copyright © 2017 Shuichiro Suzuki. All rights reserved.
//

#import "XcodeUtils.h"


IDEWorkspaceWindowController* XVimLastActiveWindowController()
{
  return [IDEWorkspaceWindowClass() lastActiveWorkspaceWindowController];
}

IDEWorkspaceTabController_XVim* XVimLastActiveWorkspaceTabController()
{
  return (IDEWorkspaceTabController_XVim*)[XVimLastActiveWindowController() activeWorkspaceTabController];
}

IDEEditorArea* XVimLastActiveEditorArea() { return [XVimLastActiveWindowController() editorArea]; }

_TtC22IDEPegasusSourceEditor20SourceCodeEditorView* XVimLastActiveEditorView()
{
  return (id)[[[[[[[XVimLastActiveEditorArea() lastActiveEditorContext] supplementalMainViewController] view]
                 subviews] objectAtIndex:0] subviews] objectAtIndex:0];
}


BOOL XVimOpenDocumentAtPath(NSString* path)
{
  NSError* error;
  NSURL* doc = [NSURL fileURLWithPath:path];
  DVTDocumentLocation* loc = [[DVTDocumentLocationClass() alloc] initWithDocumentURL:doc timestamp:nil];
  if (loc) {
    IDEEditorOpenSpecifier* spec = [IDEEditorOpenSpecifierClass()
                                    structureEditorOpenSpecifierForDocumentLocation:loc
                                    inWorkspace:[XVimLastActiveWindowController()
                                                 .activeWorkspaceTabController
                                                 workspace]
                                    error:&error];
    if (error == nil) {
      [XVimLastActiveEditorArea() _openEditorOpenSpecifier:spec
                                             editorContext:[XVimLastActiveEditorArea() lastActiveEditorContext]
                                                 takeFocus:YES];
    }
    else {
      return NO;
    }
  }
  else {
    return NO;
  }
  return YES;
}


IDEEditorOpenSpecifier* XVimOpenSpecifier(IDENavigableItem* item, id locationToSelect)
{
  NSError* err = nil;
  IDEEditorOpenSpecifier* spec
  = locationToSelect ? [[IDEEditorOpenSpecifierClass() alloc] initWithNavigableItem:item
                                                                   locationToSelect:locationToSelect
                                                                              error:&err]
  : [[IDEEditorOpenSpecifierClass() alloc] initWithNavigableItem:item error:&err];
  if (!spec || err != nil) {
    return nil;
  }
  return spec;
}
