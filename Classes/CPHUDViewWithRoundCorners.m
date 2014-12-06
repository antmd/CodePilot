//
//  HUDViewWithRoundCorners.m
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 3/11/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import "CPHUDViewWithRoundCorners.h"


@implementation CPHUDViewWithRoundCorners

#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_10
static NSImage *hudCornersImage = nil;
static NSString * const CPHudMaskImageName = @"HudMaskImage";
+ (void)initialize
{
  if (self == [CPHUDViewWithRoundCorners class]) {
    NSURL *imgURL = [[NSBundle bundleForClass:self] URLForImageResource:@"hudmask"];
    hudCornersImage = [[NSImage alloc] initWithContentsOfURL:imgURL];
    hudCornersImage.size = NSMakeSize(23.0, 23.0);
    [hudCornersImage setName:CPHudMaskImageName];
    hudCornersImage.capInsets = NSEdgeInsetsMake(11.0, 11.0, 11.0, 11.0);
  }
}
-(void)_setup
{
    self.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
    self.maskImage = [NSImage imageNamed:CPHudMaskImageName];
}
#else
-(void)_setup {;}
#endif

-(instancetype)initWithFrame:(NSRect)frameRect
{
  self = [super initWithFrame:frameRect];
  if (self != nil) {
    [self _setup];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self _setup];
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
- (BOOL)isOpaque { return NO; }
#endif

-(BOOL)acceptsFirstResponder
{
  return NO;
}


@end
