//
//  MKJRequestHelp.m
//  MKJWechat
//
//  Created by MKJING on 16/8/18.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "MKJRequestHelp.h"
#import <MJExtension.h>
#import "AddressModel.h"
#import "FriendsCircleModel.h"

@implementation MKJRequestHelp

static id _requestHelp;

+ (instancetype)shareRequestHelp
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _requestHelp = [[self alloc] init];
    });
    return _requestHelp;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _requestHelp = [super allocWithZone:zone];
    });
    return _requestHelp;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _requestHelp;
}

- (void)configAddressInfo:(completeBlock)complete
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AddressBook" ofType:@"json"];
    NSString *addString = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
    NSDictionary *rootDic = [addString mj_JSONObject];
    [AddressData mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"allFriends":@"friends"};
    }];
    
    [AllFriendData mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"allFriendsArr":@"row"};
    }];
    [AllFriendData mj_setupObjectClassInArray:^NSDictionary *{
        
        return @{@"allFriendsArr":@"FriendInfo"};
    }];
    AddressData *addressData = [AddressData mj_objectWithKeyValues:rootDic];
    if (complete)
    {
        complete(addressData,nil);
    }
}


- (void)configFriendListsInfo:(completeBlock)complete
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSString *friendString = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
    NSDictionary *rootDict = [friendString mj_JSONObject];
    
     [FriendActivityData mj_setupObjectClassInArray:^NSDictionary *{
         return @{@"rows":@"FriendIssueInfo"};
     }];

    [FriendIssueInfo mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"messageBigPics":@"NSString",@"messageSmallPics":@"NSString",@"commentMessages":@"FriendCommentDetail"};
    }];
    
    FriendResultData *data = [FriendResultData mj_objectWithKeyValues:rootDict];
    if (complete) {
        complete(data,nil);
    }
}

@end





























