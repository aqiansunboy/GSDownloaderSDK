//
//  GSScreenUtil.h
//  GSCoreCommon
//
//  Created by Chaoqian Wu on 13-11-20.
//  Copyright (c) 2013年 4399 Network CO.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSScreenUtil : NSObject

/**
 *  获取竖屏模式下的屏幕宽度
 *
 *  @return 屏幕宽度
 */
+ (float) getVerticalWidthOfScreen;

/**
 *  获取竖屏模式下的屏幕高度
 *
 *  @return 屏幕高度
 */
+ (float) getVerticalHeightOfScreen;

/**
 *  获取横屏模式下的屏幕宽度
 *
 *  @return 屏幕宽度
 */
+ (float) getHorizontalWidthOfScreen;

/**
 *  获取横屏模式下的屏幕高度
 *
 *  @return 屏幕高度
 */
+ (float) getHorizontalHeightOfScreen;

/**
 *  获取状态栏高度
 *
 *  @return 状态栏高度
 */
+ (float) getStatusBarHeight;

/**
 *  获取导航条高度
 *
 *  @param navigationBar 导航条对象
 *
 *  @return 导航条高度
 */
+ (float) getNavigationBarHeightOf:(UINavigationBar*)navigationBar;

/**
 *  获取TabBar高度
 *
 *  @param tabBar TabBar对象
 *
 *  @return TabBar高度
 */
+ (float) getTabBarHeightOf:(UITabBar*)tabBar;

@end
