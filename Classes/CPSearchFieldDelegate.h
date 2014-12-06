//
//  CPSearchFieldDelegate.h
//  CodePilot
//
//  Created by Anthony Dervish on 06/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//

@class CPSearchField;

@protocol CPSearchFieldDelegate <NSObject>
@optional
- (BOOL)spacePressedForSearchField:(CPSearchField *)searchField;
- (BOOL)cmdBackspacePressedForSearchField:(CPSearchField *)searchField;
- (BOOL)deleteLabelForSearchField:(CPSearchField*)searchField;
@end
