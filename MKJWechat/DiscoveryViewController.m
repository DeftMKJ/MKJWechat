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

@interface DiscoveryViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *friendsDatas;

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
    
    // img
    cell.imageDatas = [[NSMutableArray alloc] initWithArray:issueInfo.messageSmallPics];
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
            cell.colletionViewHeight.constant = ((issueInfo.messageSmallPics.count - 1) / 3 + 1) * (width / 3) + (issueInfo.messageSmallPics.count - 1) / 3 * 10;
        }
    }
    
    // timeStamp
    cell.timeLabel.text = issueInfo.timeTag;
    
    // right action button
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


- (NSMutableArray *)friendsDatas
{
    if (_friendsDatas == nil) {
        _friendsDatas = [[NSMutableArray alloc] init];
    }
    return _friendsDatas;
}


















@end
