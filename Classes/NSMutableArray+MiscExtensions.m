//
//  NSMutableArray+MiscExtensions.m
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 2/9/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import "NSArray+MiscExtensions.h"
#import "NSMutableArray+MiscExtensions.h"
#import "NSString+Abbreviation.h"
#import <objc/runtime.h>

static void *STACK_CAPACITY_KEY = &STACK_CAPACITY_KEY;

@implementation NSMutableArray (MiscExtensions)
// filters entries not matching to the query
// and returns score table for what's left
- (NSArray *)arrayFilteredAndScoredWithFuzzyQuery:(NSString *)query forKey:(NSString *)key
{
	NSMutableArray *scores = [[self arrayScoresWithFuzzyQuery:query forKey:key] mutableCopy];
	NSMutableIndexSet *indexesToRemove = [NSMutableIndexSet new];
  
	for (NSInteger i = 0; i < [self count]; i++) {
		if ([NSNull null] == [scores objectAtIndex:i]) {
			[indexesToRemove addIndex:i];
		}
	}
  
	[self removeObjectsAtIndexes:indexesToRemove];
	[scores removeObjectsAtIndexes:indexesToRemove];
  
	return scores;
}

// simpler/faster implementation when you don't need scoring
- (void)filterWithFuzzyQuery:(NSString *)query forKey:(NSString *)key
{
	NSMutableIndexSet *indexesToRemove = [NSMutableIndexSet new];
  
	for (NSInteger i = 0; i < [self count]; i++) {
		id obj = [self objectAtIndex:i];
		if (![[obj valueForKey:key] matchesFuzzyQuery:query]) {
			[indexesToRemove addIndex:i];
		}
	}
  
	[self removeObjectsAtIndexes:indexesToRemove];
}

+(instancetype)uniqueStackWithMaxCount:(NSUInteger)maxCount
{
  id stack = [[self alloc] initWithCapacity:maxCount];
  // WARNING: This will not be copied along with copying the underlying array -- Quick and very dirty
  objc_setAssociatedObject(stack, STACK_CAPACITY_KEY, @(maxCount?:UINT_MAX), OBJC_ASSOCIATION_COPY);
  return stack;
}

-(void)push:(id)object
{
  [self removeObject:object];
  [self insertObject:object atIndex:0];
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