//
//  IDEEditor+CodePilot.m
//  CodePilot
//
//  Created by Ant on 14/08/2015.
//  Copyright © 2015 Macoscope. All rights reserved.
//

#import "IDEEditor+CodePilot.h"
#import "MCSwizzle.h"
#import "CPXcodeInterfaces.h"
#import "CPXcodeWrapper.h"
#import "CPCodePilotPlugin.h"
#import <objc/runtime.h>
#import <objc/message.h>

void *CPHasRegisteredDocumentObserverKey = @"CPHasRegisteredDocumentObserverKey";

@implementation IDEEditor_CodePilot

+ (void)load
{
    mc_methodSwizzle(IDEEditor_CodePilot.class, @selector(didSetupEditor), NSClassFromString(@"IDEEditor"));
    mc_methodSwizzle(IDEEditor_CodePilot.class, @selector(dealloc), NSClassFromString(@"IDEEditor"));
}

-(void)CP_didSetupEditor
{
    BOOL isObserving = [objc_getAssociatedObject(self, CPHasRegisteredDocumentObserverKey) boolValue];
    if (!isObserving) {
        // Observing 'document' property of IDEEditor instances allows us to track 'recent' documents
        [self addObserver:CPCodePilotPlugin.sharedInstance.xcWrapper
               forKeyPath:@"document"
                  options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew)
                  context:(void*)self];
        objc_setAssociatedObject(self, CPHasRegisteredDocumentObserverKey, @YES, OBJC_ASSOCIATION_COPY);
    }
    
    [self CP_didSetupEditor];
}

-(void)CP_dealloc
{
    BOOL isObserving = [objc_getAssociatedObject(self, CPHasRegisteredDocumentObserverKey) boolValue];
    if (isObserving) {
        [self removeObserver:CPCodePilotPlugin.sharedInstance.xcWrapper
                  forKeyPath:@"document"];
    }
    invokeSuper(IDEEditor_CodePilot, dealloc);
}

@end
