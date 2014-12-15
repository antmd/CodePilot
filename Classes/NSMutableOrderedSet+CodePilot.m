//
//  NSMutableOrderedSet+CodePilot.m
//  CodePilot
//
//  Created by Anthony Dervish on 15/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//

#import "NSMutableOrderedSet+CodePilot.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

static void *STACK_CAPACITY_KEY = &STACK_CAPACITY_KEY;

@implementation NSMutableOrderedSet(CodePilot)

+(instancetype)uniqueStackWithMaxCount:(NSUInteger)maxCount
{
  id stack = [[self alloc] initWithCapacity:maxCount];
  // WARNING: This will not be copied along with copying the underlying array -- Quick and very dirty
  objc_setAssociatedObject(stack, STACK_CAPACITY_KEY, @(maxCount?:UINT_MAX), OBJC_ASSOCIATION_COPY);
  return stack;
}

-(void)push:(id)object
{
  if (!object) {return;}
  [self removeObject:object];
  [self insertObject:object atIndex:0];
  NSNumber *maxCount = objc_getAssociatedObject(self, STACK_CAPACITY_KEY);
  if (maxCount && self.count > maxCount.unsignedIntegerValue) {
    [self removeObjectsInRange:NSMakeRange(maxCount.unsignedIntegerValue, self.count-maxCount.unsignedIntegerValue)];
  }
}

-(void)pushMany:(NSArray *)array
{
  if (!array.count) { return; }
  [self removeObjectsInArray:array];
  [self insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
  NSNumber *maxCount = objc_getAssociatedObject(self, STACK_CAPACITY_KEY);
  if (maxCount && self.count > maxCount.unsignedIntegerValue) {
    [self removeObjectsInRange:NSMakeRange(maxCount.unsignedIntegerValue, self.count-maxCount.unsignedIntegerValue)];
  }
}

-(id)pop
{
  id obj = nil;
  if (self.count) {
    obj = [self objectAtIndex:0];
    [self removeObjectAtIndex:0];
  }
  return obj;
}
@end
