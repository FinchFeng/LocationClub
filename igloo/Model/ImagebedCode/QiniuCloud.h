//
//  QiniuCloud.h
//  QiniuCloudTestingProject
//
//  Created by 冯奕琦 on 2019/3/2.
//  Copyright © 2019 冯奕琦. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef QiniuCloud_h
#define QiniuCloud_h

@interface SendDataToImageBed : NSObject
+(void) sendData:(NSData*)data filename:(NSString *)filename landingAction:(void (^)(void)) action;
@end

#endif /* QiniuCloud_h */
