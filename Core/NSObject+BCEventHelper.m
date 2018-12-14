//
//  NSObject+BCEventHelper.m
//  BCRouteKit
//
//  Created by YeQing on 2018/11/19.
//

#import "NSObject+BCEventHelper.h"
#import <objc/runtime.h>

@implementation NSObject (BCEventHelper)


#pragma mark - bc_events
-(BCTargetEvents *)bc_events {
    BCTargetEvents *targetEvents = (BCTargetEvents *)objc_getAssociatedObject(self, @selector(bc_events));
    if (!targetEvents) {
        //如果没有，创建一个
        targetEvents = [[BCTargetEvents alloc] initWithTarget:self];
        self.bc_events = targetEvents;
    }
    return targetEvents;
}
-(void)setBc_events:(BCTargetEvents *)bc_events {
    objc_setAssociatedObject(self, @selector(bc_events), bc_events, OBJC_ASSOCIATION_RETAIN);
}
@end
