//
//  SearchField.h
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 2/27/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CPStatusLabel, CPSearchFieldTextView, CPResult;

@interface CPSearchField : NSSearchField
@property (nonatomic, strong)	CPStatusLabel *placeholderTextField;
@property (copy,nonatomic) NSString *label; // The 'token field' on the left

- (BOOL)spaceKeyDown;
- (void)reset;
- (BOOL)cmdBackspaceKeyDown;
- (void)pasteString:(NSString *)str;
@end


