//
//  StatusLabel.h
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 2/20/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CPStatusLabel : NSTextField
@property (nonatomic, strong) NSURL *clickUrl;
@property (nonatomic) BOOL isInactive;

- (CGFloat)textWidth;
@end
