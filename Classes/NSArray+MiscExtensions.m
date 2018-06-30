//
//  NSArray+MiscExtensions.m
//  CodePilot
//
//  Created by Zbigniew Sobiecki on 2/9/10.
//  Copyright 2010 Macoscope. All rights reserved.
//

#import "NSArray+MiscExtensions.h"
#import "NSString+Abbreviation.h"

@implementation NSArray (MiscExtensions)

- (NSArray*) cp_filter:(BOOL (^)(id elt) )filterBlock
{
    if ( self.count == 0 || filterBlock == NULL ) {
        return self ;
    }
    id  filteredArray = [ NSMutableArray array ] ;
    for ( id elt in self ) {
        if ( filterBlock( elt ) ) { [ filteredArray addObject:elt ] ; }
    }
    
    return filteredArray ;
}

- (NSArray *)arrayScoresWithFuzzyQuery:(NSString *)query forKey:(NSString *)key
{
    NSMutableArray *scores = [NSMutableArray new];
    
    for (id obj in self) {
        NSNumber *score = [[obj valueForKey:key] scoreForQuery:query];
        
        [scores addObject:score ?: [NSNull null]];
    }
    
    return scores;
}

- (NSArray *)arrayWithoutElementsHavingNilOrEmptyValueForKey:(NSString *)key
{
    NSMutableIndexSet *selectedIndexes = [NSMutableIndexSet new];
    
    for (NSUInteger i = 0; i < [self count]; i++) {
        id obj = [self objectAtIndex:i];
        
        if (!IsEmpty([obj valueForKey:key])) {
            [selectedIndexes addIndex:i];
        }
    }
    
    return [self objectsAtIndexes:selectedIndexes];
}
@end
