//
//  HomeViewController.m
//  MKJWechat
//
//  Created by MKJING on 16/8/17.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "HomeViewController.h"
#import "AnimationVideoViewController.h"

@interface HomeViewController ()

@property (nonatomic,strong) AnimationVideoViewController *animationVC;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self jungleIfFirstLoading];
}

- (void)jungleIfFirstLoading
{
    __weak typeof(self)weakSelf = self;
    NSInteger firstIN = [[[NSUserDefaults standardUserDefaults] valueForKey:@"FIRST_ENTER_IN"] integerValue];
    if (firstIN != 0) {
        return;
    }
    
    self.animationVC = [[AnimationVideoViewController alloc] init];
    self.animationVC.videoURL = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"intro"ofType:@"mp4"]];
    self.animationVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.animationVC.finishBlock = ^{
        [UIView animateWithDuration:1.0 animations:^{
            weakSelf.animationVC.view.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.animationVC.view removeFromSuperview];
            weakSelf.animationVC = nil;
        }];
        
    };
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.animationVC.view];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.animationVC.view];
    
    [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:@"FIRST_ENTER_IN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
