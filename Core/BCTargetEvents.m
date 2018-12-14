//
//  BCTargetEvents.m
//  BCRouteKit
//
//  Created by YeQing on 2018/11/19.
//

#import "BCTargetEvents.h"
#import "BCEventBus.h"

@interface BCTargetEvents()
/** 所属target */
@property (nonatomic, weak) id target;
/** target下，所有事件的markers */
@property (nonatomic, strong) NSHashTable<BCEventMarker *> *eventMarkers;
@end


@implementation BCTargetEvents
#pragma mark - system
- (instancetype)initWithTarget:(id )target
{
    self = [super init];
    if (self) {
        _target = target;
    }
    return self;
}
- (void)dealloc
{
    [BCEventBus.shareBus dispose:_target];
#ifdef DEBUG
    NSLog(@"BCTargetEvents dealloc");
#endif
}

#pragma mark - 添加 event
- (void) addEventMarker:(BCEventMarker *)marker {
    [self.eventMarkers addObject:marker];
}
@end
