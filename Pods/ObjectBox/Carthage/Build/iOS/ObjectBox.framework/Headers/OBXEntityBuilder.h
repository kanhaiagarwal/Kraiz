//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

#import <Foundation/Foundation.h>
#import "OBXProperty.h"

@class OBXEntityInfo;

NS_ASSUME_NONNULL_BEGIN
NS_SWIFT_NAME(EntityBuilder)
@interface OBXEntityBuilder<T> : NSObject

@property (nonatomic, readonly, copy) OBXEntityInfo *entityInfo;

- (instancetype)init __attribute__((unavailable));

- (void)addPropertyNamed:(NSString *)name type:(OBXEntityPropertyType)type NS_SWIFT_NAME(addProperty(name:type:));
- (void)addPropertyNamed:(NSString *)name type:(OBXEntityPropertyType)type flags:(OBXEntityPropertyFlag)flags NS_SWIFT_NAME(addProperty(name:type:flags:));

- (void)addRelationNamed:(NSString *)name targetEntityInfo:(OBXEntityInfo *)targetEntityInfo NS_SWIFT_NAME(addRelation(name:targetEntityInfo:));

@end
NS_ASSUME_NONNULL_END
