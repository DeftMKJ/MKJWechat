//
//  CommentTableViewCell.m
//  MKJWechat
//
//  Created by MKJING on 16/11/25.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.commentLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 90;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
