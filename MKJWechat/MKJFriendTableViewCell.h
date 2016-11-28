//
//  MKJFriendTableViewCell.h
//  MKJWechat
//
//  Created by MKJING on 16/11/25.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MKJFriendTableViewCell;

@protocol MKJFriendTableCellDelegate <NSObject>
// 点击全文回调展开
- (void)clickShowAllDetails:(MKJFriendTableViewCell *)cell expand:(BOOL)isExpand;

// 点击展开评论和点赞浮层
- (void)clickShowComment:(MKJFriendTableViewCell *)cell isShow:(BOOL)isShow;

// collection和tableview的事件触发，也要同时收起View (tableView,这个方法给collectionView用)
- (void)clickColletionViewOrTableViewCallBack:(MKJFriendTableViewCell *)cell;

// 点击tableView里面的评论进行回调谈键盘
- (void)clickTableViewCommentShowKeyboard:(MKJFriendTableViewCell *)cell tableViewIndex:(NSIndexPath *)currentIndexpath tableView:(UITableView *)tableView currentHeight:(CGFloat)currentHeight;

// 点击浮层里面的评论回调
- (void)clickPopCommnet:(MKJFriendTableViewCell *)cell;

// 点击浮层里面的点赞回调
- (void)clickLikeButton:(MKJFriendTableViewCell *)cell isLike:(BOOL)isLike;

@end

@interface MKJFriendTableViewCell : UITableViewCell

@property (nonatomic,assign) id<MKJFriendTableCellDelegate>delegate;

@property (nonatomic,assign) BOOL hadLikeActivityMessage;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView; //!< 头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel; //!< 名字
@property (weak, nonatomic) IBOutlet UILabel *desLabel; //!< 文字发布
@property (nonatomic,assign) BOOL isExpand; //!< 是否展开Desc 用来控制

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView; //!< 九宫格
@property (nonatomic,strong) NSMutableArray *imageDatas; //!< 九宫格数据源 小图
@property (nonatomic,strong) NSMutableArray *imageDatasBig; //!< 大图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colletionViewHeight; //!< 九宫格高度
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; //!< 时间轴
@property (weak, nonatomic) IBOutlet UIButton *actionBtn; //!< 点击弹出来的按钮
@property (nonatomic,assign) BOOL isShowPopView; //!< 是否展示popView 默认都是NO
@property (weak, nonatomic) IBOutlet UITableView *commentTableView; //!< 评论容器
@property (nonatomic,strong) NSMutableArray *commentdatas; //!< 评论的数据源
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight; //!< 评论容器的高度
@property (weak, nonatomic) IBOutlet UIView *backPopView; //!< 弹出黑色框
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backPopViewWidth; //!< 黑框宽度，用来做动画
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showAllHeight;
@property (weak, nonatomic) IBOutlet UIButton *showAllDetailsButton;

@property (weak, nonatomic) IBOutlet UIButton *likeButton; //!< 点赞按钮
@property (weak, nonatomic) IBOutlet UIButton *commentButton; //!< 评论按钮



@end
