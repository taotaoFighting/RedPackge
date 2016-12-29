//
//  HttpRequest.h
//  封装网络请求
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HttpRequest : NSObject

@property (nonatomic , strong) NSString *hostString;

+ (void) GetWithUrl:(NSString *)url success:(void(^)(id))success failue:(void(^)(NSError *))failue;

@end
