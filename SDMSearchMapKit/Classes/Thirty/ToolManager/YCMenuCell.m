//
//  YCMenuCell.m
//  ZhiZhi
//
//  Created by CKTrue on 2019/2/26.
//  Copyright © 2019年 njsg. All rights reserved.
//

#import "YCMenuCell.h"

@implementation YCMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _isShowSeparator = YES;
        _separatorColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)setSeparatorColor:(UIColor *)separatorColor{
    _separatorColor = separatorColor;
    [self setNeedsDisplay];
}
- (void)setIsShowSeparator:(BOOL)isShowSeparator{
    _isShowSeparator = isShowSeparator;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect{
    if (!_isShowSeparator)return;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5)];
    [_separatorColor setFill];
    [path fillWithBlendMode:kCGBlendModeNormal alpha:1.0f];
    [path closePath];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
