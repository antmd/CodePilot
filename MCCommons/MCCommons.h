//
//  MCCommons.h
//  Macoscope Commons Library
//
//  Created by Daniel on 08-11-03.
//  Copyright 2008 Macosope. All rights reserved.
//

#import "MCLog.h"
#import "NSString+MiscExtensions.h"


#ifndef NSNotFoundRange
#  define NSNotFoundRange       ((NSRange) {.location = NSNotFound, .length = 0UL})
#endif

static inline BOOL IsEmpty(id thing) {
  return thing == nil
  || ([NSNull null]==thing)
  || ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0)
  || ([thing respondsToSelector:@selector(count)] && [(NSArray *)thing count] == 0);
}

#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_10

static inline NSColor *labelColor() { return [NSColor labelColor]; }
static inline NSColor *secondaryLabelColor() { return [NSColor secondaryLabelColor]; }
static inline NSColor *tertiaryLabelColor() { return [NSColor tertiaryLabelColor]; }
static inline NSColor *quaternaryLabelColor() { return [NSColor quaternaryLabelColor]; }
#else
static inline NSColor *labelColor() { return [NSColor controlColor]; }
static inline NSColor *secondaryLabelColor() { return [NSColor selectedControlColor]; }
static inline NSColor *tertiaryLabelColor() { return [NSColor lightGray]; }
static inline NSColor *quaternaryLabelColor() { return [NSColor darkGray]; }
#endif
