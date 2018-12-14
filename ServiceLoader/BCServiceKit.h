//
//  BCServiceKit.h
//  Pods
//
//  Created by YeQing on 2018/11/21.
//

#ifndef BCServiceKit_h
#define BCServiceKit_h

#import "BCServicePublic.h"
#import "BCServiceProtocol.h"
#import "BCServiceLoader.h"

#pragma mark - 注册
//注解方式标记service需要注册，装载镜像的时候注册service
#define BCServiceAnno(_protocol_, _class_) class NSObject;char * kBCService_##_protocol_ __attribute((used, section("__DATA,"kBCService_SectionName" "))) = ""#_protocol_","#_class_"";
//手动注册service
#define BCServiceRegist(_protocol_, _class_) [BCServiceLoader.shareLoader registerService:@protocol(_protocol_) withClass:[_class_ class]]

#pragma mark - 加载
//根据指定的 protocol 加载 service
#define BCServiceLoad(_protocol_)   ((id<_protocol_> )[BCServiceLoader.shareLoader loadService:@protocol(_protocol_)])

#endif /* BCServiceKit_h */
