//
//  MKJFriendTableViewCell.m
//  MKJWechat
//
//  Created by MKJING on 16/11/25.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "MKJFriendTableViewCell.h"
#import "CommentTableViewCell.h"
#import "CommentImageCollectionViewCell.h"
#import "FriendsCircleModel.h"
#import "NSString+CP.h"
#import "NSArray+CP.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "SDPhotoBrowser.h"

@interface MKJFriendTableViewCell () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDPhotoBrowserDelegate>



@end

static NSString *identifyTable = @"CommentTableViewCell";
static NSString *identifyCollection = @"CommentImageCollectionViewCell";

@implementation MKJFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.desLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 90;
    self.nameLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 90;
    self.timeLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 90;
    self.backPopView.layer.cornerRadius = 5.0f;
    self.backPopView.layer.masksToBounds = YES;
    
    
    self.commentTableView.backgroundColor = [UIColor whiteColor];
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
//    self.collectionView.alwaysBounceVertical = YES;
    
    [self.commentTableView registerNib:[UINib nibWithNibName:identifyTable bundle:nil] forCellReuseIdentifier:identifyTable];
    [self.collectionView registerNib:[UINib nibWithNibName:identifyCollection bundle:nil] forCellWithReuseIdentifier:identifyCollection];
    
    
   
}
#pragma mark - 点击全文按钮
- (IBAction)clickShowAll:(UIButton *)sender {
    self.isExpand = !self.isExpand;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickShowAllDetails:expand:)]) {
        [self.delegate clickShowAllDetails:self expand:self.isExpand];
        
    }
}

#pragma mark - 点击展开评论黑色浮层
- (IBAction)clickShowComment:(UIButton *)sender {
    self.isShowPopView = !self.isShowPopView;
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickShowComment:isShow:)]) {
        [self.delegate clickShowComment:self isShow:self.isShowPopView];
    }
}



#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentdatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyTable forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configTableViewCell:cell indexpath:indexPath];
    return cell;
    
}

- (void)configTableViewCell:(CommentTableViewCell *)cell indexpath:(NSIndexPath *)inedxpath
{
    FriendCommentDetail *detail = self.commentdatas[inedxpath.row];
    NSDictionary *highlightDic = @{NSForegroundColorAttributeName : [UIColor blueColor],NSFontAttributeName : [UIFont systemFontOfSize:12]};
    NSDictionary *normalDic = @{NSForegroundColorAttributeName : RGBA(51, 51, 51, 1),NSFontAttributeName : [UIFont systemFontOfSize:12]};
    NSMutableAttributedString *commentStr;
    NSAttributedString *contentStr = [[NSAttributedString alloc] initWithString:detail.commentText attributes:normalDic];
//    NSLog(@"byUserName%@,byUserID%@",detail.commentByUserName,detail.commentByUserId);
    // 回复楼主
    if ([NSString isEmptyString:detail.commentByUserName] || [detail.commentByUserId isEqualToString:@"0"])
    {
        if (!self.hadLikeActivityMessage) {
            commentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",detail.commentUserName] attributes:highlightDic];
        }
        else
        {
            commentStr = [[NSMutableAttributedString alloc] init];
        }
        
        [commentStr appendAttributedString:contentStr];
    }
    else // 回复评论的人 （楼中楼）
    {
        commentStr = [[NSMutableAttributedString alloc] initWithString:detail.commentUserName attributes:highlightDic];
        NSAttributedString *stringReply = [[NSAttributedString alloc] initWithString:@"回复" attributes:normalDic];
        NSAttributedString *stringByName = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:",detail.commentByUserName] attributes:highlightDic];
        [commentStr appendAttributedString:stringReply];
        [commentStr appendAttributedString:stringByName];
        [commentStr appendAttributedString:contentStr];
    }
    cell.commentLabel.attributedText =commentStr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = [tableView fd_heightForCellWithIdentifier:identifyTable configuration:^(id cell) {
        [self configTableViewCell:cell indexpath:indexPath];
    }];
    
    return height + 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [tableView fd_heightForCellWithIdentifier:identifyTable cacheByIndexPath:indexPath configuration:^(CommentTableViewCell *cell) {
        
        [self configTableViewCell:cell indexpath:indexPath];
        
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickTableViewCommentShowKeyboard:tableViewIndex: tableView:currentHeight:)]) {
        [self.delegate clickTableViewCommentShowKeyboard:self tableViewIndex:indexPath tableView:self.commentTableView currentHeight:height];
    }
}


#pragma mark - colletionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *imageStr = self.imageDatas[indexPath.item];
    CommentImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifyCollection forIndexPath:indexPath];
    __weak typeof(cell)weakCell = cell;
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        if (cacheType == SDImageCacheTypeNone && image) {
            weakCell.mainImageView.alpha = 0;
            [UIView animateWithDuration:0.8 animations:^{
                weakCell.mainImageView.alpha = 1.0f;
            }];
        }
        else
        {
            weakCell.mainImageView.alpha = 1.0f;
        }
    }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = SCREEN_WIDTH - 90 - 20;
    if (![NSArray isEmpty:self.imageDatas])
    {
        if (self.imageDatas.count == 1)
        {
            return CGSizeMake(width / 2, width / 1.5);
        }
        else
        {
            return CGSizeMake(width / 3, width / 3);
        }
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickColletionViewOrTableViewCallBack:)]) {
        [self.delegate clickColletionViewOrTableViewCallBack:self];
    }
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount = self.imageDatasBig.count;
    photoBrowser.sourceImagesContainerView = self.collectionView;
    [photoBrowser show];
}

#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlString = self.imageDatasBig[index];
    return [NSURL URLWithString:urlString];
}
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    
    return nil;
}


#pragma mark - 点赞和评论
- (IBAction)likeButtonClick:(UIButton *)sender
{
    self.hadLikeActivityMessage = !self.hadLikeActivityMessage;
    [UIView animateWithDuration:0.3 animations:^{
        self.likeButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        self.likeButton.transform = CGAffineTransformIdentity;
        if (self.hadLikeActivityMessage) {
            [self.likeButton setTitle:@"取消" forState:UIControlStateNormal];
        }
        else
        {
            [self.likeButton setTitle:@"赞" forState:UIControlStateNormal];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickLikeButton:isLike:)]) {
            [self.delegate clickLikeButton:self isLike:self.hadLikeActivityMessage];
        }
    }];
}

- (IBAction)commentButtonClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPopCommnet:)]) {
        [self.delegate clickPopCommnet:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
