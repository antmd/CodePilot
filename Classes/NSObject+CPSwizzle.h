//
//  NSObject+CPSwizzle.h
//  CodePilot
//
//  Created by Anthony Dervish on 13/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(CPSwizzle)
+(void)cp_swizzleIn:(SEL)selector toClass:(Class)toClass;
@end
