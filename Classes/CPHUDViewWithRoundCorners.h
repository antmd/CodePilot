//
//  HUDViewWithRoundCorners.h
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 3/11/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CPHUDViewWithRoundCorners
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_10
: NSVisualEffectView
#else
: NSView
#endif
@property (nonatomic, assign) NSUInteger cornerRadius;
@property (nonatomic, strong) NSColor *backgroundColor;
@end
