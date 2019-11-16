//
//  LXSingleChoiceCell.m
//  LXFilterChoiceTool
//
//  Created by 天边的星星 on 2019/11/11.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXSingleChoiceCell.h"
#import "LXFilterChoice.h"

static CGFloat kLXSingleCellHorizontalMargin = 14.0f;
static CGFloat kLXSingleCellChoosedImgWidth  = 16.0f;
static CGFloat kLXSingleCellChoosedImgHeight = 16.0f;

@interface LXSingleChoiceCell ()

@property (nonatomic, strong) UIView* topSepLine;
@property (nonatomic, strong) UILabel* contentLbl;
@property (nonatomic, strong) UIImageView* choosedImgV;

///是否需要刷新frame，对于重用的cell完全不需要再次更新frame
@property (nonatomic, assign) BOOL needRefreshFrame;

@end

@implementation LXSingleChoiceCell

#pragma mark --- life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self p_actionForSetupViews];
    }
    return self;
}
- (void)p_actionForSetupViews {
    [self.contentView addSubview:self.topSepLine];
    [self.contentView addSubview:self.contentLbl];
    [self.contentView addSubview:self.choosedImgV];
}
- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow != NULL) {
        self.needRefreshFrame = YES;
    }
}
- (void)setChoice:(LXFilterChoice *)choice {
    _choice = choice;
    self.contentLbl.text = choice.content;
    self.choosedImgV.hidden = !choice.isSelected;
    choice.isSelected ? (self.contentLbl.font = kLXMidBoldSystemFont(15.0)) : (self.contentLbl.font = kLXSystemFont(15.0));
    if (self.needRefreshFrame) {
        [self p_updateFrame];
        self.needRefreshFrame = NO;
//        NSLog(@"111111111111");
    }
}
- (void)p_updateFrame {
    self.topSepLine.frame = CGRectMake(0, 0, self.frame.size.width, 1.0/UIScreen.mainScreen.scale);
    CGFloat width = self.bounds.size.width-3*kLXSingleCellHorizontalMargin-kLXSingleCellChoosedImgWidth;
    self.contentLbl.frame = CGRectMake(kLXSingleCellHorizontalMargin, 0, width, self.bounds.size.height);
    CGFloat y = (self.bounds.size.height-kLXSingleCellChoosedImgHeight)*0.5;
    self.choosedImgV.frame = CGRectMake(CGRectGetMaxX(self.contentLbl.frame)+kLXSingleCellHorizontalMargin, y, kLXSingleCellChoosedImgWidth, kLXSingleCellChoosedImgHeight);
}
#pragma mark --- lazy
- (UIView *)topSepLine {
    if (!_topSepLine) {
        _topSepLine = [UIView new];
        _topSepLine.backgroundColor = kLXHexColor(0xE1E2E3);
    }
    return _topSepLine;
}
- (UILabel *)contentLbl {
    if (!_contentLbl) {
        _contentLbl = [UILabel new];
        _contentLbl.font = kLXSystemFont(15.0);
        _contentLbl.textColor = kLXHexColor(0x0A0A17);
    }
    return _contentLbl;
}
- (UIImageView *)choosedImgV {
    if (!_choosedImgV) {
        _choosedImgV = [[UIImageView alloc] initWithImage:kLXImageNamed(@"lx_blueGou")];
        _choosedImgV.contentMode = UIViewContentModeScaleAspectFit;
        _choosedImgV.hidden = YES;
    }
    return _choosedImgV;
}
#ifdef DEBUG
- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
#endif

@end
