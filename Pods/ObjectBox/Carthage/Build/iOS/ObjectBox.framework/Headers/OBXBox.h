//  Copyright © 2018 ObjectBox. All rights reserved.

#import <Foundation/Foundation.h>
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

// Main interface to get and put entities.
//
// - Obtains transaction from the OBXStore.
// - Uses OBXCursor from the transaction to perform the actual command.
//
// Box.swift wraps OBXBox to offer a pure Swift API.
//
// Keep the instances around for as long as you want. Can be used across different threads.
NS_REFINED_FOR_SWIFT
@interface OBXBox : NSObject

@property (readonly) BOOL isEmpty;

- (instancetype)init __attribute((unavailable));

- (OBXEntityId)put:(id)entity error:(NSError **)error
  __attribute__((swift_error(zero_result)));
- (void)putAll:(NSArray *)entities error:(NSError **)error
  __attribute__((swift_error(nonnull_error))) NS_SWIFT_NAME(putAll(_:));

- (nullable id)get:(OBXEntityId)entityId;

/**
 @return Dictionary of all @p entityIds and the corresponding objects. Inserts @p NSNull when not found.
 */
- (nonnull NSDictionary<NSNumber *, id> *)dictionaryWithEntitiesForIds:(NSArray<NSNumber *> *)entityIds NS_SWIFT_NAME(dictionaryWithEntities(forIds:));

- (NSArray *)all;

- (uint64_t)count;

/**
 @param max Maximum value to count up to, or 0 for unlimited count.
 */
- (uint64_t)countLimitedBy:(uint64_t)max NS_SWIFT_NAME(count(limit:));

- (BOOL)removeEntityWithId:(OBXEntityId)entityId error:(NSError **)error NS_SWIFT_NAME(remove(_:));
- (BOOL)removeEntity:(id)entity error:(NSError **)error NS_SWIFT_NAME(remove(_:));

/**
 @return Count of items that were removed.
 */
- (uint64_t)removeEntities:(NSArray *)entities error:(NSError **)error NS_SWIFT_NAME(remove(_:)) __attribute__((swift_error(nonnull_error)));

/**
 @return Count of items that were removed.
 */
- (uint64_t)removeAllAndReturnError:(NSError **)error
  __attribute__((swift_error(nonnull_error)));

- (NSArray<NSNumber *> *)__backlinkIdsToPropertyId:(uint64_t)propertyId entityId:(OBXEntityId)entityId;

@end

NS_ASSUME_NONNULL_END
