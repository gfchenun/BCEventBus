//
//  BCServiceProtocol.h
//  BCRouteKit
//
//  Created by YeQing on 2018/11/21.
//

#ifndef BCServiceProtocol_h
#define BCServiceProtocol_h

@protocol BCServiceProtocol <NSObject>

@optional

/**
 获取单例

 @return return value description
 */
+ (id ) bc_shareInstance;

/**
 是否是懒加载，默认YES，使用的时候再初始化;如果为NO，装载镜像的时候，就初始化，不推荐设置NO
 
 @return return value description
 */
+ (BOOL ) bc_lazyLoading;
@end

#endif /* BCServiceProtocol_h */
