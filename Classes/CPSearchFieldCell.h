//
//  CPSearchFieldCell.h
//  CodePilot
//
//  Created by Anthony Dervish on 06/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CPSearchFieldCell : NSSearchFieldCell
@property (copy,nonatomic) NSString *label; // The 'token field' on the left

@end
