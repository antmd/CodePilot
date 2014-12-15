//
//  IDEWorkspaceDocument+CodePilot.m
//  CodePilot
//
//  Created by Anthony Dervish on 13/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//

#import "IDEWorkspaceDocument+CodePilot.h"
#import "CPUniqueStack.h"
#import <objc/runtime.h>

static void *RECENTS_STACK_KEY = &RECENTS_STACK_KEY;

@implementation IDEWorkspaceDocument(CodePilot)

-(CPUniqueStack*)cp_recentsStack
{
  CPUniqueStack *recentsStack = objc_getAssociatedObject(self, RECENTS_STACK_KEY);
  if (!recentsStack) {
    recentsStack = [CPUniqueStack uniqueStackWithMaxCount:100];
    objc_setAssociatedObject(self, RECENTS_STACK_KEY, recentsStack, OBJC_ASSOCIATION_RETAIN);
  }
  return recentsStack;
  
}
@end
