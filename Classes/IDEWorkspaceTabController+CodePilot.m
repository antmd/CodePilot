//
//  IDEWorkspaceTabController+CodePilot.m
//  CodePilot
//
//  Created by Suzuki Shuichiro on 10/23/14 as part of XVim.org project.
//  Modified by Anthony Dervish on 13/12/2014.
//
//  Copyright (c) 2014 Macoscope. All rights reserved.
//

#import "IDEWorkspaceTabController+CodePilot.h"


IDEEditorOpenSpecifier* cp_openSpecifierForContext(IDEEditorContext* context);

typedef NS_ENUM(NSInteger,EditorMode) {
  STANDARD,
  GENIUS,
  VERSION
};

typedef NS_ENUM(NSInteger,GeniusLayoutMode) {
  NOT_GENIUS = -1,
  GENIUS_RV,
  GENIUS_RH,
  GENIUS_LV, /* Not used in Xcode */
  GENIUS_LH, /* Not used in Xcode */
  GENIUS_TV, /* Not used in Xcode */
  GENIUS_TH, /* Not used in Xcode */
  GENIUS_BV,
  GENIUS_BH
};

static inline BOOL cp_verticallyStackingModeForMode(GeniusLayoutMode mode) {
  return (mode % 2) == 1 ? mode - 1 : mode;
}
static inline BOOL cp_horizontallyStackingModeForMode(GeniusLayoutMode mode) {
  return (mode % 2) == 0 ? mode + 1 : mode;
}

@implementation IDEWorkspaceTabController (XVim)

-(GeniusLayoutMode)cp_currentLayout
{
  return (self.editorArea.editorMode == GENIUS) ? self.assistantEditorsLayout : NOT_GENIUS;
}

// It's not possible to get the full flexibility of Vim windows in Xcode, so we have to compromise.
// We keep horizontally stacking windows for vsplits, until a horizontal split is requested, and then
// we flip the assitant editor layout to stack vertically.
// We do the corresponding actions for splits --> vsplits
// To get more flexibility, we probably need to add new versions of split/vsplit to change the
// assistant layout as required.
- (void)cp_addEditorVertically{
  
  GeniusLayoutMode layout = [self cp_currentLayout];
  [self cp_addEditor];
  if (layout == NOT_GENIUS) {
    [self changeToAssistantLayout_RH:self];
  }
  else {
    self.assistantEditorsLayout = cp_horizontallyStackingModeForMode(layout);
  }
}

- (void)cp_addEditorHorizontally{
  GeniusLayoutMode layout = [self cp_currentLayout];
  [self cp_addEditor];
  if (layout == NOT_GENIUS) {
    [self changeToAssistantLayout_BV:self];
  }
  else {
    self.assistantEditorsLayout = cp_verticallyStackingModeForMode(layout);
  }
}


- (void)cp_addEditor{
  IDEWorkspaceTabController *workspaceTabController = self;
  IDEEditorArea *editorArea = [self editorArea];
  if ([editorArea editorMode] != GENIUS){
    [workspaceTabController changeToGeniusEditor:self];
  }else {
    [workspaceTabController addAssistantEditor:self];
  }
}


- (void)cp_closeOtherEditors{
  IDEEditorArea *editorArea = [self editorArea];
  if ([editorArea editorMode] != GENIUS){
    return;
  }
  
  
  IDEEditorGeniusMode *geniusMode = (IDEEditorGeniusMode*)[editorArea editorModeViewController];
  IDEEditorMultipleContext *multipleContext = [geniusMode alternateEditorMultipleContext];
  IDEEditorContext *primaryContext = [geniusMode primaryEditorContext];
  IDEEditorContext *selectedContext = [editorArea lastActiveEditorContext];
  if (!selectedContext.isPrimaryEditorContext) {
    IDEEditorOpenSpecifier *openSpecifier = cp_openSpecifierForContext(selectedContext);
    if (openSpecifier) {
      [primaryContext openEditorOpenSpecifier:openSpecifier];
    }
  }
  if ([multipleContext canCloseEditorContexts]){
    [multipleContext closeAllEditorContextsKeeping:[multipleContext selectedEditorContext]];
  }
  [ self changeToStandardEditor:self];
}



- (void)cp_closeCurrentEditor{
  IDEEditorArea *editorArea = [self editorArea];
  EditorMode editorMode = (EditorMode)[editorArea editorMode];
  if (editorMode == STANDARD){
    if ([self.windowController.workspaceTabControllers count]>1) {
      [self.windowController performSelector:@selector(closeCurrentTab:) withObject:nil afterDelay:0];
    }
    else {
      [self.windowController performSelector:@selector(closeTabOrWindow:) withObject:nil afterDelay:0];
    }
    return;
  }
  else if (editorMode == GENIUS) {
    IDEEditorGeniusMode *geniusMode = (IDEEditorGeniusMode*)[editorArea editorModeViewController];
    IDEEditorMultipleContext *multipleContext = [geniusMode alternateEditorMultipleContext];
    IDEEditorContext *primaryContext = [geniusMode primaryEditorContext];
    IDEEditorContext *selectedContext = [editorArea lastActiveEditorContext];
    if (selectedContext.isPrimaryEditorContext) {
      IDEEditorContext *otherContext = [multipleContext firstEditorContext];
      if (otherContext) {
        IDEEditorOpenSpecifier *openSpecifier = cp_openSpecifierForContext(otherContext);
        if (openSpecifier) {
          [primaryContext openEditorOpenSpecifier:openSpecifier];
          [otherContext takeFocus];
          [self cp_removeAssistantEditor];
          [primaryContext takeFocus];
        }
      }
    }
    else {
      [self cp_removeAssistantEditor];
    }
    
  }
}

- (void)cp_removeAssistantEditor{
  IDEEditorArea *editorArea = self.editorArea;
  IDEEditorGeniusMode *geniusMode;
  switch([editorArea editorMode]){
    case STANDARD:
      return;
      break;
    case GENIUS:
      geniusMode = (IDEEditorGeniusMode*)[editorArea editorModeViewController];
      if ([geniusMode canRemoveAssistantEditor] == NO){
        [self changeToStandardEditor:self];
      }else {
        [self removeAssistantEditor:self];
      }
      break;
    case VERSION:
      return;
      break;
  }
}

@end



IDEEditorOpenSpecifier* cp_openSpecifierForContext(IDEEditorContext* context)
{
  NSError *err = nil;
  NSArray*locations = context._currentSelectedDocumentLocations;
  IDEEditorOpenSpecifier *openSpecifier = locations.count
  ? [[IDEEditorOpenSpecifier alloc] initWithNavigableItem:context.navigableItem locationToSelect:locations.firstObject error:&err]
  : [[IDEEditorOpenSpecifier alloc] initWithNavigableItem:context.navigableItem error:&err];
  return openSpecifier;
}

