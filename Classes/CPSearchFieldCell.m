//
//  CPSearchFieldCell.m
//  CodePilot
//
//  Created by Anthony Dervish on 06/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//

#import "CPSearchFieldCell.h"

@implementation CPSearchFieldCell


-(void)_setup
{
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self _setup];
  }
  return self;
}

-(instancetype)initTextCell:(NSString *)aString
{
  self = [super initTextCell:aString];
  if (self) {
    [self _setup];
  }
  return self;
}

-(instancetype)initImageCell:(NSImage *)image
{
  return [self initTextCell:@""];
}
- (instancetype)init
{
  return [self initTextCell:@""];
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - Properties
/*==================================================================================================
 */


-(void)setLabel:(NSString*)label
{
  if (label.length) {
    NSButtonCell *cell = [[NSButtonCell alloc] initTextCell:label];
    cell.bezelStyle = NSInlineBezelStyle;
    self.searchButtonCell = cell;
  }
  else {
    [self resetSearchButtonCell];
  }
  NSSearchField *controlView = (NSSearchField*)self.controlView;
  if (controlView.currentEditor) {
    // The current editor is embedded in a private clipview
    [controlView.subviews[0] setFrame:[self searchTextRectForBounds:controlView.bounds]];
  }
  [self.controlView setNeedsDisplay:YES];
}

-(NSString*)label
{
  return self.searchButtonCell.title ;
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - Drawing
/*==================================================================================================
 */

//
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
  
  //Adjust Rect
  cellFrame = NSInsetRect(cellFrame, 0.5f, 0.5f);
  
  //Create Path
  NSBezierPath *path = [[NSBezierPath alloc] init];
  
  if([self bezelStyle] == NSTextFieldRoundedBezel) {
    
    [path appendBezierPathWithArcWithCenter: NSMakePoint(cellFrame.origin.x + (cellFrame.size.height /2), cellFrame.origin.y + (cellFrame.size.height /2))
                                     radius: cellFrame.size.height /2
                                 startAngle: 90
                                   endAngle: 270];
    
    [path appendBezierPathWithArcWithCenter: NSMakePoint(cellFrame.origin.x + (cellFrame.size.width - (cellFrame.size.height /2)), cellFrame.origin.y + (cellFrame.size.height /2))
                                     radius: cellFrame.size.height /2
                                 startAngle: 270
                                   endAngle: 90];
    
    [path closePath];
  } else {
    
    [path appendBezierPathWithRoundedRect: cellFrame xRadius: 3.0f yRadius: 3.0f];
  }
  [NSColor controlBackgroundColor];
  [path fill];
  if([self isBezeled] || [self isBordered]) {
    
    [NSGraphicsContext saveGraphicsState];
    
    if([super showsFirstResponder] && [[[self controlView] window] isKeyWindow] &&
       ([self focusRingType] == NSFocusRingTypeDefault ||
        [self focusRingType] == NSFocusRingTypeExterior)) {
         
         [NSGraphicsContext saveGraphicsState];
         NSSetFocusRingStyle(NSFocusRingOnly);
         NSRectFill(cellFrame);
         [NSGraphicsContext restoreGraphicsState];
       }
    
    //Check State
    if([self isEnabled]) {
      
      [NSColor.whiteColor set];
    } else {
      
      [NSColor.grayColor set];
    }
    
    [path setLineWidth: 1.0f];
    [path stroke];
    
    [NSGraphicsContext restoreGraphicsState];
  }
  
  NSTextView* view = (NSTextView*)[[controlView window] fieldEditor: NO forObject: controlView];
  
  //Get Attributes of the selected text
  NSMutableDictionary *dict = [[view selectedTextAttributes] mutableCopy] ;
  
  //If window/app is active draw the highlight/text in active colors
  if([self showsFirstResponder] && [[[self controlView] window] isKeyWindow])
  {
    [dict setObject: [NSColor selectedTextBackgroundColor]
             forKey: NSBackgroundColorAttributeName];
    
    [view setTextColor: [NSColor selectedTextColor]
                 range: [view selectedRange]];
  }
  else
  {
    [dict setObject: [[NSColor selectedTextBackgroundColor] colorWithAlphaComponent:0.5]
             forKey: NSBackgroundColorAttributeName];
    
    [view setTextColor: [[NSColor selectedTextColor] colorWithAlphaComponent:0.5]
                 range: [view selectedRange]];
  }
  
  [view setSelectedTextAttributes:dict];
  
  if([self isEnabled]) {
    
    [self setTextColor:[NSColor textColor]];
  } else {
    
    [self setTextColor:[NSColor disabledControlTextColor]];
  }
  
  if(![self placeholderAttributedString] && [self placeholderString]) {
    
    //Nope lets create it
    NSDictionary *attribs = @{ NSForegroundColorAttributeName: [NSColor disabledControlTextColor]
                               , NSFontAttributeName: self.font
                               };
    
    
    //Set it
    [self setPlaceholderAttributedString: [[NSAttributedString alloc] initWithString:[self placeholderString] attributes:attribs ]] ;
  }
  
  //Adjust Frame so Text Draws correctly
  switch ([self controlSize]) {
      
    case NSSmallControlSize:
      
      cellFrame.origin.y += 1;
      break;
      
    case NSMiniControlSize:
      
      cellFrame.origin.y += 1;
      
    default:
      break;
  }
  
  [self drawInteriorWithFrame: cellFrame inView: controlView];
}



// This adjusts the drawing location of the Cancel Button
-(NSRect)cancelButtonRectForBounds:(NSRect) aRect {
  
  NSRect nRect = [super cancelButtonRectForBounds: aRect];
  
  switch ([self controlSize]) {
      
    case NSRegularControlSize:
      
      nRect.origin.y -= 1;
      break;
      
    case NSSmallControlSize:
      
      nRect.origin.y -= 1.5;
      nRect.origin.x += 2;
      break;
      
    case NSMiniControlSize:
      
      nRect.origin.y -= 2;
      break;
      
    default:
      break;
  }
  
  return nRect;
}

// Set insertion point to white
-(NSText *)setUpFieldEditorAttributes:(NSText *) textObj
{
  textObj = [super setUpFieldEditorAttributes:textObj];
  if([textObj isKindOfClass:[NSTextView class]]) {
    [(NSTextView *)textObj setInsertionPointColor:[self textColor]];
  }
  return textObj;
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - Geometry
/*==================================================================================================
 */


- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent
{
  [self _adjustRectForButtons:&aRect inView:controlView];
  [super editWithFrame: aRect inView: controlView editor: textObj delegate: anObject event: theEvent];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength
{
  [self _adjustRectForButtons:&aRect inView:controlView];
  [super selectWithFrame: aRect inView: controlView editor: textObj delegate: anObject start: selStart length: selLength];
}

-(NSRect)searchTextRectForBounds:(NSRect)rect
{
  [self _adjustRectForButtons:&rect inView:self.controlView];
  // Not sure why, but we need to adjust here
  rect.origin.x += 5.0;
  rect.origin.y -= 2.0;
  return rect;
}

-(NSRect)searchButtonRectForBounds:(NSRect)rect
{
  NSSize cellSize = [(NSCell*)self.searchButtonCell cellSizeForBounds:self.controlView.bounds];
  CGFloat yPos = (NSHeight(self.controlView.bounds)-cellSize.height)/2.0;
  return NSMakeRect(0.0,yPos,cellSize.width,cellSize.height);
}

/*
 *
 *
 *================================================================================================*/
#pragma mark - Utilities
/*==================================================================================================
 */

-(void)_adjustRectForButtons:(NSRectPointer)rectPtr inView:(NSView*)controlView
{
  NSRect searchButtonRect = [self searchButtonRectForBounds:controlView.bounds];
  NSRect cancelButtonRect = [self cancelButtonRectForBounds:controlView.bounds];
  rectPtr->origin.x = searchButtonRect.origin.x + searchButtonRect.size.width + 3.0;
  rectPtr->size.width = controlView.bounds.size.width - rectPtr->origin.x - cancelButtonRect.size.width - 3.0;
}

@end
