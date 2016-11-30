//
//  AnimationVideoViewController.h
//  MKJWechat
//
//  Created by MKJING on 16/11/30.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^FinishCallBack)(void);

@interface AnimationVideoViewController : BaseViewController

@property (nonatomic,copy) FinishCallBack finishBlock;
@property (nonatomic,strong) NSURL *videoURL;

@end
