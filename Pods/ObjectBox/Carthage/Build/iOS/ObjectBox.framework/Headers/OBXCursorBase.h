//  Copyright © 2018 ObjectBox. All rights reserved.

#import <Foundation/Foundation.h>
#import "Constants.h"

@class OBXStore;
@protocol OBXPropertyCollector;
@protocol OBXEntityReader;

NS_ASSUME_NONNULL_BEGIN

// To OBXCursorBase all get/put actions are delegated. This is supposed to be implemented by concrete
// entity cursors in the generated code, e.g. PersonCursor, which is resposible for making its entity
// type persistable.
NS_SWIFT_NAME(CursorBase)
@protocol OBXCursorBase <NSObject>

/**
 * @returns The ID of a persisted entity, or 0 to indicate @p entity needs to get assigned an ID.
 */
- (OBXEntityId)collectFromEntity:(id)entity propertyCollector:(id<OBXPropertyCollector>)propertyCollector store:(OBXStore *)store __attribute((warn_unused_result));
- (id)createEntityWithEntityReader:(id<OBXEntityReader>)entityReader store:(OBXStore *)store NS_SWIFT_NAME(createEntity(entityReader:store:)) __attribute((warn_unused_result));

- (void)setEntityIdOfEntity:(id)entity to:(OBXEntityId)entityId NS_SWIFT_NAME(setEntityId(of:to:));
- (OBXEntityId)entityIdForEntity:(id)entity NS_SWIFT_NAME(entityId(of:));

@end
NS_ASSUME_NONNULL_END
