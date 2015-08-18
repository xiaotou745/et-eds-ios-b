
//
//  FHQNetWorkingKit.m
//  USA
//
//  Created by 永来 付 on 14/11/27.
//  Copyright (c) 2014年 fuhuaqi. All rights reserved.
//

#import "FHQNetWorkingKit.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Encryption.h"

@implementation FHQNetWorkingKit

+ (AFHTTPRequestOperation*)httpRequestWithUrl:(NSString*)urlString
                                   methodType:(NSString*)methodType
                                    prameters:(NSDictionary*)pramaters
                                      success:(successBlock)successBlock
                                      failure:(failureBlock)failBlock {
    
    return [self httpRequestWithUrl:urlString
                         methodType:methodType
                          prameters:pramaters
                            success:successBlock
                            failure:failBlock
                    isShowFailAlert:YES
                    failAlertString:nil];
}

+ (AFHTTPRequestOperation*)httpRequestWithUrl:(NSString*)urlString
                                   methodType:(NSString*)methodType
                                    prameters:(NSDictionary*)pramaters
                                      success:(successBlock)successBlock
                                      failure:(failureBlock)failBlock
                              isShowFailAlert:(BOOL)isShowFailAlert
                              failAlertString:(NSString*)failAlertString {
    
    AFHTTPRequestOperationManager *manager = [self getHTTPSessionManagerWithHost:nil];
    AFHTTPRequestOperation *operation = nil;
    
    //post请求
    if ([[methodType uppercaseString] isEqualToString:@"POST"]) {
         operation = [manager POST:urlString
                       parameters:pramaters
                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *error = [self fiterResult:responseObject];

            if (error) {
                if (failBlock) {
                    failBlock (error, operation);
                }
                
                if (isShowFailAlert) {
                    NSString *message = isCanUseString(failAlertString) ? failAlertString : [responseObject objectForKey:@"Message"];
                    [self showFailAlert:error message:message];
                }
                
            } else if (successBlock) {
                successBlock([responseObject objectForKey:@"Result"], operation) ;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            if (operation.response.statusCode == 200) {
                NSLog(@"%@",operation.responseString);
            } else {
                NSLog(@"%@",error);
            }
            
            if (failBlock) {
                failBlock (error, operation);
                if (isShowFailAlert) {
                    [self showFailAlert:error message:failAlertString];
                }
            }
        }];
        
    } else {
       
        //get请求
        operation = [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *error = [self fiterResult:responseObject];

            if (error) {
                if (failBlock) {
                    failBlock (error, operation);
                    if (isShowFailAlert) {
                        NSString *message = isCanUseString(failAlertString) ? failAlertString : [responseObject objectForKey:@"Message"];
                        [self showFailAlert:error message:message];
                    }
                }
            } else if (successBlock) {
                successBlock([responseObject objectForKey:@"Result"], operation) ;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            if (operation.response.statusCode == 200) {
                NSLog(@"%@",operation.responseString);
            } else {
                NSLog(@"%@",error);
            }
            
            if (failBlock) {
                failBlock (error, operation);
                if (isShowFailAlert) {
                    [self showFailAlert:error message:failAlertString];
                }
            }
        }];
    }
    
    return operation;
}

+ (AFHTTPRequestOperation*)httpRequestWithUrl:(NSString*)urlString
                                   methodType:(NSString*)methodType
                                    prameters:(NSDictionary*)pramaters
                                   imageDatas:(NSArray*)imageDatas
                                      success:(successBlock)successBlock
                                      failure:(failureBlock)failBlock
                              isShowFailAlert:(BOOL)isShowFailAlert
                              failAlertString:(NSString*)failAlertString {
    return [self httpRequestWithUrl:urlString
                  methodType:methodType
                   prameters:pramaters
                  imageDatas:imageDatas
                     success:successBlock
                     failure:failBlock
             isShowFailAlert:isShowFailAlert
             failAlertString:failAlertString
                        host:nil];

}

+ (AFHTTPRequestOperation*)httpRequestWithUrl:(NSString *)urlString
                                   methodType:(NSString *)methodType
                                    prameters:(NSDictionary *)pramaters
                                    imageDatas:(NSArray *)imageDatas
                                      success:(successBlock)successBlock
                                      failure:(failureBlock)failBlock
                              isShowFailAlert:(BOOL)isShowFailAlert
                              failAlertString:(NSString *)failAlertString
                                         host:(NSString *)host {
    AFHTTPRequestOperationManager *manager = [self getHTTPSessionManagerWithHost:host];
    AFHTTPRequestOperation *operation = nil;
    
    //post请求
    if ([[methodType uppercaseString] isEqualToString:@"POST"]) {
        operation = [manager POST:urlString
                       parameters:pramaters
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                           for (UploadImageModel *imageModel in imageDatas) {
                               NSLog(@"filename:%@ file:%@ length:%ld",imageModel.imageFileName,imageModel.imageName, (unsigned long)imageModel.imageData.length);
                               int i = 0;
                               if (imageModel.imageData && imageModel.imageData.length > 0) {
                                   [formData appendPartWithFileData:imageModel.imageData
                                                               name:imageModel.imageName
                                                           fileName:imageModel.imageFileName
                                                           mimeType:@""];
                                   i++;
                               }
                           }
                           

                       }
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              NSError *error = [self fiterResult:responseObject];
                              
                              if (error) {
                                  if (failBlock) {
                                      failBlock (error, operation);
                                  }
                                  
                                  if (isShowFailAlert) {
                                      NSString *message = isCanUseString(failAlertString) ? failAlertString : [responseObject objectForKey:@"Message"];
                                      [self showFailAlert:error message:message];
                                  }
                                  
                              } else if (successBlock) {
                                  successBlock([responseObject objectForKey:@"Result"], operation) ;
                              }
                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              
                              if (operation.response.statusCode == 200) {
                                  NSLog(@"%@",operation.responseString);
                              } else {
                                  NSLog(@"%@",error);
                              }
                              
                              if (failBlock) {
                                  failBlock (error, operation);
                                  if (isShowFailAlert) {
                                      [self showFailAlert:error message:failAlertString];
                                  }
                              }
                          }];
        
    } else {
        //get请求
        operation = [manager GET:urlString parameters:pramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *error = [self fiterResult:responseObject];
            
            if (error) {
                if (failBlock) {
                    failBlock (error, operation);
                    if (isShowFailAlert) {
                        NSString *message = isCanUseString(failAlertString) ? failAlertString : [responseObject objectForKey:@"Message"];
                        [self showFailAlert:error message:message];
                    }
                }
            } else if (successBlock) {
                successBlock([responseObject objectForKey:@"Result"], operation) ;
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if (operation.response.statusCode == 200) {
                NSLog(@"%@",operation.responseString);
            } else {
                NSLog(@"%@",error);
            }
            
            if (failBlock) {
                failBlock (error, operation);
                if (isShowFailAlert) {
                    [self showFailAlert:error message:failAlertString];
                }
            }
        }];
    }
    return operation;
}

+ (AFHTTPRequestOperationManager*)getHTTPSessionManagerWithHost:(NSString*)host {
    
    NSURL *url = nil;
    if (isCanUseString(host)) {
        url = [NSURL URLWithString:host];
    } else {
        url = [NSURL URLWithString:OPEN_API_SEVER];
    }
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
   manager.requestSerializer = [AFJSONRequestSerializer serializer];
   manager.requestSerializer.timeoutInterval = 30;
    
    NSDictionary * headerDict = [Encryption ESendB_Encryptioin];
    //NSLog(@"headerDicts:%@",headerDict);
    NSArray * keys = [headerDict allKeys];
    for (NSString * key in keys) {
       // NSLog(@"key:%@",key);
       // NSLog(@"value:%@",[headerDict objectForKey:key]);
        [manager.requestSerializer setValue:[headerDict objectForKey:key] forHTTPHeaderField:key];
    }
    
//    [manager.requestSerializer setValue:[Encryption createEncryption] forHTTPHeaderField:@"YgUsFood"];
//    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    return manager;
}

//错误提示
+ (void)showFailAlert:(NSError*)error message:(NSString*)message {
    if (isCanUseString(message)) {
        [Tools showHUD:message];
    } else {
        if (error.code == -1001) {
            [Tools showHUD:@"请求超时"];
        } else if (error.code == -1009) {
            [Tools showHUD:@"请检查网络连接"];
        } else {
            [Tools showHUD:@"请求失败"];
        }
    }
}

//返回数据拦截
+ (NSError*)fiterResult:(id)responseObject {
    
    NSError *error = nil;
    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
        NSInteger code = [[responseObject objectForKey:@"Status"] integerValue];
        if (code != 1) {
            error = [NSError errorWithDomain:@"BussineError" code:code userInfo:responseObject];
//            [Tools showHUD:[responseObject objectForKey:@"Message"]];
        }
    } else {
        error = [[NSError alloc] initWithDomain:@"ServiceError" code:-10000 userInfo:@{@"message" : @"请求失败"}];
    }
    return error;
}

@end
