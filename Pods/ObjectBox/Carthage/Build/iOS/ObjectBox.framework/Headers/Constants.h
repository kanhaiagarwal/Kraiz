//  Copyright © 2018 ObjectBox. All rights reserved.

#import <Foundation/Foundation.h>

#ifndef Constants_h
#define Constants_h

NS_SWIFT_NAME(EntityId)
typedef uint64_t OBXEntityId;

/// Wrapper for `flatbuffers::Offset<flatbuffers::String>` that enables exposing
/// the collector interface to Swift.
typedef uint32_t OBXDataOffset;

extern NSErrorDomain const OBXErrorDomain;
extern NSString *const OBXErrorNameKey;

typedef NSString OBXPropertyAlias;

#endif /* Constants_h */
