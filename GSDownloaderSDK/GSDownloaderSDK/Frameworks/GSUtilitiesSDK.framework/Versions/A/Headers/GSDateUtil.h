//
//  GSDateUtil.h
//  GSCoreCommon
//
//  Created by Chaoqian Wu on 13-12-16.
//  Copyright (c) 2013年 4399 Network CO.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSDateUtil : NSObject

/**
 *  判断两个日期是否是同一天
 *
 *  @param day1 Day1
 *  @param day2 Day2
 *
 *  @return 是否是同一天
 */
+ (BOOL)isSameDay:(NSDate*)day1 and:(NSDate*)day2;

/**
 *  判断d1是否在d2之前
 *
 *  @param d1 day1
 *  @param d2 day2
 *
 *  @return YES/NO
 */
+ (BOOL)isDay:(NSDate*)date1 before:(NSDate*)date2;


/**
 *  转换yyyy-MM-dd HH:mm:ss格式时间
 *
 *  @param dateStr yyyy-MM-dd HH:mm:ss
 *
 *  @return data
 */
+ (NSDate*)dateWithString:(NSString*)dateStr;

/**
 *  将日期转换为指定格式的时间字符串
 *
 *  @param date    日期
 *  @param format 格式
 *
 *  @return
 */
+ (NSString*)stringWithDate:(NSDate*)date withFormat:(NSString*)format;

/**
 *  将iOS默认GMT时间转换为北京时间
 *
 *  @param date 日期对象
 *
 *  @return date
 */
+ (NSDate*)dateWithBeijing:(NSDate*)date;

@end
