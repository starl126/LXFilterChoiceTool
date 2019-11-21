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
typedef void (^LXLevelChoosedChoicesCallback)(NSArray<LXFilterChoice*>* selectedArr);

///下拉单选多级联动控件
@interface LXFilterLevelTableView : UITableView

#pragma mark --- init
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame choices:(NSArray<LXFilterChoice*>*)choices inView:(UIView*)inView NS_DESIGNATED_INITIALIZER;

#pragma mark --- property
///多级选项回调
@property (nonatomic, copy) LXLevelChoosedChoicesCallback selectedChoicesBlock;

///table view的左右边距距离父控件距离,不可设置
@property (nonatomic, assign) CGFloat marginLeftAndRight;

///数据源，内部使用，外部不要传
@property (nonatomic, strong) NSArray<LXFilterChoice*>* choices;

///整个控件的宽度，外界不可设置，内部传递使用
@property (nonatomic, assign) CGFloat wholeWidth;

///当前控件所属层级，0代表最高层级，依次递增代表子层级，不可设置，用于内部使用
@property (nonatomic, assign) NSUInteger currentLevel;

///当前控件的下级选项控件
@property (nonatomic, weak) LXFilterLevelTableView* childTableView;

///当前控件的上级选项控件
@property (nonatomic, weak) LXFilterLevelTableView* parentTableView;

///用于table view的背景颜色,
@property (nonatomic, strong) NSArray* backColorArr;

#pragma mark --- public

///实时获取多级联动选中的选项数组
- (NSArray<LXFilterChoice*>*)currentSelectedChoiceArr;

///获取最顶级的table view对象
- (LXFilterLevelTableView*)topFilterTableView;

///获取最下级的table view对象
- (LXFilterLevelTableView*)bottomFilterTableView;

///仅在多级联动下使用，初始化选中项的下级选项控件
- (void)initPresentNextLevelTableView;

///重置选项
- (void)reset;

///确认选项
- (void)confirm;

#pragma mark --- private
///更新当前table view以及所有父table view尺寸和位置，传入总的table view级联层级个数，仅内部逻辑使用
- (void)updateParentTableViewFrameWithTotalCount:(NSUInteger)count;

///移除所有的下级table view，仅内部逻辑使用
- (void)removeAllChildTableView;

@end

NS_ASSUME_NONNULL_END
