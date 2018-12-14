//
//  BCAppDelegate.m
//  BCRouteKit
//
//  Created by YeQing on 2018/11/12.
//

#import "BCAppDelegate.h"
#import <BCFileLog/BCFileLog.h>
#import "BCEventBusKit.h"

@interface BCAppDelegate()
@end

@implementation BCAppDelegate
#pragma mark - system
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BCLogInfo(@"[app] launch:%@",launchOptions);
    [BCPubProtocol(UIApplicationDelegate) withHandle:^(id<UIApplicationDelegate> target) {
        if ([target respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)]) {
            [target application:application didFinishLaunchingWithOptions:launchOptions];
        }
    }];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    BCLogInfoStr(@"[app] background");
    [BCPubProtocol(UIApplicationDelegate) withHandle:^(id<UIApplicationDelegate> target) {
        if ([target respondsToSelector:@selector(applicationDidEnterBackground:)]) {
            [target applicationDidEnterBackground:application];
        }
    }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    BCLogInfoStr(@"[app] active");
    [BCPubProtocol(UIApplicationDelegate) withHandle:^(id<UIApplicationDelegate> target) {
        if ([target respondsToSelector:@selector(applicationDidBecomeActive:)]) {
            [target applicationDidBecomeActive:application];
        }
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    BCLogInfoStr(@"[app] terminate");
    [BCPubProtocol(UIApplicationDelegate) withHandle:^(id<UIApplicationDelegate> target) {
        if ([target respondsToSelector:@selector(applicationWillTerminate:)]) {
            [target applicationWillTerminate:application];
        }
    }];
}

#pragma mark - apns
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    BCLogInfo(@"[app] register push:%@", deviceToken);
    [BCPubProtocol(UIApplicationDelegate) withHandle:^(id<UIApplicationDelegate> target) {
        if ([target respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
            [target application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
        }
    }];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    BCLogInfo(@"[app] register push error:%@", error.localizedDescription);
    [BCPubProtocol(UIApplicationDelegate) withHandle:^(id<UIApplicationDelegate> target) {
        if ([target respondsToSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)]) {
            [target application:application didFailToRegisterForRemoteNotificationsWithError:error];
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //ios7,app收到push消息
    BCLogInfo(@"[app] receive1:%@", userInfo);
    [BCPubProtocol(UIApplicationDelegate) withHandle:^(id<UIApplicationDelegate> target) {
        if ([target respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
            [target application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
        }
    }];
}


#pragma mark - 3D Touch 代理方法
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler  API_AVAILABLE(ios(9.0)) {
    BCLogInfo(@"[app] shortcut:%@", shortcutItem.type);
    if (@available(iOS 9.0, *))  {
        [BCPubProtocol(UIApplicationDelegate) withHandle:^(id<UIApplicationDelegate> target) {
            if ([target respondsToSelector:@selector(application:performActionForShortcutItem:completionHandler:)]) {
                [target application:application performActionForShortcutItem:shortcutItem completionHandler:completionHandler];
            }
        }];
    }
}
@end
