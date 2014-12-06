//
//  CPResultController.h
//  CodePilot
//
//  Created by Anthony Dervish on 06/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//


@protocol CPResultController <NSObject>
-(void)selectNextResult:(id)sender;
-(void)selectPreviousResult:(id)sender;
-(void)selectResultPageDown:(id)sender;
-(void)selectResultPageUp:(id)sender;
-(void)performDefaultAction:(id)sender;
@end