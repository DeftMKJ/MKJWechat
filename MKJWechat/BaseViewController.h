//
//  BaseViewController.h
//  MKJWechat
//
//  Created by MKJING on 16/8/17.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

-(void)hideBackButton;

- (int)getRandomCommentID:(int)from to:(int)to;

@end
