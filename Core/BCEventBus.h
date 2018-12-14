//
//  BCEventBus.h
//  BCRouteKit
//
//  Created by YeQing on 2018/11/13.
//  事件中心

#import <Foundation/Foundation.h>
#import "BCEventMarker.h"

@interface BCEventBus<Value> : NSObject
/** 事件中心 单例 */
@property (class, readonly) BCEventBus *shareBus;


#pragma mark - 订阅事件

/**
 target 订阅具体事件
 
 @param eventCls 需要订阅的事件 class
 @param target 需要订阅的target，如果target销毁，则监听的所有事件也销毁了
 @return return value description
 */
-(BCEventMarker *)subscribe:(Class )eventCls withTarget:(id)target;

/**
 订阅某个名字的事件

 @param eventName 事件名称
 @param target 需要订阅的target，如果target销毁，则监听的所有事件也销毁了
 @return return value description
 */
-(BCEventMarker *)subscribeName:(NSString *)eventName withTarget:(id)target;

/**
 target 订阅某个协议的事件
 
 @param protocol 需要订阅的协议
 @param target 需要订阅的target，如果target销毁，则监听的所有事件也销毁了
 */
-(void )subscribeProtocol:(Protocol *)protocol withTarget:(id)target;

#pragma mark - 发布事件
/**
 发布具体的事件

 @param event 事件模型，可以实现 BCEventProtocol 协议，也可以不实现。
 */
- (void)publish:(id )event;

/**
 发布某个名字的事件，并可以附带一些简单的数据

 @param eventName 事件名称
 @param data 附带的数据，一般是简单的数据
 */
- (void)publishName:(NSString *)eventName withData:(NSDictionary *)data;

typedef void (^BCEventProtocolBlock)(Value target);
/**
 发布某个协议的事件

 @param protocol protocol description
 @param handle 具体需要执行协议的某个方法，发布者必须要知道发布协议的某个方法
 */
- (void)publishProtocol:(Protocol *)protocol withHandle:(BCEventProtocolBlock )handle;

#pragma mark - 移除事件
/**
 销毁某个 target 订阅的所有事件
 
 @param target target description
 */
- (void) dispose:(id )target;

/**
 销毁某个事件

 @param marker marker description
 */
- (void) disposeEvent:(BCEventMarker *)marker;


@end
