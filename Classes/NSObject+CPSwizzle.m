//
//  NSObject+CPSwizzle.m
//  CodePilot
//
//  Created by Anthony Dervish on 13/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//

#import "NSObject+CPSwizzle.h"
#import "MCSwizzle.h"

@implementation NSObject(CPSwizzle)

+(void)cp_swizzleIn:(SEL)selector toClass:(Class)toClass
{
  mc_methodSwizzle(self, selector, toClass);
  
}
@end
