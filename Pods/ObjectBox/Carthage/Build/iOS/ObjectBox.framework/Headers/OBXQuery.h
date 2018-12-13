//  Copyright © 2018 ObjectBox. All rights reserved.

#import <Foundation/Foundation.h>
#import "Constants.h"

@class OBXProperty;
@class OBXPropertyQuery;

NS_ASSUME_NONNULL_BEGIN

// Core interface to run and modify queries. Is wrapped in a Swift Query to expose a much sexier native API.
//
// - You obtain OBXQuery instances from a OBXBox. (See the OBXBox+Query extension.)
// - OBXPropertyQuery can be modified to change query conditions.
NS_REFINED_FOR_SWIFT
@interface OBXQuery : NSObject

- (instancetype)init __attribute((unavailable));

- (NSArray *)find;
- (NSArray *)findWithOffset:(uint64_t)offset;
- (NSArray *)findWithOffset:(uint64_t)offset andLimit:(uint64_t)limit;
- (nullable id)findFirst;
- (nonnull id)findUniqueAndReturnError:(NSError **)error __attribute((swift_error(nonnull_error))) NS_SWIFT_NAME(findUnique());
- (uint64_t)count;

- (OBXPropertyQuery *)property:(OBXProperty *)property;

- (void)setParametersForProperty:(OBXProperty *)property numbers:(NSArray<NSNumber *> *)collection NS_SWIFT_NAME(setParameters(property:to:));
- (void)setParametersForPropertyWithAlias:(OBXPropertyAlias *)alias longs:(const int64_t *)values length:(uint64_t)length;
- (void)setParametersForPropertyWithAlias:(OBXPropertyAlias *)alias ints:(const int32_t *)values length:(uint64_t)length;

- (void)setParameterForProperty:(OBXProperty *)property longValue:(int64_t)value NS_SWIFT_NAME(setParameter(property:to:));
- (void)setParameterForPropertyWithAlias:(OBXPropertyAlias *)alias longValue:(int64_t)value NS_SWIFT_NAME(setParameter(alias:to:));
- (void)setParametersForProperty:(OBXProperty *)property firstLongValue:(int64_t)value1 secondLongValue:(int64_t)value2 NS_SWIFT_NAME(setParameters(property:to:_:));
- (void)setParametersForPropertyWithAlias:(OBXPropertyAlias *)alias firstLongValue:(int64_t)value1 secondLongValue:(int64_t)value2 NS_SWIFT_NAME(setParameters(alias:to:_:));

- (void)setParameterForProperty:(OBXProperty *)property doubleValue:(double)value NS_SWIFT_NAME(setParameter(property:to:));
- (void)setParameterForPropertyWithAlias:(OBXPropertyAlias *)alias doubleValue:(double)value NS_SWIFT_NAME(setParameter(alias:to:));
- (void)setParametersForProperty:(OBXProperty *)property firstDoubleValue:(double)value1 secondDoubleValue:(double)value2 NS_SWIFT_NAME(setParameters(property:to:_:));
- (void)setParametersForPropertyWithAlias:(OBXPropertyAlias *)alias firstDoubleValue:(double)value1 secondDoubleValue:(double)value2 NS_SWIFT_NAME(setParameters(alias:to:_:));

- (void)setParameterForProperty:(OBXProperty *)property stringValue:(NSString *)value NS_SWIFT_NAME(setParameter(property:to:));
- (void)setParameterForPropertyWithAlias:(OBXPropertyAlias *)alias stringValue:(NSString *)value NS_SWIFT_NAME(setParameter(alias:to:));
- (void)setParametersForProperty:(OBXProperty *)property strings:(NSArray<NSString *> *)collection NS_SWIFT_NAME(setParameters(property:to:));
- (void)setParametersForPropertyWithAlias:(OBXPropertyAlias *)alias strings:(NSArray<NSString *> *)collection NS_SWIFT_NAME(setParameters(alias:to:));

@end
NS_ASSUME_NONNULL_END
