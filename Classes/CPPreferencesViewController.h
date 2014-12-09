//
//  CPPreferencesViewController.h
//  CodePilot
//
//  Created by Anthony Dervish on 07/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GWShortcutRecorder.h"


@interface CPPreferencesViewController : NSViewController <GWShortcutRecorderDelegate>
@property (readonly,nonatomic) NSAttributedString *hyperlink;
@property (readonly,nonatomic) NSString *productVersion;
@property (unsafe_unretained) IBOutlet GWShortcutRecorder *switcherModeKeyboardShortcutRecorder;
@end
