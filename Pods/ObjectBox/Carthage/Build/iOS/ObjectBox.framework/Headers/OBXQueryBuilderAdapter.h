//  Copyright © 2018 ObjectBox. All rights reserved.

#import <Foundation/Foundation.h>

@class OBXQuery;
@class OBXProperty;
@class OBXQueryCondition;
@class OBXPropertyQueryCondition;

NS_ASSUME_NONNULL_BEGIN
NS_REFINED_FOR_SWIFT
@interface OBXQueryBuilderAdapter : NSObject

- (instancetype)init __attribute((unavailable));

- (OBXQuery *)build;

- (OBXQueryCondition *)andConditions:(NSArray<OBXQueryCondition * >*)conditions NS_SWIFT_NAME(and(_:));
- (OBXQueryCondition *)orConditions:(NSArray<OBXQueryCondition *> *)conditions NS_SWIFT_NAME(or(_:));

- (OBXPropertyQueryCondition *)wherePropertyIsNull:(OBXProperty *)property NS_SWIFT_NAME(wherePropertyIsNull(_:));
- (OBXPropertyQueryCondition *)wherePropertyIsNotNull:(OBXProperty *)property NS_SWIFT_NAME(wherePropertyIsNotNull(_:));

- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isEqualToInteger:(int)integer NS_SWIFT_NAME(where(property:isEqualTo:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isNotEqualToInteger:(int)integer NS_SWIFT_NAME(where(property:isNotEqualTo:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isLessThanInteger:(int)integer NS_SWIFT_NAME(where(property:isLessThan:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isGreaterThanInteger:(int)integer NS_SWIFT_NAME(where(property:isGreaterThan:));
/**
 Matches all property values between @p lowerBound and @p upperBound,
 including the bounds themselves. The order of the bounds does not matter.

 @param property Entity property to compare values of.
 @param lowerBound Lower limiting value, inclusive.
 @param upperBound Upper limiting value, inclusive.
 @return Same @p OBXQueryBuilder instance after the changes.
 */
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isBetweenInteger:(int)lowerBound andInteger:(int)upperBound NS_SWIFT_NAME(where(property:isBetween:and:));

- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isEqualToLong:(int64_t)integer NS_SWIFT_NAME(where(property:isEqualTo:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isNotEqualToLong:(int64_t)integer NS_SWIFT_NAME(where(property:isNotEqualTo:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isLessThanLong:(int64_t)integer NS_SWIFT_NAME(where(property:isLessThan:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isGreaterThanLong:(int64_t)integer NS_SWIFT_NAME(where(property:isGreaterThan:));
/**
 Matches all property values between @p lowerBound and @p upperBound,
 including the bounds themselves. The order of the bounds does not matter.

 @param property Entity property to compare values of.
 @param lowerBound Lower limiting value, inclusive.
 @param upperBound Upper limiting value, inclusive.
 @return Same @p OBXQueryBuilder instance after the changes.
 */
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isBetweenLong:(int64_t)lowerBound andLong:(int64_t)upperBound NS_SWIFT_NAME(where(property:isBetween:and:));

- (OBXPropertyQueryCondition *)where:(OBXProperty *)property integerIsContainedIn:(NSArray<NSNumber *> *)collection NS_SWIFT_NAME(where(property:isContainedIn:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property integerIsNotContainedIn:(NSArray<NSNumber *> *)collection NS_SWIFT_NAME(where(property:isNotContainedIn:));

- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isEqualToDouble:(double)aDouble withTolerance:(double)tolerance NS_SWIFT_NAME(where(property:isEqualTo:tolerance:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isLessThanDouble:(double)aDouble NS_SWIFT_NAME(where(property:isLessThan:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isGreaterThanDouble:(double)aDouble NS_SWIFT_NAME(where(property:isGreaterThan:));
/**
 Matches all property values between @p lowerBound and @p upperBound,
 including the bounds themselves. The order of the bounds does not matter.

 @param property Entity property to compare values of.
 @param lowerBound Lower limiting value, inclusive.
 @param upperBound Upper limiting value, inclusive.
 @return Same @p OBXQueryBuilder instance after the changes.
 */
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isBetweenDouble:(double)lowerBound andDouble:(double)upperBound NS_SWIFT_NAME(where(property:isBetween:and:));

- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isEqualToString:(NSString *)string caseSensitiveCompare:(BOOL)caseSensitive NS_SWIFT_NAME(where(property:isEqualTo:caseSensitive:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isNotEqualToString:(NSString *)string caseSensitiveCompare:(BOOL)caseSensitive NS_SWIFT_NAME(where(property:isNotEqualTo:caseSensitive:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isLessThanString:(NSString *)string caseSensitiveCompare:(BOOL)caseSensitive NS_SWIFT_NAME(where(property:isLessThan:caseSensitive:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isGreaterThanString:(NSString *)string caseSensitiveCompare:(BOOL)caseSensitive NS_SWIFT_NAME(where(property:isGreaterThan:caseSensitive:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property stringIsContainedIn:(NSArray<NSString *> *)collection caseSensitiveCompare:(BOOL)caseSensitive NS_SWIFT_NAME(where(property:isContainedIn:caseSensitive:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property startsWith:(NSString *)prefix caseSensitiveCompare:(BOOL)caseSensitive NS_SWIFT_NAME(where(property:startsWith:caseSensitive:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property endsWith:(NSString *)suffix caseSensitiveCompare:(BOOL)caseSensitive NS_SWIFT_NAME(where(property:endsWith:caseSensitive:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property contains:(NSString *)substring caseSensitiveCompare:(BOOL)caseSensitive NS_SWIFT_NAME(where(property:contains:caseSensitive:));

- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isEqualToDate:(NSDate *)date NS_SWIFT_NAME(where(property:isEqualTo:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isNotEqualToDate:(NSDate *)date NS_SWIFT_NAME(where(property:isNotEqualTo:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isBeforeDate:(NSDate *)date NS_SWIFT_NAME(where(property:isBefore:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isAfterDate:(NSDate *)date NS_SWIFT_NAME(where(property:isAfter:));
/**
 Matches all property values between @p lowerBound and @p upperBound,
 including the bounds themselves. The order of the bounds does not matter.

 @param property Entity property to compare values of.
 @param lowerBound Lower limiting value, inclusive.
 @param upperBound Upper limiting value, inclusive.
 @return Same @p OBXQueryBuilder instance after the changes.
 */
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property isBetweenDate:(NSDate *)lowerBound andDate:(NSDate *)upperBound NS_SWIFT_NAME(where(property:isBetween:and:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property dateIsContainedIn:(NSArray<NSDate *> *)collection NS_SWIFT_NAME(where(property:isContainedIn:));
- (OBXPropertyQueryCondition *)where:(OBXProperty *)property dateIsNotContainedIn:(NSArray<NSDate *> *)collection NS_SWIFT_NAME(where(property:isNotContainedIn:));

@end
NS_ASSUME_NONNULL_END
