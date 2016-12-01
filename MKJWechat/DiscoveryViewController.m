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
#import "ChatKeyBoard.h"
#import "FaceSourceManager.h"
#import "MLTransition.h"
#import "CommentTableViewCell.h"


@interface DiscoveryViewController () <UITableViewDelegate,UITableViewDataSource,MKJFriendTableCellDelegate,UIScrollViewDelegate,ChatKeyBoardDelegate,ChatKeyBoardDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *friendsDatas;

// 记录上一次点击的cell
@property (nonatomic,strong) MKJFriendTableViewCell *lastTempCell;

// 聊天键盘
@property (nonatomic,strong) ChatKeyBoard *chatKeyBoard;
// 判断键盘是否isShowing
@property (nonatomic,assign) BOOL isKeyboardShowing;

// 记录点击cell或者comment在window中的Y偏移量
@property (nonatomic,assign) CGFloat touch_offset_y;
// 记录点击cell或者comment的高度
@property (nonatomic,assign) CGFloat selectedCellHeight;
// 点击commentcell中的当前model
@property (nonatomic,strong) FriendCommentDetail *currentCommentDetail;
// 是否点击cell弹键盘
@property (nonatomic,assign) BOOL isResponseByCell;
// 最外层朋友圈评论数组的cellindex
@property (nonatomic,strong) NSIndexPath *parentCurrentIndexpath;


@end

static NSString *identify = @"MKJFriendTableViewCell";

@implementation DiscoveryViewController


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"dealloc--->%s",object_getClassName(self));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.disableMLTransition = YES;
    [self.tableView registerNib:[UINib nibWithNibName:identify bundle:nil] forCellReuseIdentifier:identify];
    self.tableView.tableFooterView = [UIView new];
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    refreshHeader.stateLabel.hidden = YES;
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = refreshHeader;
    [self.tableView.mj_header beginRefreshing];
    
    //注册键盘出现NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    
    //注册键盘隐藏NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    self.chatKeyBoard  = [ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
    self.chatKeyBoard = [ChatKeyBoard keyBoardWithParentViewBounds:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.chatKeyBoard.delegate = self;
    self.chatKeyBoard.dataSource = self;
    self.chatKeyBoard.placeHolder = @"你是猴子派来输入消息的么";
    self.chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
    self.chatKeyBoard.allowVoice = NO;
    self.chatKeyBoard.allowSwitchBar = NO;
    self.chatKeyBoard.allowMore = YES;
    [self.view addSubview:self.chatKeyBoard];
    [self.view bringSubviewToFront:self.chatKeyBoard];
}


#pragma mark - chatKeyboard代理方法
#pragma mark -- ChatKeyBoardDataSource
- (NSArray<MoreItem *> *)chatKeyBoardMorePanelItems
{
    MoreItem *item1 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item2 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item3 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    MoreItem *item4 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item5 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item6 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    MoreItem *item7 = [MoreItem moreItemWithPicName:@"sharemore_location" highLightPicName:nil itemName:@"位置"];
    MoreItem *item8 = [MoreItem moreItemWithPicName:@"sharemore_pic" highLightPicName:nil itemName:@"图片"];
    MoreItem *item9 = [MoreItem moreItemWithPicName:@"sharemore_video" highLightPicName:nil itemName:@"拍照"];
    return @[item1, item2, item3, item4, item5, item6, item7, item8, item9];
}
- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    
    ChatToolBarItem *item2 = [ChatToolBarItem barItemWithKind:kBarItemVoice normal:@"voice" high:@"voice_HL" select:@"keyboard"];
    
    ChatToolBarItem *item3 = [ChatToolBarItem barItemWithKind:kBarItemMore normal:@"more_ios" high:@"more_ios_HL" select:nil];
    
    ChatToolBarItem *item4 = [ChatToolBarItem barItemWithKind:kBarItemSwitchBar normal:@"switchDown" high:nil select:nil];
    
    return @[item1, item2, item3, item4];
}

- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}




#pragma mark - 键盘的代理 show or hidden
- (void)keyboardWillShow:(NSNotification *)noti
{
    self.isKeyboardShowing = YES;
    NSDictionary *userInfo = noti.userInfo;
    CGFloat keyboardHeight = [[userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat delta = 0;
    CGFloat topOffsetKeyboard = 0;
    if (self.isResponseByCell)
    { // 是通过点击cell触发键盘
        topOffsetKeyboard = [UIScreen mainScreen].bounds.size.height - keyboardHeight - kChatToolBarHeight - self.selectedCellHeight - 20;
        
    }
    else // 点击comment触发
    {
        topOffsetKeyboard = [UIScreen mainScreen].bounds.size.height - keyboardHeight - kChatToolBarHeight - 30;
    }
    delta = self.touch_offset_y - topOffsetKeyboard;
    
    CGFloat contentOffset = self.tableView.contentOffset.y; // 这个指的是顶部tableView滚动的距离
    contentOffset += delta; // delta + 下拉  -上拉
    if (contentOffset <= -64) {
        contentOffset = -64;
    }
    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, contentOffset) animated:YES];
}


- (void)keyboardWillHide:(NSNotification *)noti
{
    self.isKeyboardShowing = NO;
    
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
    // headerImage 头像 实现渐隐效果
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
    
    // name 名字
    cell.nameLabel.text = issueInfo.userName;
    
    // description 描述 根据配置在数据源的是否展开字段确定行数
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
    
    // 全文label 根据文字的高度是否展示全文lable  点击事件通过数据源来交互
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

    
    // img  九宫格图片，用collectionView做
    cell.imageDatas = [[NSMutableArray alloc] initWithArray:issueInfo.messageSmallPics];
    cell.imageDatasBig = [[NSMutableArray alloc] initWithArray:issueInfo.messageBigPics];
    [cell.collectionView reloadData];
    // 这里可以用lauout来获取其高度，但是由于嵌套的关系，可能算不准，我们还是手动算好了
//    [cell.collectionView layoutIfNeeded];
//    cell.colletionViewHeight.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height;
    CGFloat width = SCREEN_WIDTH - 90 - 20;
    // 没图片就高度为0 （约束是可以拖出来的哦哦）
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
    
    // timeStamp  时间
    cell.timeLabel.text = issueInfo.timeTag;
    
    // right action button  弹出黑色点赞或者评论的框
    cell.isShowPopView = NO;
    cell.backPopViewWidth.constant = 0;
    
    // right action button inline like button state   按钮状态也是根据数据源配置
    if (issueInfo.hadClickLike) {
        [cell.likeButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    else
    {
        [cell.likeButton setTitle:@"赞" forState:UIControlStateNormal];
    }
    cell.hadLikeActivityMessage = issueInfo.hadClickLike; // 默认都是没有点赞
    
    // commentTableView  评论的taibleView
    // 这里的思路也是可以根据contentSize获取，但是貌似又可能算不准，我还是手动计算，思路就是
    // 最后一个cell的Y轴坐标加上其高度就是算出来的高度啦
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
    if (self.isKeyboardShowing) {
        [self.chatKeyBoard keyboardDownForComment];
    }
    [self dealLastAction];
    NSIndexPath *clickIndexPath = [self.tableView indexPathForCell:cell];
    FriendIssueInfo *issueInfo = self.friendsDatas[clickIndexPath.row];
    issueInfo.isExpand = isExpand;
    [self.tableView reloadRowsAtIndexPaths:@[clickIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}


#pragma mark - 2.点击展开黑色浮层评论
- (void)clickShowComment:(MKJFriendTableViewCell *)cell isShow:(BOOL)isShow
{
    if (self.isKeyboardShowing) {
        [self.chatKeyBoard keyboardDownForComment];
    }
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

#pragma mark - 点击cel里面collection和tableview的触发时间回调`
- (void)clickColletionViewOrTableViewCallBack:(MKJFriendTableViewCell *)cell
{
    if (self.isKeyboardShowing) {
        [self.chatKeyBoard keyboardDownForComment];
    }
    [self dealLastAction];
}


#pragma mark - 点击commentTableView里面的一段段评论进行键盘弹起回调
- (void)clickTableViewCommentShowKeyboard:(MKJFriendTableViewCell *)cell tableViewIndex:(NSIndexPath *)currentIndexpath tableView:(UITableView *)tableView currentHeight:(CGFloat)currentHeight
{
    NSIndexPath *waicengIndexpath = [self.tableView indexPathForCell:cell];
    CommentTableViewCell *commentCell = [tableView cellForRowAtIndexPath:currentIndexpath];
    CGRect rec = [commentCell.commentLabel convertRect:commentCell.commentLabel.bounds toView:[UIApplication sharedApplication].keyWindow];
    self.touch_offset_y = rec.origin.y; // 点击那一栏的Y坐标
    self.selectedCellHeight = currentHeight; // 点击那一栏的高度
    self.isResponseByCell = YES; // 是cell激活键盘
    self.currentCommentDetail = [self.friendsDatas[waicengIndexpath.row] commentMessages][currentIndexpath.row]; // 点击的是哪个commentmodel
    self.parentCurrentIndexpath = waicengIndexpath; // 外侧cellindexpath
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复:%@",self.currentCommentDetail.commentUserName]; // 楼中楼就是回复
    [self.chatKeyBoard keyboardUpforComment];
}

#pragma mark -- 键盘更多
- (void)chatKeyBoard:(ChatKeyBoard *)chatKeyBoard didSelectMorePanelItemIndex:(NSInteger)index
{
    NSString *message = [NSString stringWithFormat:@"选择的ItemIndex %zd", index];
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"ItemIndex" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertV show];
}

#pragma mark -- 键盘发送文本
- (void)chatKeyBoardSendText:(NSString *)text
{
    
    // 这里的text对应的是发送的文本
    FriendCommentDetail *newComment = [[FriendCommentDetail alloc] init];
    
    if (self.isResponseByCell)
    {
        newComment.commentByPhoto = @"";
        newComment.commentByUserId = self.currentCommentDetail ? self.currentCommentDetail.commentUserId : @"";
        newComment.commentByUserName = self.currentCommentDetail ? self.currentCommentDetail.commentUserName :@"";
        newComment.commentId = [NSString stringWithFormat:@"%d",arc4random() % 10 + 1];
        newComment.commentPhoto = @"";
        newComment.commentText = text;
        newComment.commentUserId = @"12345678";
        newComment.commentUserName = @"宓珂璟";
        newComment.createDateStr = @"一万千以前";
    }
    else
    {
        newComment.commentByPhoto = @"";
        newComment.commentByUserId = @"0";
        newComment.commentByUserName = @"";
        newComment.commentId = [NSString stringWithFormat:@"%d",arc4random() % 10 + 1];
        newComment.commentPhoto = @"";
        newComment.commentText = text;
        newComment.commentUserId = @"12345678";
        newComment.commentUserName = @"宓珂璟";
        newComment.createDateStr = @"一万千以前";
    }
    
    
    NSMutableArray *comments = [self.friendsDatas[self.parentCurrentIndexpath.row] commentMessages];
    [comments addObject:newComment];
    [self.tableView reloadRowsAtIndexPaths:@[self.parentCurrentIndexpath] withRowAnimation:UITableViewRowAnimationFade];
    [self.chatKeyBoard keyboardDownForComment];
}


#pragma mark - 点击评论进行评价
- (void)clickPopCommnet:(MKJFriendTableViewCell *)cell
{
    NSIndexPath *waicengIndexpath = [self.tableView indexPathForCell:cell];
    FriendIssueInfo *info = self.friendsDatas[waicengIndexpath.row];
    CGRect rec = [cell.commentButton convertRect:cell.commentButton.bounds toView:[UIApplication sharedApplication].keyWindow];
    self.touch_offset_y = rec.origin.y; // 点击那一栏的Y坐标
    self.selectedCellHeight = 30; // 点击那一栏的高度
    self.isResponseByCell = NO; // 是cell激活键盘
    self.currentCommentDetail = nil;
    self.parentCurrentIndexpath = waicengIndexpath; // 外侧cellindexpath
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"评论:%@",info.userName]; // 评论
    [self.chatKeyBoard keyboardUpforComment];
    [self dealLastAction];
}


#pragma mark - 点赞
- (void)clickLikeButton:(MKJFriendTableViewCell *)cell isLike:(BOOL)isLike
{
    NSIndexPath *waicengIndexpath = [self.tableView indexPathForCell:cell];
    FriendIssueInfo *info = self.friendsDatas[waicengIndexpath.row];
    info.hadClickLike = isLike;
    self.parentCurrentIndexpath = waicengIndexpath; // 外侧cellindexpath
    // 这里点赞就随便配置下了
    FriendCommentDetail *newComment = [[FriendCommentDetail alloc] init];

    newComment.commentByPhoto = @"";
    newComment.commentByUserId = @"0";
    newComment.commentByUserName = @"";
    newComment.commentId = [NSString stringWithFormat:@"%d",arc4random() % 10 + 1];
    newComment.commentPhoto = @"";
    newComment.commentText = @"💖 宓珂璟";
    newComment.commentUserId = @"12345678";
    newComment.commentUserName = @"宓珂璟";
    newComment.createDateStr = @"一万千以前";
    newComment.isLike = info.hadClickLike;
    
    
    
    NSMutableArray *comments = [self.friendsDatas[self.parentCurrentIndexpath.row] commentMessages];
    if (isLike) {
        if ([NSArray isEmpty:comments])
        {
            [comments addObject:newComment];
        }
        else
        {
            [comments insertObject:newComment atIndex:0];
        }
    }
    else
    {
        [comments removeObjectAtIndex:0];
    }
    
    
    [self.tableView reloadRowsAtIndexPaths:@[self.parentCurrentIndexpath] withRowAnimation:UITableViewRowAnimationFade];
    [self dealLastAction];
}



#pragma mark - 滚动tableview的时候
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%lf",scrollView.contentOffset.y);
    [self dealLastAction];
}


#pragma mark - 将要被拽动的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isKeyboardShowing) {
        [self.chatKeyBoard keyboardDownForComment];
    }
    
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
