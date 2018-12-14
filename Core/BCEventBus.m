//
//  BCEventBus.m
//  BCRouteKit
//
//  Created by YeQing on 2018/11/13.
//

#import "BCEventBus.h"
#import "NSObject+BCEventHelper.h"

@interface BCEventBus()
/** 事件集合 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<BCEventMarker *> *> *eventMap;
@end


@implementation BCEventBus
#pragma mark - system


#pragma mark - getter
+ (BCEventBus *)shareBus {
    static BCEventBus *kBCEventBusInstance = nil;
    static dispatch_once_t kBCEventBusOnceToken;
    dispatch_once(&kBCEventBusOnceToken, ^{
        kBCEventBusInstance = [[BCEventBus alloc] init];
    });
    return kBCEventBusInstance;
}
-(NSMutableDictionary<NSString *,NSMutableArray<BCEventMarker *> *> *)eventMap {
    if (!_eventMap) {
        _eventMap = [[NSMutableDictionary alloc] init];
    }
    return _eventMap;
}

#pragma mark - 订阅事件

-(BCEventMarker *)subscribe:(Class)eventCls withTarget:(id)target {
    //获取 event Name
    NSString *eventName = [BCEventMarker getEventNameWithClass:eventCls];
    if (eventName.length<=0) {
#ifdef DEBUG
        NSLog(@"[eventbus] subscribe event error,name null");
#endif
        return nil;
    }
    BCEventMarker *marker = [[BCEventMarker alloc] init];
    marker.eventName = eventName;
    marker.target = target;
    //添加到target的事件 队列中，方便target销毁的时候，自动销毁事件
    if (marker.target) {
        [marker.target.bc_events addEventMarker:marker];
    }
    //添加到列表
    NSMutableArray<BCEventMarker *> *subscriberList = self.eventMap[eventName];
    if (!subscriberList) {
        subscriberList = [NSMutableArray array];
        self.eventMap[eventName] = subscriberList;
    }
    [subscriberList addObject:marker];
    return marker;
}

-(BCEventMarker *)subscribeName:(NSString *)eventName withTarget:(id)target {
    //获取 event Name
    eventName = [BCEventMarker getEventNameWithStr:eventName];
    if (eventName.length<=0) {
#ifdef DEBUG
        NSLog(@"[eventbus] subscribe name error,name null");
#endif
        return nil;
    }
    BCEventMarker *marker = [[BCEventMarker alloc] init];
//    marker.eventClass = [NSString class];
    marker.target = target;
    //添加到target的事件 队列中，方便target销毁的时候，自动销毁事件
    if (marker.target) {
        [marker.target.bc_events addEventMarker:marker];
    }
    //添加到列表
    NSMutableArray<BCEventMarker *> *subscriberList = self.eventMap[eventName];
    if (!subscriberList) {
        subscriberList = [NSMutableArray array];
        self.eventMap[eventName] = subscriberList;
    }
    [subscriberList addObject:marker];
    return marker;
}

-(void )subscribeProtocol:(Protocol *)protocol withTarget:(id)target {
    //获取 event Name
    NSString *eventName = [BCEventMarker getEventNameWithProtocol:protocol];
    if (eventName.length<=0) {
#ifdef DEBUG
        NSLog(@"[eventbus] subscribe protocol error,name null");
#endif
        return;
    }
    BCEventMarker *marker = [[BCEventMarker alloc] init];
    marker.eventName = eventName;
    marker.target = target;
    //添加到target的事件 队列中，方便target销毁的时候，自动销毁事件
    if (marker.target) {
        [marker.target.bc_events addEventMarker:marker];
    }
    //添加到列表
    NSMutableArray<BCEventMarker *> *subscriberList = self.eventMap[eventName];
    if (!subscriberList) {
        subscriberList = [NSMutableArray array];
        self.eventMap[eventName] = subscriberList;
    }
    [subscriberList addObject:marker];
    //    return marker;
}

#pragma mark - 发布事件
- (void)publish:(id)event {
    NSString *eventName = [BCEventMarker getEventNameWithClass:[event class]];
    if (eventName.length <= 0) {
#ifdef DEBUG
        NSLog(@"[eventbus] publish event error,name null");
#endif
        return;
    }
    //遍历订阅者，分发事件
    NSMutableArray<BCEventMarker *> *subscriberList = self.eventMap[eventName];
    if (subscriberList.count<=0) {
        return;
    }
    NSMutableArray<BCEventMarker *> *subscriberListCopy = [subscriberList mutableCopy];
    for (BCEventMarker *subscriber in subscriberListCopy) {
        if (subscriber.handle) {
            subscriber.handle(event);
        }
    }
}

- (void)publishName:(NSString *)eventName withData:(NSDictionary *)data {
    eventName = [BCEventMarker getEventNameWithStr:eventName];
    if (eventName.length <= 0) {
#ifdef DEBUG
        NSLog(@"[eventbus] publish name error,name null");
#endif
        return;
    }
    //遍历订阅者，分发事件
    NSMutableArray<BCEventMarker *> *subscriberList = self.eventMap[eventName];
    if (subscriberList.count<=0) {
        return;
    }
    NSMutableArray<BCEventMarker *> *subscriberListCopy = [subscriberList mutableCopy];
    for (BCEventMarker *subscriber in subscriberListCopy) {
        if (subscriber.handle) {
            subscriber.handle(data);
        }
    }
}

- (void)publishProtocol:(Protocol *)protocol withHandle:(BCEventProtocolBlock )handle {
    NSString *eventName = [BCEventMarker getEventNameWithProtocol:protocol];
    if (eventName.length <= 0) {
#ifdef DEBUG
        NSLog(@"[eventbus] publish protocol error,name null");
#endif
        return;
    }
    //遍历订阅者，分发事件
    NSMutableArray<BCEventMarker *> *subscriberList = self.eventMap[eventName];
    if (subscriberList.count<=0) {
        return;
    }
    NSMutableArray<BCEventMarker *> *subscriberListCopy = [subscriberList mutableCopy];
    for (BCEventMarker *subscriber in subscriberListCopy) {
        if (subscriber.target) {
            handle(subscriber.target);
        }
    }
}

#pragma mark - 移除事件

- (void) dispose:(id )target {
    if (!target) {
        return;
    }
    //存储需要清空的事件列表
    NSMutableArray<NSString *> *delEvents = nil;
    //遍历事件map，找到对应的target的所有event的marker列表
    for (NSString *key in self.eventMap.allKeys) {
        NSMutableArray<BCEventMarker *> *obj = self.eventMap[key];
        NSMutableArray<BCEventMarker *> *delMarkerList = nil;
        for (BCEventMarker *marker in obj) {
            //找到target匹配的项
            if (marker.target && marker.target == target) {
                if (!delMarkerList) {
                    delMarkerList = [[NSMutableArray alloc] init];
                }
                [delMarkerList addObject:marker];
            }
        }
        //删除监听的事件
        if (delMarkerList.count>0) {
            [obj removeObjectsInArray:delMarkerList];
        }
        //如果该事件没有监听者了，则标记需要清空
        if (obj.count<=0) {
            if (!delEvents) {
                delEvents = [[NSMutableArray alloc] init];
            }
            [delEvents addObject:key];
        }
    }
    //清空 空的event
    if (delEvents.count>0) {
        for (NSString *eventKey in delEvents) {
            [self.eventMap removeObjectForKey:eventKey];
        }
    }
}
- (void) disposeEvent:(BCEventMarker *)marker {
    NSString *eventName = marker.eventName;
    if (eventName.length <= 0) {
#ifdef DEBUG
        NSLog(@"[eventbus] dispose error,name null");
#endif
        return;
    }
    NSMutableArray<BCEventMarker *> *subscriberList = self.eventMap[eventName];
    if (subscriberList.count<=0) {
        return ;
    }
    NSMutableArray<BCEventMarker *> *delMarkers = [[NSMutableArray alloc] init];
    for (BCEventMarker *subscriber in subscriberList) {
        if (subscriber == marker) {
            //对象地址一样
            [delMarkers addObject:subscriber];
            continue;
        } else if(subscriber.target && marker.target && subscriber.target == marker.target && subscriber.eventName &&  marker.eventName && [subscriber.eventName isEqualToString: marker.eventName]) {
            //target、eventName 一样
            [delMarkers addObject:subscriber];
            continue;
        }
    }
    //删除找到的 marker
    if (delMarkers.count>0) {
        [subscriberList removeObjectsInArray:delMarkers];
    }
    //如果事件列表为空，清空该项事件
    if (subscriberList.count<=0) {
        [self.eventMap removeObjectForKey:eventName];
    }
}


@end
