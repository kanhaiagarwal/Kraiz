//  Copyright © 2018 ObjectBox. All rights reserved.

#import <Foundation/Foundation.h>
#import "Constants.h"

// Used by generated Swift code to hydrate an entity from the store.
// Is injected into the code generator; the actual implementation is in OBXCursor.
NS_SWIFT_NAME(EntityReader)
@protocol OBXEntityReader <NSObject>

- (BOOL)boolAtPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(boolean(at:));
- (nullable NSNumber *)optionalBoolAtPropertyOffset:(uint16_t)propertyOffset NS_REFINED_FOR_SWIFT;
- (int8_t)int8AtPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(int8(at:));
- (nullable NSNumber *)optionalInt8AtPropertyOffset:(uint16_t)propertyOffset NS_REFINED_FOR_SWIFT;
- (int16_t)int16AtPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(int16(at:));
- (nullable NSNumber *)optionalInt16AtPropertyOffset:(uint16_t)propertyOffset NS_REFINED_FOR_SWIFT;
- (int32_t)int32AtPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(int32(at:));
- (nullable NSNumber *)optionalInt32AtPropertyOffset:(uint16_t)propertyOffset NS_REFINED_FOR_SWIFT;
- (int64_t)int64AtPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(int64(at:));
- (nullable NSNumber *)optionalInt64AtPropertyOffset:(uint16_t)propertyOffset NS_REFINED_FOR_SWIFT;
- (float)floatAtPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(float(at:));
- (nullable NSNumber *)optionalFloatAtPropertyOffset:(uint16_t)propertyOffset NS_REFINED_FOR_SWIFT;
- (double)doubleAtPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(double(at:));
- (nullable NSNumber *)optionalDoubleAtPropertyOffset:(uint16_t)propertyOffset NS_REFINED_FOR_SWIFT;

- (OBXEntityId)entityIdAtPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(entityId(at:));

- (nullable NSDate *)dateAtPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(date(at:));
- (nullable NSString *)stringAtPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(string(at:));
- (nullable NSData *)bytesAtPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(bytes(at:));

/**
 @return Integer treated as int64_t, effectively ignoring 32bit platforms.
 */
- (NSInteger)integerAtPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(integer(at:));
- (nullable NSNumber *)optionalIntegerAtPropertyOffset:(uint16_t)propertyOffset NS_REFINED_FOR_SWIFT;

/**
 @return Integer treated as int64_t, effectively ignoring 32bit platforms.
 */
- (NSUInteger)unsignedIntegerAtPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(unsignedInteger(at:));
- (nullable NSNumber *)optionalUnsignedIntegerAtPropertyOffset:(uint16_t)propertyOffset NS_REFINED_FOR_SWIFT;

@end
