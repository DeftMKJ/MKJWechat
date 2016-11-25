//
//  SearchResultController.m
//  MKJWechat
//
//  Created by MKJING on 16/8/18.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "SearchResultController.h"
#import "SearchFriendCell.h"
#import "AddressModel.h"

@interface SearchResultController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *identify = @"SearchFriendCell";

@implementation SearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:identify bundle:nil] forCellReuseIdentifier:identify];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)refreshData
{
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.block();
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filterData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    
    FriendInfo *info = self.filterData[indexPath.row];
    __weak typeof(cell)weakCell = cell;
    [cell.nickImageView sd_setImageWithURL:[NSURL URLWithString:info.photo] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image && cacheType == SDImageCacheTypeNone) {
            weakCell.nickImageView.alpha = 0;
            [UIView animateWithDuration:1.0 animations:^{
                
                weakCell.nickImageView.alpha = 1.0f;
                
            }];
        }
        else
        {
            weakCell.nickImageView.alpha = 1.0f;
        }
        
    }];
    cell.nickNameLabel.text = info.userName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.block();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
