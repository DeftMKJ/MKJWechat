//
//  MainTabBarController.m
//  MKJWechat
//
//  Created by MKJING on 16/8/17.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "MainTabBarController.h"
#import "MLTransition.h"
#import "AnimationVideoViewController.h"
#define kClassKey @"rootVCClass"
#define kTitleKey @"titleName"
#define kImageKey @"imageName"
#define kSelectedImageKey @"selectedImage"

@interface MainTabBarController ()



@end

@implementation MainTabBarController

static MainTabBarController *rootVC;

+ (MainTabBarController *)getRootVC
{
    return rootVC;
}

- (instancetype)init
{
    if (self == [super init])
    {
        rootVC = self;
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 全屏返回拖动手势 （系统自带的只有边界）
    [MLTransition validatePanPackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];
    self.delegate = self;
    
    NSArray *childArray = @[
                            @{kClassKey : @"HomeViewController",
                              kTitleKey : @"微信",
                              kImageKey : @"tabbar_mainframe",
                              kSelectedImageKey : @"tabbar_mainframeHL"},
                            @{kClassKey : @"TelphoneViewController",
                              kTitleKey : @"通讯录",
                              kImageKey : @"tabbar_contacts",
                              kSelectedImageKey : @"tabbar_contactsHL"},
                            @{kClassKey : @"MainDiscoveryViewController",
                              kTitleKey : @"发现",
                              kImageKey : @"tabbar_discover",
                              kSelectedImageKey : @"tabbar_discoverHL"},
                            @{kClassKey : @"MySelfViewController",
                              kTitleKey : @"我",
                              kImageKey : @"tabbar_me",
                              kSelectedImageKey : @"tabbar_meHL"}
                            ];
    [childArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UIViewController *vc = [[NSClassFromString(obj[kClassKey]) alloc] init];
        vc.title = obj[kTitleKey];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        UITabBarItem *barItem = [[UITabBarItem alloc] initWithTitle:obj[kTitleKey] image:nil tag:idx];
        [barItem setImage:[[UIImage imageNamed:obj[kImageKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [barItem setSelectedImage:[[UIImage imageNamed:obj[kSelectedImageKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [barItem setImage:[UIImage imageNamed:obj[kImageKey]]];
//        [barItem setSelectedImage:[UIImage imageNamed:obj[kSelectedImageKey]]];
        [barItem setTitleTextAttributes:@{NSForegroundColorAttributeName :kGreenColor} forState:UIControlStateSelected];
        nvc.tabBarItem = barItem;
        
        [self addChildViewController:nvc];
        
    }];
    
    
    [self.tabBar setValue:@(YES) forKeyPath:@"_hidesShadow"];//隐藏tabbar顶部的下划线
//    [self.tabBar setBarTintColor:RGBA(255, 194, 1, 1)];
    
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
