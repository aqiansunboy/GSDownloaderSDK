//
//  GSReachabilityUtil.h
//  GSCoreCommon
//
//  Created by Chaoqian Wu on 13-11-14.
//  Copyright (c) 2013年 4399 Network CO.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    GSNetworkStatusWIFI     = 0,
    GSNetworkStatus3G       = 1,
    GSNetworkStatusOFFLINE  = 2
    
} GSNetworkStatus;

#define NETWORK_STATUS_KEY   @"GSNetworkStatusKey"
#define NETWORK_TEST_WEBSITE @"www.baidu.com"

@interface GSReachabilityUtil : NSObject

/**
 *  注册网络状态变化监听者
 *
 *  @param observer  外部观察者，如果为空，则使用内置默认观察者
 *  @param aSelector 外部通知接收方法，如果为空，则使用内置默认方法
 *  @param anObject  事件接收对象，默认为空
 */
+ (void)registerReachabilityChangedObserver:(id)observer selector:(SEL)aSelector object:(id)anObject;

/**
 *  默认网络状态变化监听者
 */
+ (void)registerReachabilityChangedObserver;

/**
 *  获取缓存的网络状态
 *
 *  @return 网络状态值
 */
+ (GSNetworkStatus)getCachedNetworkStatus;

/**
 *  获取当前的网络状态
 *
 *  @return 网络状态值
 */
+ (GSNetworkStatus)getCurrentNetworkStatus;

@end
