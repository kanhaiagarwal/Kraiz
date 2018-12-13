//  Copyright © 2018 ObjectBox. All rights reserved.

#import <Foundation/Foundation.h>

#ifndef OBXDATAOFFSET
#define OBXDATAOFFSET

/// Wrapper for `flatbuffers::Offset<flatbuffers::String>` that enables exposing
/// the collector interface to Swift.
typedef uint32_t OBXDataOffset;

#endif // OBXDATAOFFSET
