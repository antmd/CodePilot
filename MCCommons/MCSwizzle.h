//
//  MCSwizzle.h
//  CodePilot
//
//  Created by Anthony Dervish on 13/12/2014.
//  Copyright (c) 2014 Macoscope. All rights reserved.
//
#import <objc/runtime.h>

#define SWIZZLED_SELECTOR_RENAME_PREFIX CP_
#define STRINGIFY2(_str) #_str
#define STRINGIFY(_str) STRINGIFY2(_str)

#define invokeSuper(_class_name, _sel_name) \
SEL deallocSelector = sel_registerName(#_sel_name); \
  struct objc_super superInfo = { \
    .receiver = self, \
    .super_class = class_getSuperclass(NSClassFromString(@ #_class_name)) \
  }; \
  void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper; \
  msgSend(&superInfo, deallocSelector);


static inline void mc_methodSwizzle(Class fromClass, SEL swizzledSelector,
                                    Class toClass) {
  NSString *renamedName = [@STRINGIFY(SWIZZLED_SELECTOR_RENAME_PREFIX)
      stringByAppendingString:NSStringFromSelector(swizzledSelector)];
  SEL renamedSelector = NSSelectorFromString(renamedName);

  Method newMethod = class_getInstanceMethod(fromClass, renamedSelector);
  Method origMethod = class_getInstanceMethod(toClass, swizzledSelector);

  assert(newMethod != NULL && "Holder class does not contain instance method.");
  BOOL added __unused = class_addMethod(
      toClass, (origMethod ? renamedSelector : swizzledSelector),
      method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
  assert(added && "Could not add method to destination class.");
  newMethod = class_getInstanceMethod(toClass, renamedSelector);
  if (origMethod) {
    method_exchangeImplementations(origMethod, newMethod);
  }
}

IMP  dsk_impOfCallingMethod ( id lookupObject, SEL selector );
