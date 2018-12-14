//
//  BCEventMarker.m
//  BCRouteKit
//
//  Created by YeQing on 2018/11/13.
//

#import "BCEventMarker.h"
#import "BCEventBus.h"

@interface BCEventMarker()
@end

@implementation BCEventMarker
#pragma mark - system
- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"BCEventMarker dealloc");
#endif
}

#pragma mark - 销毁事件
- (void) dispose {
    [BCEventBus.shareBus dispose:self];
    _target = nil;
    _eventName = nil;
    _handle = nil;
}

#pragma mark - helper

+ (NSString *) getEventNameWithStr:(NSString *)name {
    NSString *eventName = nil;
    if (name.length>0) {
        eventName = [NSString stringWithFormat:@"Str_%@", name];
    }
    return eventName;
}

+ (NSString *) getEventNameWithClass:(Class )eventClass {
    if (!eventClass) {
        return nil;
    }
    NSString *eventName = NSStringFromClass(eventClass);
    //加上前追
    if (eventName.length>0) {
        eventName = [NSString stringWithFormat:@"Obj_%@", eventName];
    }
    return eventName;
}

/**
 根据protocol 获取 事件名称（这里只是加上一个前缀）
 
 @param protocol protocol description
 @return return value description
 */
+ (NSString *) getEventNameWithProtocol:(Protocol *)protocol {
    if (!protocol) {
        return nil;
    }
    NSString *eventName = nil;
    eventName = NSStringFromProtocol(protocol);
    //加上前追
    if (eventName.length>0) {
        eventName = [NSString stringWithFormat:@"Pro_%@", eventName];
    }
    return eventName;
}

@end
