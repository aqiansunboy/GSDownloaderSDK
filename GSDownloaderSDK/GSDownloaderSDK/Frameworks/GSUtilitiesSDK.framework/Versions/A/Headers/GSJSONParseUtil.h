//
//  GSJSONParseUtil.h
//  GSCoreCommon
//
//  Created by Chaoqian Wu on 13-12-16.
//  Copyright (c) 2013年 4399 Network CO.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSJSONParseUtil : NSObject

+ (long long)getLongValueInDict:(NSDictionary*)dict withKey:(NSString*)key;

+ (int)getIntValueInDict:(NSDictionary*)dict withKey:(NSString*)key;

+ (BOOL)getBoolValueInDict:(NSDictionary*)dict withKey:(NSString*)key;

+ (float)getFloatValueInDict:(NSDictionary*)dict withKey:(NSString*)key;

+ (NSNumber*)getNumberValueInDict:(NSDictionary*)dict withKey:(NSString*)key;

+ (NSString*)getStringValueInDict:(NSDictionary*)dict withKey:(NSString*)key;

+ (NSDictionary*)getDictionaryValueInDict:(NSDictionary*)dict withKey:(NSString*)key;

+ (NSArray*)getArrayValueInDict:(NSDictionary*)dict withKey:(NSString*)key;

+ (NSMutableArray*)getMutableArrayValueInDict:(NSDictionary*)dict withKey:(NSString*)key;

@end
