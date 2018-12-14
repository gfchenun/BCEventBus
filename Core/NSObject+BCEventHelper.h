//
//  NSObject+BCEventHelper.h
//  BCRouteKit
//
//  Created by YeQing on 2018/11/19.
//

#import <Foundation/Foundation.h>
#import "BCTargetEvents.h"

@interface NSObject (BCEventHelper)
/** target 订阅的事件对象 */
@property (nonatomic, strong) BCTargetEvents *bc_events;
@end

