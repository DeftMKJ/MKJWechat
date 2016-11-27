//
//  DiscoveryViewController.m
//  MKJWechat
//
//  Created by MKJING on 16/8/17.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "FriendsCircleModel.h"
#import "MKJFriendTableViewCell.h"
#import <MJRefresh.h>
#import "MKJRequestHelp.h"
#import <UIImageView+WebCache.h>
#import <UITableView+FDTemplateLayoutCell.h>
#import "NSArray+CP.h"

@interface DiscoveryViewController () <UITableViewDelegate,UITableViewDataSource,MKJFriendTableCellDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *friendsDatas;

// 记录上一次点击的cell
@property (nonatomic,strong) MKJFriendTableViewCell *lastTempCell;

@end

static NSString *identify = @"MKJFriendTableViewCell";

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:identify bundle:nil] forCellReuseIdentifier:identify];
    self.tableView.tableFooterView = [UIView new];
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    refreshHeader.stateLabel.hidden = YES;
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHeader;
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - 请求数据
- (void)requestData
{
    __weak typeof(self)weakSelf = self;
    [[MKJRequestHelp shareRequestHelp] configFriendListsInfo:^(id obj, NSError *err) {
       
        FriendResultData *data = (FriendResultData *)obj;
        weakSelf.friendsDatas = data.data.rows;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        
        
        
    }];
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKJFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [self configCell:cell indexpath:indexPath];
    return cell;
}

- (void)configCell:(MKJFriendTableViewCell *)cell indexpath:(NSIndexPath *)indexpath
{
    __weak typeof(cell)weakCell = cell;
    FriendIssueInfo *issueInfo = self.friendsDatas[indexpath.row];
    // headerImage
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:issueInfo.photo] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        if (image && cacheType == SDImageCacheTypeNone)
        {
            weakCell.headerImageView.alpha = 0;
            [UIView animateWithDuration:0.8 animations:^{
                weakCell.headerImageView.alpha = 1.0f;
            }];
        }
        else
        {
            weakCell.headerImageView.alpha = 1.0f;
        }
    }];
    
    // name
    cell.nameLabel.text = issueInfo.userName;
    
    // description
    cell.desLabel.text = issueInfo.message;
    cell.isExpand = issueInfo.isExpand;
    if (issueInfo.isExpand)
    {
        cell.desLabel.numberOfLines = 0;
        
    }
    else
    {
        cell.desLabel.numberOfLines = 3;
    }
    
    // 全文label
    CGSize rec = [issueInfo.message boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 90, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14]} context:nil].size;
    if (rec.height > 55) {
        cell.showAllDetailsButton.hidden = NO;
        cell.showAllHeight.constant = 15;
    }
    else
    {
        cell.showAllHeight.constant = 0;
        cell.showAllDetailsButton.hidden = YES;
    }

    
    // img
    cell.imageDatas = [[NSMutableArray alloc] initWithArray:issueInfo.messageSmallPics];
    cell.imageDatasBig = [[NSMutableArray alloc] initWithArray:issueInfo.messageBigPics];
    [cell.collectionView reloadData];
//    [cell.collectionView layoutIfNeeded];
//    cell.colletionViewHeight.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height;
    CGFloat width = SCREEN_WIDTH - 90 - 20;
    if ([NSArray isEmpty:issueInfo.messageSmallPics])
    {
        cell.colletionViewHeight.constant = 0;
    }
    else
    {
        if (issueInfo.messageSmallPics.count == 1)
        {
            cell.colletionViewHeight.constant = width / 1.5;
        }
        else
        {
            cell.colletionViewHeight.constant = ((issueInfo.messageSmallPics.count - 1) / 3 + 1) * (width / 3) + (issueInfo.messageSmallPics.count - 1) / 3 * 15;
        }
    }
    
    // timeStamp
    cell.timeLabel.text = issueInfo.timeTag;
    
    // right action button
    cell.isShowPopView = NO;
    cell.backPopViewWidth.constant = 0;
    
    // commentTableView
    cell.commentdatas = [[NSMutableArray alloc] initWithArray:issueInfo.commentMessages];
    [cell.commentTableView reloadData];
    CGRect recHeight = CGRectZero;
    if (![NSArray isEmpty:issueInfo.commentMessages])
    {
        recHeight = [cell.commentTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:issueInfo.commentMessages.count - 1 inSection:0]];
    }
    
    
    cell.tableViewHeight.constant = recHeight.origin.y + recHeight.size.height;
//    NSLog(@"%@,heightTable%f",indexpath,cell.tableViewHeight.constant);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:identify cacheByIndexPath:indexPath configuration:^(MKJFriendTableViewCell *cell) {
        
        [self configCell:cell indexpath:indexPath];
        
    }];
    
    
//    return [tableView fd_heightForCellWithIdentifier:identify configuration:^(MKJFriendTableViewCell *cell) {
//       
//        [self configCell:cell indexpath:indexPath];
//    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dealLastAction];
}


#pragma mark - cell的代理  
#pragma mark - 1.点击代理全文展开回调
- (void)clickShowAllDetails:(MKJFriendTableViewCell *)cell expand:(BOOL)isExpand
{
    [self dealLastAction];
    NSIndexPath *clickIndexPath = [self.tableView indexPathForCell:cell];
    FriendIssueInfo *issueInfo = self.friendsDatas[clickIndexPath.row];
    issueInfo.isExpand = isExpand;
    [self.tableView reloadRowsAtIndexPaths:@[clickIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}


#pragma mark - 2.点击展开黑色浮层评论
- (void)clickShowComment:(MKJFriendTableViewCell *)cell isShow:(BOOL)isShow
{
    if (self.lastTempCell != cell) {
       [self dealLastAction];
    }
    
    NSIndexPath *clickIndexPath = [self.tableView indexPathForCell:cell];
    if (isShow) {
        cell.backPopViewWidth.constant = 135;
    }
    else
    {
        cell.backPopViewWidth.constant = 0;
    }
    
    [UIView animateWithDuration:.3 animations:^{
        [cell.contentView layoutIfNeeded];
    }];
    self.lastTempCell = cell;
    
}

#pragma mark - 点击cel里面collection和tableview的触发时间回调
- (void)clickColletionViewOrTableViewCallBack:(MKJFriendTableViewCell *)cell
{
    [self dealLastAction];
}


#pragma mark - 点击评论进行评价


#pragma mark - 点赞


#pragma mark - 点击底部评论进行评论


#pragma mark - 滚动tableview的时候
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self dealLastAction];
}


// 回收上次弹出的PopView
- (void)dealLastAction
{
    if (self.lastTempCell)
    {
        if (self.lastTempCell.isShowPopView) {
            self.lastTempCell.backPopViewWidth.constant = 0;
            [UIView animateWithDuration:0.3 animations:^{
                [self.lastTempCell.contentView layoutIfNeeded];
                self.lastTempCell.isShowPopView = NO;
                self.lastTempCell = nil;
            } completion:nil];

        }
    }
}
- (NSMutableArray *)friendsDatas
{
    if (_friendsDatas == nil) {
        _friendsDatas = [[NSMutableArray alloc] init];
    }
    return _friendsDatas;
}


















@end
