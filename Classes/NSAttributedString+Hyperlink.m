//
//  NSAttributedString+Hyperlink.m
//  Quark
//
//  Created by Daniel on 09-12-17.
//  Copyright 2009 Macosope. All rights reserved.
//

#import "NSAttributedString+Hyperlink.h"

@implementation NSAttributedString (Hyperlink)
+ (NSAttributedString *)hyperlinkFromString:(NSString *)inString withURL:(NSURL *)aURL
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:inString];
    NSRange range = NSMakeRange(0, [attrString length]);
    
    [attrString beginEditing];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    
    [attrString addAttributes:@{NSLinkAttributeName: [aURL absoluteString],
                                NSToolTipAttributeName: [aURL absoluteString],
                                NSForegroundColorAttributeName: [NSColor blueColor],
                                NSUnderlineStyleAttributeName: @(NSSingleUnderlineStyle)}
                        range:range];
#pragma clang diagnostic pop
    [attrString endEditing];
    
    return attrString;
}
@end
