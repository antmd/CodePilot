//
//  CPResultsView.m
//  CodePilot
//
//  Created by Ant on 01/07/2018.
//  Copyright © 2018 Macoscope. All rights reserved.
//

#import "CPResultsView.h"

@implementation CPResultsView

static NSImage *hudCornersImage = nil;
static NSString * const CPHudMaskImageName = @"HudMaskImage";
+ (void)initialize
{
    if (self == [CPResultsView class]) {
        NSURL *imgURL = [[NSBundle bundleForClass:self] URLForImageResource:@"hudmask"];
        hudCornersImage = [[NSImage alloc] initWithContentsOfURL:imgURL];
        hudCornersImage.size = NSMakeSize(23.0, 23.0);
        [hudCornersImage setName:CPHudMaskImageName];
        hudCornersImage.capInsets = NSEdgeInsetsMake(11.0, 11.0, 11.0, 11.0);
    }
}


-(void)_setup
{
    self.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    self.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
    self.state = NSVisualEffectStateActive;
    self.maskImage = [NSImage imageNamed:CPHudMaskImageName];
}

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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

-(BOOL)isOpaque {
    return NO;
}

@end
