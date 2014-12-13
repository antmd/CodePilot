//
//  IDEWorkspaceTabController+CodePilot.h
//  CodePilot
//
//  Created by Anthony Dervish on 13/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPXcodeInterfaces.h"

@interface IDEWorkspaceTabController (CodePilot)
- (void)cp_addEditor;
- (void)cp_addEditorVertically;
- (void)cp_addEditorHorizontally;
- (void)cp_removeAssistantEditor;
- (void)cp_closeOtherEditors;
- (void)cp_closeCurrentEditor;
@property(nonatomic) int assistantEditorsLayout;
@end
