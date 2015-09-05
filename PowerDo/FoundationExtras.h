//
//  FoundationExtras.h
//  PowerDo
//
//  Created by XU SHIYAN on 9/5/15.
//  Copyright © 2015 xushiyan. All rights reserved.
//

#ifndef FoundationExtras_h
#define FoundationExtras_h


#endif /* FoundationExtras_h */

#define DECLARE_DEFAULT_SINGLETON_FOR_CLASS(classname)	\
\
@interface classname (DefaultSingleton)					\
+ (instancetype) defaultInstance;							\
@end


#define SYNTHESIZE_DEFAULT_SINGLETON_FOR_CLASS(classname) \
\
@implementation classname (DefaultSingleton) \
\
+ (instancetype)defaultInstance { \
static classname *classInstance = nil; \
static dispatch_once_t classInstanceDispatch = 0; \
dispatch_once(&classInstanceDispatch, ^{    \
classInstance = [self new]; \
}); \
\
return classInstance; \
} \
@end
