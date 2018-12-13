//  Copyright © 2018 ObjectBox. All rights reserved.

#import <Foundation/Foundation.h>

@class OBXQuery;
@class OBXProperty;
@class OBXQueryBuilderAdapter;

NS_REFINED_FOR_SWIFT
typedef NS_ENUM(NSUInteger, OBXQueryOperator) {
    OBXQueryOperatorNone,
    OBXQueryOperatorAnd,
    OBXQueryOperatorOr
};

NS_ASSUME_NONNULL_BEGIN
NS_REFINED_FOR_SWIFT
@interface OBXQueryBuilder : NSObject

@property (nonatomic, strong, readonly) OBXQueryBuilderAdapter *queryBuilderAdapter;

- (instancetype)init __attribute((unavailable));

- (OBXQuery *)build;

- (OBXQueryBuilder *)and;
- (OBXQueryBuilder *)or;

- (OBXQueryBuilder *)wherePropertyIsNull:(OBXProperty *)property NS_SWIFT_NAME(wherePropertyIsNull(_:));
- (OBXQueryBuilder *)wherePropertyIsNotNull:(OBXProperty *)property NS_SWIFT_NAME(wherePropertyIsNotNull(_:));

- (OBXQueryBuilder *)where:(OBXProperty *)property equalsInteger:(NSInteger)integer __SWIFT_UNAVAILABLE;
- (OBXQueryBuilder *)where:(OBXProperty *)property isEqualToInteger:(NSInteger)integer NS_SWIFT_NAME(where(property:isEqualTo:));
- (OBXQueryBuilder *)where:(OBXProperty *)property isNotEqualToInteger:(NSInteger)integer NS_SWIFT_NAME(where(property:isNotEqualTo:));
- (OBXQueryBuilder *)where:(OBXProperty *)property isLessThanInteger:(NSInteger)integer NS_SWIFT_NAME(where(property:isLessThan:));
- (OBXQueryBuilder *)where:(OBXProperty *)property isGreaterThanInteger:(NSInteger)integer NS_SWIFT_NAME(where(property:isGreaterThan:));
/**
 Matches all property values between @p lowerBound and @p upperBound,
 including the bounds themselves. The order of the bounds does not matter.

 @param property Entity property to compare values of.
 @param lowerBound Lower limiting value, inclusive.
 @param upperBound Upper limiting value, inclusive.
 @return Same @p OBXQueryBuilder instance after the changes.
 */
- (OBXQueryBuilder *)where:(OBXProperty *)property isBetweenInteger:(NSInteger)lowerBound andInteger:(NSInteger)upperBound NS_SWIFT_NAME(where(property:isBetween:and:));
- (OBXQueryBuilder *)where:(OBXProperty *)property integerIsContainedIn:(NSArray<NSNumber *> *)collection NS_SWIFT_NAME(where(property:isContainedIn:));
- (OBXQueryBuilder *)where:(OBXProperty *)property integerIsNotContainedIn:(NSArray<NSNumber *> *)collection NS_SWIFT_NAME(where(property:isNotContainedIn:));

- (OBXQueryBuilder *)where:(OBXProperty *)property isEqualToDouble:(double)aDouble withTolerance:(double)tolerance NS_SWIFT_NAME(where(property:isEqualTo:tolerance:));
- (OBXQueryBuilder *)where:(OBXProperty *)property isLessThanDouble:(double)aDouble NS_SWIFT_NAME(where(property:isLessThan:));
- (OBXQueryBuilder *)where:(OBXProperty *)property isGreaterThanDouble:(double)aDouble NS_SWIFT_NAME(where(property:isGreaterThan:));
/**
 Matches all property values between @p lowerBound and @p upperBound,
 including the bounds themselves. The order of the bounds does not matter.

 @param property Entity property to compare values of.
 @param lowerBound Lower limiting value, inclusive.
 @param upperBound Upper limiting value, inclusive.
 @return Same @p OBXQueryBuilder instance after the changes.
 */
- (OBXQueryBuilder *)where:(OBXProperty *)property isBetweenDouble:(double)lowerBound andDouble:(double)upperBound NS_SWIFT_NAME(where(property:isBetween:and:));

- (OBXQueryBuilder *)where:(OBXProperty *)property equalsString:(NSString *)string __SWIFT_UNAVAILABLE;
- (OBXQueryBuilder *)where:(OBXProperty *)property equalsString:(NSString *)string caseSensitiveCompare:(BOOL)caseSensitive __SWIFT_UNAVAILABLE;
- (OBXQueryBuilder *)where:(OBXProperty *)property isEqualToString:(NSString *)string NS_SWIFT_NAME(where(property:isEqualTo:));
- (OBXQueryBuilder *)where:(OBXProperty *)property isEqualToString:(NSString *)string caseSensitiveCompare:(BOOL)caseSensitive NS_SWIFT_NAME(where(property:isEqualTo:caseSensitive:));
- (OBXQueryBuilder *)where:(OBXProperty *)property isNotEqualToString:(NSString *)string NS_SWIFT_NAME(where(property:isNotEqualTo:));
- (OBXQueryBuilder *)where:(OBXProperty *)property isNotEqualToString:(NSString *)string caseSensitiveCompare:(BOOL)caseSensitive NS_SWIFT_NAME(where(property:isNotEqualTo:caseSensitive:));
- (OBXQueryBuilder *)where:(OBXProperty *)property isLessThanString:(NSString *)string NS_SWIFT_NAME(where(property:isLessThan:));
- (OBXQueryBuilder *)where:(OBXProperty *)property isLessThanString:(NSString *)string caseSensitiveCompare:(BOOL)caseSensitive NS_SWIFT_NAME(where(property:isLessThan:caseSensitive:));
- (OBXQueryBuilder *)where:(OBXProperty *)property isGreaterThanString:(NSString *)string NS_SWIFT_NAME(where(property:isGreaterThan:));
- (OBXQueryBuilder *)where:(OBXProperty *)property isGreaterThanString:(NSString *)string caseSensitiveCompare:(BOOL)caseSensitive NS_SWIFT_NAME(where(property:isGreaterThan:caseSensitive:));
- (OBXQueryBuilder *)where:(OBXProperty *)property stringIsContainedIn:(NSArray<NSString *> *)collection NS_SWIFT_NAME(where(property:isContainedIn:));
- (OBXQueryBuilder *)where:(OBXProperty *)property stringIsContainedIn:(NSArray<NSString *> *)collection caseSensitiveCompare:(BOOL)caseSensitive NS_SWIFT_NAME(where(property:isContainedIn:caseSensitive:));
- (OBXQueryBuilder *)where:(OBXProperty *)property startsWith:(NSString *)prefix NS_SWIFT_NAME(where(property:startsWith:));
- (OBXQueryBuilder *)where:(OBXProperty *)property startsWith:(NSString *)prefix caseSensitiveCompare:(BOOL)caseSensitive NS_SWIFT_NAME(where(property:startsWith:caseSensitive:));
- (OBXQueryBuilder *)where:(OBXProperty *)property endsWith:(NSString *)suffix NS_SWIFT_NAME(where(property:endsWith:));
- (OBXQueryBuilder *)where:(OBXProperty *)property endsWith:(NSString *)suffix caseSensitiveCompare:(BOOL)caseSensitive NS_SWIFT_NAME(where(property:endsWith:caseSensitive:));
- (OBXQueryBuilder *)where:(OBXProperty *)property contains:(NSString *)substring NS_SWIFT_NAME(where(property:contains:));
- (OBXQueryBuilder *)where:(OBXProperty *)property contains:(NSString *)substring caseSensitiveCompare:(BOOL)caseSensitive NS_SWIFT_NAME(where(property:contains:caseSensitive:));


- (OBXQueryBuilder *)where:(OBXProperty *)property equalsDate:(NSDate *)date __SWIFT_UNAVAILABLE;
- (OBXQueryBuilder *)where:(OBXProperty *)property isEqualToDate:(NSDate *)date NS_SWIFT_NAME(where(property:isEqualTo:));
- (OBXQueryBuilder *)where:(OBXProperty *)property isNotEqualToDate:(NSDate *)date NS_SWIFT_NAME(where(property:isNotEqualTo:));
- (OBXQueryBuilder *)where:(OBXProperty *)property isBeforeDate:(NSDate *)date NS_SWIFT_NAME(where(property:isBefore:));
- (OBXQueryBuilder *)where:(OBXProperty *)property isAfterDate:(NSDate *)date NS_SWIFT_NAME(where(property:isAfter:));
/**
 Matches all property values between @p lowerBound and @p upperBound,
 including the bounds themselves. The order of the bounds does not matter.

 @param property Entity property to compare values of.
 @param lowerBound Lower limiting value, inclusive.
 @param upperBound Upper limiting value, inclusive.
 @return Same @p OBXQueryBuilder instance after the changes.
 */
- (OBXQueryBuilder *)where:(OBXProperty *)property isBetweenDate:(NSDate *)lowerBound andDate:(NSDate *)upperBound NS_SWIFT_NAME(where(property:isBetween:and:));
- (OBXQueryBuilder *)where:(OBXProperty *)property dateIsContainedIn:(NSArray<NSDate *> *)collection NS_SWIFT_NAME(where(property:isContainedIn:));
- (OBXQueryBuilder *)where:(OBXProperty *)property dateIsNotContainedIn:(NSArray<NSDate *> *)collection NS_SWIFT_NAME(where(property:isNotContainedIn:));

@end
NS_ASSUME_NONNULL_END
