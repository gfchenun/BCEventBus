//
//  BCEventMarker.h
//  BCRouteKit
//
//  Created by YeQing on 2018/11/13.
//  事件标记，订阅一次，产生一个标记

#import <Foundation/Foundation.h>


@interface BCEventMarker<Value> : NSObject
/** 事件target，如果target销毁，监听的事件也自动销毁 */
@property (nonatomic, weak) NSObject *target;
/** 事件 名称 */
@property (nonatomic, copy) NSString *eventName;

///** 唯一id【暂不用】 */
//@property (nonatomic, copy) NSString *uniqueId;
///** 事件class */
//@property (nonatomic, strong) Class eventClass;
///** 协议，除 eventClass 之外，支持监听某个协议的事件 */
//@property (nonatomic, strong) Protocol *protocol;

typedef void (^BCEventHandleBlock)(Value event);
/** 某个具体事件的handle */
@property (nonatomic, copy) BCEventHandleBlock handle;


#pragma mark - 销毁

/**
 订阅销毁
 */
- (void) dispose;



#pragma mark - helper

/**
 根据字符串 获取 事件名称（这里只是加上一个前缀）
 
 @param name name description
 @return return value description
 */
+ (NSString *) getEventNameWithStr:(NSString *)name;

/**
 根据class 获取 事件名称（这里只是加上一个前缀）
 
 @param eventClass eventClass description
 @return return value description
 */
+ (NSString *) getEventNameWithClass:(Class )eventClass;

/**
 根据protocol 获取 事件名称（这里只是加上一个前缀）
 
 @param protocol protocol description
 @return return value description
 */
+ (NSString *) getEventNameWithProtocol:(Protocol *)protocol;
@end
