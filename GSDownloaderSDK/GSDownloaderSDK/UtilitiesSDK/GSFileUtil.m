//
//  GSFileUtil.m
//  GSDownloaderSDK
//
//  Created by Chaoqian Wu on 14-3-5.
//  Copyright (c) 2014年 4399 Network CO.ltd. All rights reserved.
//

#import "GSFileUtil.h"

@implementation GSFileUtil

+ (unsigned long long)fileSizeForPath:(NSString*)path
{
    unsigned long long fileSize = 0;
    
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    
    if ([fileManager fileExistsAtPath:path]) {
        NSError* error = nil;
        NSDictionary* fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    
    return fileSize;
}

+ (NSString*)tempPathFor:(NSString*)path saveIn:(NSString *)saveIn
{
    NSString* tempFilePath = nil;
    
    NSString* tempFileName = [path lastPathComponent];
    
    tempFilePath = [[GSFileUtil getPathInCacheDirBy:saveIn createIfNotExist:YES] stringByAppendingPathComponent:tempFileName];
    
    return tempFilePath;
}

+ (NSString*)getPathInDocumentsDirBy:(NSString*)subFolder createIfNotExist:(BOOL)needCeate
{
    NSString* subPath;
    
    NSString* dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    subPath = [dir stringByAppendingPathComponent:subFolder];
    
    if (![GSFileUtil fileExistsAtPath:subPath])
    {
        if (needCeate)
        {
            NSError* error = nil;
            if (![[NSFileManager new] createDirectoryAtPath:subPath withIntermediateDirectories:YES attributes:nil error:&error]) {
                NSLog(@"创建%@失败,Error=%@", subFolder,error);
            }
        }
    }
    
    return subPath;
}

+ (NSString*)getPathInCacheDirBy:(NSString*)subFolder createIfNotExist:(BOOL)needCeate
{
    
    NSString* subPath;
    
    NSString* dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Cache"];
    subPath = [dir stringByAppendingPathComponent:subFolder];
    
    if (![GSFileUtil fileExistsAtPath:subPath])
    {
    
        if (needCeate)
        {
            NSError* error = nil;
            if (![[NSFileManager new] createDirectoryAtPath:subPath withIntermediateDirectories:YES attributes:nil error:&error]) {
                NSLog(@"创建%@失败,Error=%@", subFolder,error);
            }
        }
    }
    
    return subPath;
}

+ (BOOL)fileExistsAtPath:(NSString *)path
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    BOOL isExist = [fileManager fileExistsAtPath:path];
    
    // NSLog(@"fileExistsAtPath:%@ = %@",path, (isExist ? @"YES" : @"NO"));
    
    return isExist;
    
}

+ (BOOL)deleteFileAtPath:(NSString *)path
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    BOOL result = NO;
    
    if ([GSFileUtil fileExistsAtPath:path])
    {
        result = [fileManager removeItemAtPath:path error:&error];
    }
    else
    {
        result = YES;
    }
    
    if (error)
    {
        // NSLog(@"removeItemAtPath:%@ 失败,error = %@",path,error);
    }
    else
    {
        // NSLog(@"removeItemAtPath:%@ 成功,error = %@",path,error);
    }
    
    return result;
}

+ (BOOL) cutFileAtPath:(NSString *)srcPath toPath:(NSString *)dstPath
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    BOOL result = NO;
    
    if ([GSFileUtil deleteFileAtPath:dstPath])
    {
        
        if ([GSFileUtil fileExistsAtPath:srcPath])
        {
            result = [fileManager moveItemAtPath:srcPath toPath:dstPath error:&error];
        }
        
    }
    
    if (error)
    {
        // NSLog(@"moveItemAtPath:%@ toPath:%@ 失败,error = %@",srcPath,dstPath,error);
    }
    else
    {
        // NSLog(@"moveItemAtPath:%@ toPath:%@ 成功,error = %@",srcPath,dstPath,error);
    }
    
    return result;
}

@end
