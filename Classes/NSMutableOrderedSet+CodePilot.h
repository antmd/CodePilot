//
//  NSMutableOrderedSet+CodePilot.h
//  CodePilot
//
//  Created by Anthony Dervish on 15/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableOrderedSet(CodePilot)
+(instancetype)uniqueStackWithMaxCount:(NSUInteger)maxCount;
-(void)push:(id)object; //!< Includes 'nil' check
-(void)pushMany:(NSArray *)array;
-(void)appendMany:(NSArray*)array;
-(id)pop;
@property(readonly, copy) NSArray *array;
@end

