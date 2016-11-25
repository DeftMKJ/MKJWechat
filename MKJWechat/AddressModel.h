//
//  AddressModel.h
//  MKJWechat
//
//  Created by MKJING on 16/8/18.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AllFriendData;

@interface AddressData : NSObject
@property (nonatomic,strong) AllFriendData *allFriends;
@end

@interface AllFriendData : NSObject

@property (nonatomic,strong) NSMutableArray *allFriendsArr;

@end

@interface FriendInfo: NSObject

@property (nonatomic,copy) NSString *phoneNO;
@property (nonatomic,copy) NSString *photo;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *userName;

@end
