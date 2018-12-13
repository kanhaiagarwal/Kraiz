//  Copyright © 2018 ObjectBox. All rights reserved.

#import <Foundation/Foundation.h>
#import "OBXDataOffset.h"

// Used by generated Swift code to get properties from an entity to store them.
// Is injected into the code generator; the actual implementation is in OBXCursor.
NS_SWIFT_NAME(PropertyCollector)
@protocol OBXPropertyCollector <NSObject>

- (void)collectBool:(BOOL)value atPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(collect(_:at:));
- (void)collectInt8:(int8_t)value atPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(collect(_:at:));
- (void)collectInt16:(int16_t)value atPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(collect(_:at:));
- (void)collectInt32:(int32_t)value atPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(collect(_:at:));
- (void)collectInt64:(int64_t)value atPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(collect(_:at:));
- (void)collectFloat:(float)value atPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(collect(_:at:));
- (void)collectDouble:(double)value atPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(collect(_:at:));
- (void)collectDate:(nullable NSDate *)date atPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(collect(_:at:));

- (void)collectEntityId:(OBXEntityId)entityId atPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(collect(_:at:));

/**
 @param value Treated as int64_t, effectively ignoring 32bit platforms.
 */
- (void)collectInteger:(NSInteger)value atPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(collect(_:at:));

/**
 @param value Treated as uint64_t, effectively ignoring 32bit platforms.
 */
- (void)collectUnsignedInteger:(NSUInteger)value atPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(collect(_:at:));

- (void)collectDataOffset:(OBXDataOffset)dataOffset atPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(collect(dataOffset:at:));
/// - returns: A value > 0 when a string value is prepared; 0 if the property is skipped.
- (OBXDataOffset)prepareString:(nullable NSString *)string atPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(prepare(string:at:));
- (OBXDataOffset)prepareBytes:(nullable NSData *)data atPropertyOffset:(uint16_t)propertyOffset NS_SWIFT_NAME(prepare(bytes:at:));

@end
