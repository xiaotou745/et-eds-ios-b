//
//  TestJSObject.h
//  ESend
//
//  Created by 台源洪 on 15/11/13.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol TestJSObjectProtocol <JSExport>

-(void)TestTowParameter:(NSString *)message1 SecondParameter:(NSString *)message2 ThirdParameter:(NSString *)message3;

@end

@interface TestJSObject : NSObject<TestJSObjectProtocol>

@end
