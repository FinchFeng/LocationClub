//
//  QiniuCloud.m
//  QiniuCloudTestingProject
//
//  Created by 冯奕琦 on 2019/3/2.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"
#import "HappyDNS.h"
#import "QiniuCloud.h"

@implementation SendDataToImageBed
+(void) sendData:(NSData*)data filename:(NSString *)filename landingAction:(void (^)(void)) action{
    //华东
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNFixedZone zone0];
    }];
    //重用uploadManager。一般地，只需要创建一个uploadManager对象
    NSString * token = @"4-Kmov0TxBv9WZP2zNiujmvmXGPUiuIow0sSQ4Jp:1ItODb8fcXSoD8Y8Qq_MPQxp7vc=:eyJzY29wZSI6ImltYWdlYmVkIiwiZGVhZGxpbmUiOjE1NTE2MjA4NTZ9";
    NSString * key = filename;
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    [upManager putData:data
                   key:key
                 token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  NSLog(@"%@", info);
                  NSLog(@"%@", resp);
                  action();
              } option:nil];
}
@end
