//
//  FriendsCircleModel.h
//  MKJWechat
//
//  Created by MKJING on 16/11/25.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FriendActivityData;

@interface FriendResultData : NSObject

@property (nonatomic,copy) NSString *msg;
@property (nonatomic,assign) NSInteger result;
@property (nonatomic,strong) FriendActivityData *data;

@end


@interface FriendActivityData : NSObject

@property (nonatomic,strong) NSMutableArray *rows;
@property (nonatomic,assign) NSInteger total;

@end

@interface FriendIssueInfo : NSObject

@property (nonatomic,copy) NSString *cid;
@property (nonatomic,assign) long long createDate;
@property (nonatomic,copy) NSString *createDateStr;
@property (nonatomic,copy) NSString *message; //!< 朋友圈发的文字
@property (nonatomic,assign) BOOL isExpand; // 默认都是NO 
@property (nonatomic,assign) NSInteger message_id;
@property (nonatomic,copy) NSString *message_type; //!< text ext...
@property (nonatomic,copy) NSString *objId;
@property (nonatomic,copy) NSString *photo; //!< 头像
@property (nonatomic,copy) NSString *timeTag; // timeStamp
@property (nonatomic,assign) long long userId;
@property (nonatomic,copy) NSString *userName; //!< 用户名字
@property (nonatomic,strong) NSArray *messageBigPics; //!< 大图
@property (nonatomic,strong) NSArray *messageSmallPics; //!< 小图
@property (nonatomic,strong) NSMutableArray *commentMessages; //!< 评论数组


@end


@interface FriendCommentDetail : NSObject

@property (nonatomic,copy) NSString *checkStatus;
@property (nonatomic,copy) NSString *commentByPhoto; //!< 评论被评论人的头像  这三个都是在评论上进行评论的字段
@property (nonatomic,copy) NSString *commentByUserId; //!< 评论被评论人的ID
@property (nonatomic,copy) NSString *commentByUserName; //!< 评论被评论人的名字
@property (nonatomic,copy) NSString *commentId;
@property (nonatomic,copy) NSString *commentPhoto;
@property (nonatomic,copy) NSString *commentText; //!< 评论的文字
@property (nonatomic,copy) NSString *commentUserId; //!< 评论人的ID
@property (nonatomic,copy) NSString *commentUserName; //!< 评论人的名字
@property (nonatomic,assign) long long  createDate;
@property (nonatomic,copy) NSString *createDateStr;

@end
