//
//  SearchWindow.h
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 2/14/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CPWindow : NSWindow

- (id)initWithDefaultSettings;
- (NSScreen *)destinationScreen;
@end