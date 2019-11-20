//
//  LXFilterSingleTableView.h
//  LXFilterChoiceTool
//
//  Created by 天边的星星 on 2019/11/8.
//  Copyright © 2019 starxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXFilterChoice;

NS_ASSUME_NONNULL_BEGIN

/**
 @abstract 单级单选或者多选回调，回调选中的选项
 @discussion choicesArr:被选中的选项数组 valid:表明该选项数组是否有效，如果前后两次都选中了同一个选项，则返回NO
 */
typedef void (^LXChoosedChoicesCallback)(NSArray<LXFilterChoice*>* _Nullable choicesArr, BOOL valid);

///下拉单级单选或者多选控件
@interface LXFilterSingleTableView : UITableView

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame choices:(NSArray<LXFilterChoice*> *)choices NS_DESIGNATED_INITIALIZER;

/**
 @abstract 选中选项数据回调
 */
@property (nonatomic, copy) LXChoosedChoicesCallback selectedChoicesBlock;

@end

NS_ASSUME_NONNULL_END
