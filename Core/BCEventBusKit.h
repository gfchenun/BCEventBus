//
//  BCEventBusKit.h
//  BCRouteKit
//
//  Created by YeQing on 2018/11/19.
//

#ifndef BCEventBusKit_h
#define BCEventBusKit_h

#import "BCEventBus.h"

#pragma mark - 订阅方
//订阅某个字符串事件
#define BCSubName(_target_, _name_) ((BCEventMarker<NSDictionary *> *)[BCEventBus.shareBus subscribeName:_name_ withTarget:_target_])
//订阅某一类特定的事件，class方式
#define BCSubEvent(_target_, _eventClass_) ((BCEventMarker<_eventClass_ *> *)[BCEventBus.shareBus subscribe:[_eventClass_ class] withTarget:_target_])
//订阅某一组事件，协议的方式
#define BCSubProtocol(_target_, _protocol_) [BCEventBus.shareBus subscribeProtocol:@protocol(_protocol_) withTarget:_target_]

#pragma mark - 发布方
//发布字符串事件
#define BCPubName(_name_) [BCEventBus.shareBus publishName:_name_ withData:nil]
#define BCPubNameWithData(_name_,_data_) [BCEventBus.shareBus publishName:_name_ withData:_data_]
//发布对象事件
#define BCPubEvent(_event_) [BCEventBus.shareBus publish:_event_]
//发布协议事件
#define BCPubProtocol(_protocol_) (BCEventBus<id<_protocol_> > *)BCEventBus.shareBus publishProtocol:@protocol(_protocol_)

#pragma mark - 销毁
//销毁target的所有事件，一般不需要手动调用，事件会伴随订阅者一起销毁。
#define BCDisposeEvent(_target_) [BCEventBus.shareBus dispose:_target_]

#endif /* BCEventBusKit_h */
