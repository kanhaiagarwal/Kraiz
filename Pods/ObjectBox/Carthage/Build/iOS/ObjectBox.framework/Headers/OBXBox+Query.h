//  Copyright © 2018 ObjectBox. All rights reserved.

#import "OBXBox.h"

@class OBXQueryBuilder;

NS_ASSUME_NONNULL_BEGIN
@interface OBXBox (Query)

- (OBXQueryBuilder *)query;

@end
NS_ASSUME_NONNULL_END
