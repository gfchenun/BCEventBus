//
//  BCServiceLoader.m
//  BCRouteKit
//
//  Created by YeQing on 2018/11/12.
//

#import "BCServiceLoader.h"
#import "BCServiceProtocol.h"
#import "BCServicePublic.h"
#import "BCServicePrivate.h"

#include <mach-o/ldsyms.h>
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>

@interface BCServiceLoader()
/** service map */
@property (nonatomic, strong) NSMutableDictionary<NSString *,NSMutableDictionary *> *servicesMap;
@end


@implementation BCServiceLoader
#pragma mark - system

#pragma mark - getter
+ (BCServiceLoader *)shareLoader {
    static BCServiceLoader *kBCServiceLoaderInstance = nil;
    static dispatch_once_t kBCServiceLoaderOnceToken;
    dispatch_once(&kBCServiceLoaderOnceToken, ^{
        kBCServiceLoaderInstance = [[BCServiceLoader alloc] init];
    });
    return kBCServiceLoaderInstance;
}

-(NSMutableDictionary<NSString *,NSMutableDictionary *> *)servicesMap {
    if (!_servicesMap) {
        _servicesMap = [[NSMutableDictionary alloc] init];
    }
    return _servicesMap;
}

#pragma mark - 注册service
- (void) registerService:(Protocol *)protocol withClass:(Class )impCls {
    NSString *serviceName = NSStringFromProtocol(protocol);
    [self registerService:serviceName withClassName:NSStringFromClass(impCls)];
}

- (void) registerService:(NSString *)protocolName withClassName:(NSString *)className {
    //数据校验
    if (protocolName.length<=0 || className.length<=0) {
        return ;
    }
    NSMutableDictionary *serviceModel = self.servicesMap[protocolName];
    if (serviceModel) {
#ifdef DEBUG
        NSLog(@"[BCService] register name repeat:%@", protocolName);
#endif
        return;
    }
    //注册
    serviceModel = [[NSMutableDictionary alloc] init];
    serviceModel[kBCServiceModel_implClass] = className;
    //如果不是懒加载，注册的时候就初始化
    BOOL lazyLoad = YES;
    Class implClass = NSClassFromString(className);
    if (implClass && [implClass respondsToSelector:@selector(bc_lazyLoading)]) {
        //实现了
        lazyLoad = [[implClass performSelector:@selector(bc_lazyLoading) withObject:nil] boolValue];
        
    }
    //注册的时候就初始化，且实现了单例方法
    if (!lazyLoad  && [implClass respondsToSelector:@selector(bc_shareInstance)]) {
        id shareInstance = [implClass performSelector:@selector(bc_shareInstance) withObject:nil];
        serviceModel[kBCServiceModel_implObj] = shareInstance;
    }
    self.servicesMap[protocolName] = serviceModel;
}

#pragma mark - 获取service
- (id ) loadService:(Protocol *)protocol {
    NSString *serviceName = NSStringFromProtocol(protocol);
    if (serviceName.length<=0) {
        return nil;
    }
    NSMutableDictionary *serviceModel = self.servicesMap[serviceName];
    if (!serviceModel) {
        return nil;
    }
    //如果已经初始化过了，直接返回
    id implObj = serviceModel[kBCServiceModel_implObj];
    if (implObj) {
        return implObj;
    }
    //其次，如果实现了 BCServiceProtocol,bc_shareInstance方法
    NSString *implClsName = serviceModel[kBCServiceModel_implClass];
    Class implClass = NSClassFromString(implClsName);
    if (implClass && [implClass respondsToSelector:@selector(bc_shareInstance)]) {
        id shareInstance = [implClass performSelector:@selector(bc_shareInstance) withObject:nil];
        serviceModel[kBCServiceModel_implObj] = shareInstance;
        return shareInstance;
    }
    //最后，重新alloc
    if (implClass) {
        id shareInstance = [[implClass alloc] init];
//        serviceModel[kBCServiceModel_implObj] = shareInstance;
        return shareInstance;
    }
    return nil;
}


@end


#pragma mark - Annotation

/**
 装载镜像的回调

 @param mhp mhp description
 @param vmaddr_slide vmaddr_slide description
 */
static void bcservice_dyldcallback(const struct mach_header *mhp, intptr_t vmaddr_slide)
{
    unsigned long size = 0;
#ifndef __LP64__
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp, SEG_DATA, kBCService_SectionName, &size);
#else
    const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mhp;
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp64, SEG_DATA, kBCService_SectionName, &size);
#endif
    if (!memory || size<=0) {
        //没有找到 service section
        return;
    }
#ifdef DEBUG
    //debug,记录耗时的时间
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
#endif
    unsigned long counter = size/sizeof(void*);
    for(int idx = 0; idx < counter; ++idx){
        char *serviceChar = (char*)memory[idx];
        NSString *serviceStr = [NSString stringWithUTF8String:serviceChar];
        if(serviceStr.length<=0) {
            continue;
        }
        NSArray *serviceInfo = [serviceStr componentsSeparatedByString:@","];
        if (serviceInfo.count<=1) {
            //数据不完整，过滤
            continue;
        }
        NSString *protocolName = serviceInfo.firstObject;
        NSString *impName = serviceInfo[1];
        if (protocolName.length<=0 || impName.length<=0) {
            //数据不完整，过滤
            continue;
        }
        //注册service
        [BCServiceLoader.shareLoader registerService:protocolName withClassName:impName];
    }
#ifdef DEBUG
    //debug,打印耗时
    startTime = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime consumeTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"[service] register,%f ms", consumeTime *1000.0);
#endif
}

__attribute__((constructor)) void bcservice_main() {
    //load 之后，_objc_init 之前
    _dyld_register_func_for_add_image(bcservice_dyldcallback);
}

