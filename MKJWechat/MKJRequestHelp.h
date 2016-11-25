//
//  MKJRequestHelp.h
//  MKJWechat
//
//  Created by MKJING on 16/8/18.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completeBlock)(id obj,NSError *err);

@interface MKJRequestHelp : NSObject

+ (instancetype)shareRequestHelp;

- (void)configAddressInfo:(completeBlock)complete;

- (void)configFriendListsInfo:(completeBlock)complete;

@end
