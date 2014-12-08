//
//  SearchField.m
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 2/27/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import "CPSearchField.h"
#import "CPCodePilotConfig.h"
#import "CPSearchFieldDelegate.h"
#import "CPStatusLabel.h"
#import "CPSymbol.h"
#import "CPSearchFieldTextView.h"
#import "CPResultController.h"
#import "CPSearchFieldCell.h"

@implementation CPSearchField

-(void)_setup
{
  self.bezeled = NO;
  [self setDrawsBackground:NO];
  [self setContinuous:YES];
  [self setFocusRingType:NSFocusRingTypeNone];
  self.placeholderString = SEARCHFIELD_PLACEHOLDER_STRING;
  
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

/*
 *
 *
 *================================================================================================*/
#pragma mark - Properties
/*==================================================================================================
 */

-(NSString *)label
{
  return ((CPSearchFieldCell*)self.cell).label;
}

-(void)setLabel:(NSString *)label
{
  ((CPSearchFieldCell*)self.cell).label = label;
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - TextView Delegate
/*==================================================================================================
 */

- (BOOL)textView:(NSTextView*)aTextView doCommandBySelector:(SEL)commandSelector
{
  
  if ((commandSelector == @selector(complete:))
      || (commandSelector == @selector(cancelOperation:))
      || (commandSelector == @selector(insertTab:))
      ) // ESCAPE or TAB
  {
    
    [self sendAction:@selector(performClose:) to:nil];
    return YES;
  } // ESCAPE
  if (commandSelector == @selector(deleteBackward:)) // BACKSPACE
  {
    if (self.stringValue.length == 0
        && [self.delegate respondsToSelector:@selector(deleteLabelForSearchField:)]) {
      return [(id<CPSearchFieldDelegate>)self.delegate deleteLabelForSearchField:self];
    }
    return NO;
  } // DOWN-ARROW
  if (commandSelector == @selector(moveDown:)) // DOWN-ARROW
  {
    [self sendAction:@selector(selectNextResult:) to:nil];
    [NSCursor setHiddenUntilMouseMoves:YES];
    return YES;
  } // DOWN-ARROW
  else if (commandSelector == @selector(moveUp:)) // UP-ARROW
  {
    [self sendAction:@selector(selectPreviousResult:) to:nil];
    [NSCursor setHiddenUntilMouseMoves:YES];
    return YES;
  } // UP-ARROW
  else if (commandSelector == @selector(scrollPageDown:)) // PAGE-DOWN
  {
    [self sendAction:@selector(selectResultPageDown:) to:nil];
    [NSCursor setHiddenUntilMouseMoves:YES];
    return YES;
  } // PAGE-DOWN
  else if (commandSelector == @selector(scrollPageUp:)) // PAGE-UP
  {
    [self sendAction:@selector(selectResultPageUp:) to:nil];
    [NSCursor setHiddenUntilMouseMoves:YES];
    return YES;
  } // PAGE-UP
  else if (commandSelector == @selector(insertNewline:)
           || commandSelector == @selector(insertNewlineIgnoringFieldEditor:)) // RETURN / ALT+RETURN
  {
    [self sendAction:@selector(performDefaultAction:) to:nil];
    
    return YES;
  }
  
  return NO;
}


-(BOOL)isFlipped { return YES; }
- (void)reset
{
  [self setStringValue:@""];
}

- (BOOL)cmdBackspaceKeyDown
{
  if (!self.label.length) {
    self.stringValue = @"";
    return YES;
  }
  else if ([self.delegate respondsToSelector:@selector(cmdBackspacePressedForSearchField:)]) {
    return [(id<CPSearchFieldDelegate>)self.delegate cmdBackspacePressedForSearchField:self];
  }
  
  
  return YES;
}

// called from SearchFieldTextView
- (BOOL)spaceKeyDown
{
  if ([self.delegate respondsToSelector:@selector(spacePressedForSearchField:)]) {
    return [(id<CPSearchFieldDelegate>)self.delegate spacePressedForSearchField:self];
  }
  
  return NO; // not handled here.
}

// programmatic setting of the search query
- (void)pasteString:(NSString *)str
{
  [(CPSearchFieldTextView *)[self currentEditor] pasteString:str];
}


// nil capable! super-power!
- (void)setStringValue:(NSString *)str
{
  [super setStringValue:str ?: @""];
}

-(void)drawRect:(NSRect)dirtyRect
{
  [super drawRect:dirtyRect];
  [labelColor() set];
  CGFloat radius = NSHeight(self.bounds) / 2.0;
  NSBezierPath * outline = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:radius yRadius:radius] ;
  [outline setClip];
  [outline stroke];
}

-(BOOL)allowsVibrancy { return YES; }
@end


