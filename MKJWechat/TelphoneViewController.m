//
//  TelphoneViewController.m
//  MKJWechat
//
//  Created by MKJING on 16/8/17.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "TelphoneViewController.h"
#import "MKJRequestHelp.h"
#import "AddressModel.h"
#import "SearchFriendCell.h"
#import <Masonry.h>
#import "SearchResultController.h"

@interface TelphoneViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *allFriends; //!< 通讯录里面所有人集合数组
@property (nonatomic,strong) NSMutableArray *filterFirends;
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic,strong) SearchResultController *searchResult;

// 名字的所有首字母数组
@property (nonatomic,strong) NSArray *letterArr;
// 根据key存放同一名字下的所有数组
@property (nonatomic,strong) NSMutableDictionary *nameDict;

@end

static NSString *identyfy1 = @"SearchFriendCell";

@implementation TelphoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.edgesForExtendedLayout = UIRectEdgeBottom;
//    self.navigationController.navigationBar.translucent = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self initUI];
    [self loadData];
}

- (void)initUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.tableView registerNib:[UINib nibWithNibName:identyfy1 bundle:nil] forCellReuseIdentifier:identyfy1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.sectionIndexColor = [UIColor redColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    
    
    __weak typeof(self)weakSelf = self;
    self.searchResult = [[SearchResultController alloc] init];
    self.searchResult.block = ^{
        
        [weakSelf.searchController.searchBar resignFirstResponder];
        
    };
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResult];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.placeholder = @"查找联系人";
    self.searchController.searchBar.delegate = self;
    
    self.searchController.searchBar.showsCancelButton = NO;
    self.searchController.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchController.searchBar.backgroundColor = RGBA(153, 153, 153, 1);
    self.searchController.searchBar.backgroundImage = [UIImage new];
    UITextField *searchBarTextField = [self.searchController.searchBar valueForKey:@"_searchField"];
    if (searchBarTextField)
    {
        [searchBarTextField setBackgroundColor:[UIColor whiteColor]];
        [searchBarTextField setBorderStyle:UITextBorderStyleRoundedRect];
        searchBarTextField.layer.cornerRadius = 5.0f;
        searchBarTextField.layer.borderColor = RGBA(204, 204, 204, 1).CGColor;
        searchBarTextField.layer.borderWidth = 0.5f;
    }
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

// searchBar代理
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    
    [searchBar resignFirstResponder];
}

// 键盘代理
- (void)keyboardWillShow:(NSNotification *)notification
{
    
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    
}

// 搜索的代理
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"%@",searchController.searchBar.text);
    NSString *searchString = [self.searchController.searchBar text];
    if (self.filterFirends!= nil) {
        [self.filterFirends removeAllObjects];
    }
    if ([PinyinHelper isIncludeChineseInString:searchString])
    {
        for (FriendInfo *friend in self.allFriends)
        {
            if ([friend.userName containsString:searchString])
            {
                [self.filterFirends addObject:friend];
                
            }
        }
    }
    else
    {
        for (FriendInfo *friend in self.allFriends)
        {
            HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
            outputFormat.vCharType = VCharTypeWithV;
            outputFormat.caseType = CaseTypeLowercase;
            outputFormat.toneType = ToneTypeWithoutTone;
            NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:friend.userName withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
            
            if ([[outputPinyin uppercaseString] containsString:[searchString uppercaseString]])
            {
                [self.filterFirends addObject:friend];
            }
        }
    }
    //过滤数据
    self.searchResult.filterData = self.filterFirends;
    //刷新表格
    [self.searchResult refreshData];
    
}
// 请求数据
- (void)loadData
{
    [[MKJRequestHelp shareRequestHelp] configAddressInfo:^(id obj, NSError *err) {
        
        self.allFriends = ((AddressData *)obj).allFriends.allFriendsArr;
        [self handleFirstLetterArray];
        [self.tableView reloadData];
        
    }];
}

// 处理英文首字母
- (void)handleFirstLetterArray
{
    // 拿到所有的key  字母
    NSMutableDictionary *letterDict = [[NSMutableDictionary alloc] init];
    for (FriendInfo *friend in self.allFriends) {
        HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
        outputFormat.vCharType = VCharTypeWithV;
        outputFormat.caseType = CaseTypeLowercase;
        outputFormat.toneType = ToneTypeWithoutTone;
        NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:friend.userName withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
        NSLog(@"%@",outputPinyin);
        [letterDict setObject:friend forKey:[[outputPinyin substringToIndex:1] uppercaseString]];
    }
    // 字母数组
    self.letterArr = letterDict.allKeys;
    
    // 让key进行排序  A  -  Z
    self.letterArr = [[NSMutableArray alloc] initWithArray:[self.letterArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        // 大于上升，小于下降
        return [obj1 characterAtIndex:0] > [obj2 characterAtIndex:0];
        
    }]];
    
    // 遍历所有的排序后的key  每个Key拿到对应的数组进行组装
    for (NSString *letter in self.letterArr)
    {
        NSMutableArray *nameArr = [[NSMutableArray alloc] init];
        for (FriendInfo *friend in self.allFriends) {
            HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
            outputFormat.vCharType = VCharTypeWithV;
            outputFormat.caseType = CaseTypeUppercase;
            outputFormat.toneType = ToneTypeWithoutTone;
            NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:friend.userName withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
            if ([letter isEqualToString:[[outputPinyin substringToIndex:1] uppercaseString]])
            {
                [nameArr addObject:friend];
            }
        }
        // 根据key装大字典
        // A -- 一批通讯人
        // B -- 一批人
        // ...
        [self.nameDict setObject:nameArr forKey:letter];
    }
}


#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.letterArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [self.nameDict valueForKey:self.letterArr[section]];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 右侧字母滑栏 有暴露的方法直接可以调用，不需要这样玩
//    for(UIView *view in [tableView subviews])
//    {
//        if([[[view class] description] isEqualToString:@"UITableViewIndex"])
//        {
//            view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
//        }
//    }

    
    FriendInfo *info = [self.nameDict valueForKey:self.letterArr[indexPath.section]][indexPath.row];
    SearchFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:identyfy1 forIndexPath:indexPath];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.letterArr objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    backView.backgroundColor = RGBA(240, 240, 240, 1);
    UILabel *letterlabel = [[UILabel alloc] init];
    letterlabel.text = self.letterArr[section];
    letterlabel.font = [UIFont boldSystemFontOfSize:20];
    letterlabel.textColor = RGBA(53, 53, 53, 1);
    [backView addSubview:letterlabel];
    [letterlabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(backView);
        make.left.equalTo(backView).with.offset(15);
        
    }];
    
    return backView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
// 点击事件返回第几个section
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
        NSInteger count = 0;
        for(NSString *letter in self.letterArr)
        {
            if([letter isEqualToString:title])
            {
                return count;
            }
            count++;
        }
        return 0;
}
// 右侧一共多少个section
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.letterArr;

}

- (NSMutableArray *)allFriends
{
    if (_allFriends == nil) {
        _allFriends = [[NSMutableArray alloc] init];
    }
    return _allFriends;
}

- (NSMutableArray *)filterFirends
{
    if (_filterFirends == nil) {
        _filterFirends = [[NSMutableArray alloc] init];
    }
    return _filterFirends;

}
- (NSMutableDictionary *)nameDict
{
    if (_nameDict == nil) {
        _nameDict = [[NSMutableDictionary alloc] init];
    }
    return _nameDict;
}

@end
