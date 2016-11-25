//
//  SearchResultController.h
//  MKJWechat
//
//  Created by MKJING on 16/8/18.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^resiginBlock)();

@interface SearchResultController : BaseViewController

@property (nonatomic,strong) NSMutableArray *filterData;
@property (nonatomic,copy) resiginBlock block;

- (void)refreshData;

@end
