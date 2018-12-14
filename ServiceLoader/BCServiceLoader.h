//
//  BCServiceLoader.h
//  BCRouteKit
//
//  Created by YeQing on 2018/11/12.
//  service 装载器

#import <Foundation/Foundation.h>


@interface BCServiceLoader : NSObject
/** service加载器 单例 */
@property (class, readonly) BCServiceLoader *shareLoader;


#pragma mark - 注册service
/**
 注册service

 @param protocol service 实现的抽象协议
 @param impCls service实现的class
 */
- (void) registerService:(Protocol *)protocol withClass:(Class )impCls;


#pragma mark - 获取service

/**
 根据service实现的抽象协议，获取service

 @param protocol 抽象协议
 @return return value description
 */
- (id ) loadService:(Protocol *)protocol;
@end
