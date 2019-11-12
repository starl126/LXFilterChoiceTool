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
 @abstract 单选回调，回调选中的选项
 @discussion valid:表明该单选是否有效，如果前后两次都选中了同一个选项，则返回NO
 */
typedef void (^ChoosedChoiceCallback)(LXFilterChoice* _Nullable choice, BOOL valid);

///下拉单选控件
@interface LXFilterSingleTableView : UITableView

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame choices:(NSArray<LXFilterChoice*> *)choices NS_DESIGNATED_INITIALIZER;

/**
 @abstract 选中单选回调
 @discussion choice：被选中的单选 valid：表明当前选项是否有效，若该选项和上一个选项一致，则无效
 */
@property (nonatomic, copy) ChoosedChoiceCallback selectedChoiceBlock;


@end

NS_ASSUME_NONNULL_END
