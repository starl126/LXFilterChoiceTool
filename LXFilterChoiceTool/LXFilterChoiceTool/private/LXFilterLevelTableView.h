//
//  LXFilterTableView.h
//  LXFilterChoiceTool
//
//  Created by 天边的星星 on 2019/11/8.
//  Copyright © 2019 starxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LXFilterChoice;
NS_ASSUME_NONNULL_BEGIN
/**
 @abstract 选中选项回调，用于单选多级联动回调。
 */
typedef void (^LXLevelChoosedChoicesCallback)(NSArray<LXFilterChoice*>* selectedArr, BOOL valid);

///下拉单选多级联动控件
@interface LXFilterLevelTableView : UITableView

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame choices:(NSArray<LXFilterChoice*>*)choices moreLevel:(BOOL)moreLevel  NS_DESIGNATED_INITIALIZER;




@end

NS_ASSUME_NONNULL_END
