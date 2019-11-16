//
//  LXLevelChoiceCell.m
//  LXFilterChoiceTool
//
//  Created by 天边的星星 on 2019/11/13.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXLevelChoiceCell.h"
#import "LXFilterChoice.h"

@interface LXLevelChoiceCell ()

@property (nonatomic, strong) UILabel* contentLbl;
///是否需要刷新frame，对于重用的cell完全不需要再次更新frame
@property (nonatomic, assign) BOOL needRefreshFrame;

@end

@implementation LXLevelChoiceCell

#pragma mark --- life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.autoresizesSubviews = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.contentLbl];
    }
    return self;
}
- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow != NULL) {
        self.needRefreshFrame = YES;
    }
}
- (void)setChoice:(LXFilterChoice *)choice {
    _choice = choice;
    self.contentLbl.text = choice.content;
    
    if (choice.isSelected) {
        self.contentLbl.font = kLXMidBoldSystemFont(15.0);
        self.contentLbl.textColor = kLXHexColor(0x427AFF);
    }else {
        self.contentLbl.font = kLXSystemFont(15.0);
        self.contentLbl.textColor = kLXHexColor(0x222222);
    }
    if (self.needRefreshFrame) {
        self.contentLbl.frame = self.contentView.bounds;
        self.needRefreshFrame = NO;
//        NSLog(@"111111111111");
    }
}

#pragma mark --- lazy
- (UILabel *)contentLbl {
    if (!_contentLbl) {
        _contentLbl = [UILabel new];
        _contentLbl.textColor = kLXHexColor(0x222222);
        _contentLbl.font = kLXSystemFont(15);
        _contentLbl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _contentLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLbl;
}

@end
