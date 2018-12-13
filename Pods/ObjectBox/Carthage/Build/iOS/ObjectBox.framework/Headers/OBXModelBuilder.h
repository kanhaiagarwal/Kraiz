//  Copyright © 2018 ObjectBox. All rights reserved.

#import <Foundation/Foundation.h>

@class OBXEntityBuilder;
@class OBXEntityInfo;

NS_ASSUME_NONNULL_BEGIN
NS_SWIFT_NAME(ModelBuilder)
@interface OBXModelBuilder : NSObject

- (OBXEntityBuilder *)entityBuilderForEntityInfo:(OBXEntityInfo *)entityInfo;
- (NSData *)finish;

@end
NS_ASSUME_NONNULL_END
