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
    self.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
    
  }
  return self;
}

- (void)drawRect:(NSRect)rect
{
	[[NSColor clearColor] setFill];
	NSRectFill(self.frame);
  
	[NSView drawRoundedFrame:self.frame
								withRadius:self.cornerRadius
				 	 filledWithColor:[NSColor windowBackgroundColor]];
}

- (BOOL)isOpaque
{
	return NO;
}
@end
