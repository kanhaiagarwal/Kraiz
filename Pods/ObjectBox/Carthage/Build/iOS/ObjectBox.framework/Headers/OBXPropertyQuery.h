//  Copyright © 2018 ObjectBox. All rights reserved.

#import <Foundation/Foundation.h>

@class OBXEntityInfo;

NS_REFINED_FOR_SWIFT
@interface OBXPropertyQuery : NSObject

@property (nonatomic, readonly, strong, nonnull) OBXEntityInfo *entityInfo;
@property (nonatomic, readwrite, copy, nullable) NSString *nullString;
@property (nonatomic, readwrite, copy, nullable) NSNumber *nullLong;
@property (nonatomic, readonly, assign, getter=isDistinct) BOOL distinct;
@property (nonatomic, readonly, assign, getter=isUnique) BOOL unique;
@property (nonatomic, readonly, assign, getter=isComparingCaseSensitive) BOOL caseSensitiveCompare;

- (nonnull instancetype)init __attribute((unavailable));

- (nonnull OBXPropertyQuery *)distinct;
- (nonnull OBXPropertyQuery *)distinctWithCaseSensitiveCompare:(BOOL)caseSensitiveCompare;
- (nonnull OBXPropertyQuery *)unique;

- (double)average;
- (uint64_t)count;

/// Ignores null values by default. Sets a replacement value for when the scalar value is null to return them as matches.
- (nonnull OBXPropertyQuery *)withNullLong:(int64_t)defaultNullLong;
- (int64_t)longSum;
- (int64_t)longMax;
- (int64_t)longMin;
- (nullable NSNumber *)findLong;
- (nonnull NSArray<NSNumber *> *)findLongs;

- (double)doubleSum;
- (double)doubleMax;
- (double)doubleMin;

/// Ignores null values by default. Sets a replacement value for when the string value is null to return them as matches.
- (nonnull OBXPropertyQuery *)withNullString:(nonnull NSString *)defaultNullString;
- (nullable NSString *)findString;
- (nonnull NSArray<NSString *>*)findStrings;

@end
