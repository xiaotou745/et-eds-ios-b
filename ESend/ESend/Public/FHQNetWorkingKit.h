//
//  FHQNetWorkingKit.h
//  USA
//
//  Created by 永来 付 on 14/11/27.
//  Copyright (c) 2014年 fuhuaqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UploadImageModel.h"

typedef void (^successBlock) (id result,AFHTTPRequestOperation *operation);
typedef void (^failureBlock) (NSError *error, AFHTTPRequestOperation *operation);

@interface FHQNetWorkingKit : NSObject


/// normal
+ (AFHTTPRequestOperation*)httpRequestWithUrl:(NSString*)urlString
                                   methodType:(NSString*)methodType
                                    prameters:(NSDictionary*)pramaters
                                      success:(successBlock)successBlock
                                      failure:(failureBlock)failBlock;
/// showFailAlert, failAlertString
+ (AFHTTPRequestOperation*)httpRequestWithUrl:(NSString*)urlString
                                   methodType:(NSString*)methodType
                                    prameters:(NSDictionary*)pramaters
                                      success:(successBlock)successBlock
                                      failure:(failureBlock)failBlock
                              isShowFailAlert:(BOOL)isShowFailAlert
                              failAlertString:(NSString*)failAlertString;

/// showFailAlert, failAlertString,host
+ (AFHTTPRequestOperation*)httpRequestWithUrl:(NSString*)urlString
                                   methodType:(NSString*)methodType
                                    prameters:(NSDictionary*)pramaters
                                      success:(successBlock)successBlock
                                      failure:(failureBlock)failBlock
                              isShowFailAlert:(BOOL)isShowFailAlert
                              failAlertString:(NSString*)failAlertString
                                         host:(NSString *)host;


///  uploadimage
+ (AFHTTPRequestOperation*)httpRequestWithUrl:(NSString*)urlString
                                   methodType:(NSString*)methodType
                                    prameters:(NSDictionary*)pramaters
                                    imageDatas:(NSArray*)imageDatas
                                      success:(successBlock)successBlock
                                      failure:(failureBlock)failBlock
                              isShowFailAlert:(BOOL)isShowFailAlert
                              failAlertString:(NSString*)failAlertString;


///  uploadimage,host
+ (AFHTTPRequestOperation*)httpRequestWithUrl:(NSString*)urlString
                                   methodType:(NSString*)methodType
                                    prameters:(NSDictionary*)pramaters
                                   imageDatas:(NSArray*)imageDatas
                                      success:(successBlock)successBlock
                                      failure:(failureBlock)failBlock
                              isShowFailAlert:(BOOL)isShowFailAlert
                              failAlertString:(NSString*)failAlertString
                                         host:(NSString*)host;


///getHTTPSessionManagerWithHost:(NSString*)host
+ (AFHTTPRequestOperationManager*)getHTTPSessionManagerWithHost:(NSString*)host;

@end
