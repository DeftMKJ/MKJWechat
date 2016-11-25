//
//  MKJFriendTableViewCell.h
//  MKJWechat
//
//  Created by MKJING on 16/11/25.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKJFriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView; //!< 头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel; //!< 名字
@property (weak, nonatomic) IBOutlet UILabel *desLabel; //!< 文字发布

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView; //!< 九宫格
@property (nonatomic,strong) NSMutableArray *imageDatas; //!< 九宫格数据源
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colletionViewHeight; //!< 九宫格高度
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; //!< 时间轴
@property (weak, nonatomic) IBOutlet UIButton *actionBtn; //!< 点击弹出来的按钮
@property (weak, nonatomic) IBOutlet UITableView *commentTableView; //!< 评论容器
@property (nonatomic,strong) NSMutableArray *commentdatas; //!< 评论的数据源
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight; //!< 评论容器的高度
@property (weak, nonatomic) IBOutlet UIView *backPopView; //!< 弹出黑色框
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backPopViewWidth; //!< 黑框宽度，用来做动画
@property (weak, nonatomic) IBOutlet UIButton *likeButton; //!< 点赞按钮
@property (weak, nonatomic) IBOutlet UIButton *commentButton; //!< 评论按钮
@end
