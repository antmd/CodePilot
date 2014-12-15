//
//  IDEWorkspaceDocument+CodePilot.h
//  CodePilot
//
//  Created by Anthony Dervish on 13/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPXcodeInterfaces.h"
#import "CPUniqueStack.h"

@interface IDEWorkspaceDocument(CodePilot)
-(CPUniqueStack*)cp_recentsStack;
@end
