//
//  MainDiscoveryViewController.m
//  MKJWechat
//
//  Created by MKJING on 16/11/25.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "MainDiscoveryViewController.h"
#import "SettingTableViewCell.h"
#import "DiscoveryViewController.h"
#import "IASKSettingsReader.h"

typedef NS_ENUM(NSInteger, CASE_TYPE)
{
    FRIENTDCIRCLE = 0 ,
    SHAKEANDSHAKE ,
    YAOYIYAO  ,
    NEARBYPEOPLE,
    SHOPPING  ,
    GAME
};

@interface MainDiscoveryViewController ()

@end

static NSString *identify1 = @"SettingTableViewCell";

@implementation MainDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.showDoneButton = NO;
    self.showCreditsFooter = NO;
    self.file = @"Root.inApp";
    [self.tableView registerNib:[UINib nibWithNibName:identify1 bundle:nil] forCellReuseIdentifier:identify1];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.backgroundColor = RGBA(240, 240, 240, 1);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}




-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 登录
- (CGFloat)tableView:(UITableView*)tableView heightForSpecifier:(IASKSpecifier*)specifier
{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForSpecifier:(IASKSpecifier*)specifier
{
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
    NSString *title = specifier.specifierDict[@"Title"];
    NSString *imageStr = specifier.specifierDict[@"img"];
    cell.iconName.text = title;
    cell.iconImageView.image = [UIImage imageNamed:imageStr];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
// header 间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 25;
}

// footer 间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] init];
    if (section == 0)
    {
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 24);
    }
    else
    {
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 24);
    }
    view.backgroundColor = RGBA(240, 240, 240, 1);
    return view;
}

#pragma mark -
- (void)settingsViewController:(IASKAppSettingsViewController*)sender tableView:(UITableView *)tableView didSelectCustomViewSpecifier:(IASKSpecifier*)specifier
{
        NSIndexPath * indexPath = [sender.settingsReader indexPathForKey:specifier.key];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        CASE_TYPE type = [self caseIndexForKey:specifier.key];
    switch (type) {
        case FRIENTDCIRCLE:
        {
            DiscoveryViewController *discoverVC = [[DiscoveryViewController alloc] init];
            [self.navigationController pushViewController:discoverVC animated:YES];
        }
            break;
        case SHAKEANDSHAKE:
            
            break;
        case YAOYIYAO:
            
            break;
        case NEARBYPEOPLE:
            
            break;
        case SHOPPING:
            
            break;
        case GAME:
            
            break;
            
        default:
            break;
    }
}






-(CASE_TYPE)caseIndexForKey:(NSString*)key
{
    NSDictionary * cases = @{
                             @"FriendCircle":@(FRIENTDCIRCLE),
                             @"ShakeAndShake":@(SHAKEANDSHAKE),
                             @"SearchAndSearch":@(YAOYIYAO),
                             @"NearbyPeople":@(NEARBYPEOPLE),
                             @"Shopping":@(SHOPPING),
                             @"Game":@(GAME)
                             };
    
    NSNumber * number = [cases valueForKey:key];
    
    
    return [number integerValue];
    
}






@end
