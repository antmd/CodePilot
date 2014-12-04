//
//  HUDViewWithRoundCorners.m
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 3/11/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import "CPHUDViewWithRoundCorners.h"
#import "NSView+RoundedFrame.h"

@implementation CPHUDViewWithRoundCorners
-(instancetype)initWithFrame:(NSRect)frameRect
{
  self = [super initWithFrame:frameRect];
  if (self != nil) {
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_10
    self.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
    __typeof(self) __weak weakSelf = self;
    self.maskImage = [NSImage imageWithSize:frameRect.size
                                    flipped:NO
                        drawingHandler:^BOOL(NSRect dstRect) {
                          __typeof(self) this = weakSelf;
                          NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:frameRect
                                                                               xRadius:this.cornerRadius
                                                                               yRadius:this.cornerRadius];
                          [NSColor.blackColor setFill];
                          [path fill];
                          return YES;
                        }];
#endif
    
  }
  return self;
}

#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_10
- (void)drawRect:(NSRect)rect
{
	[[NSColor clearColor] setFill];
	NSRectFill(self.frame);
  
	[NSView drawRoundedFrame:self.frame
								withRadius:self.cornerRadius
				 	 filledWithColor:[NSColor windowBackgroundColor]];
}
#endif

- (BOOL)isOpaque
{
	return NO;
}
@end
