//
//  LXFlowCollectionView.h
//  LXFilterChoiceTool
//
//  Created by 天边的星星 on 2019/11/18.
//  Copyright © 2019 starxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXFilterGroupChoice,LXFilterChoice;

NS_ASSUME_NONNULL_BEGIN

/**
 @abstract 选中选项实时回调，选中任何一个group choices都会回调
 @warning selectedGroupArr: 如果该group无任何选项，则该选项组不回调，不会以空数组来回调
 */
typedef void (^LXFlowCollectionChoosedChoicesCallback)(NSArray<NSArray<LXFilterChoice*>*>* _Nullable selectedGroupArr);

///流水布局选项控件
@interface LXFlowCollectionView : UICollectionView

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame groupChoices:(NSArray<LXFilterGroupChoice*>*)groupChoices;

///实时回调，请在一致性要求较严格情况下调用，其他情况下请使用'currentChoosedChoices'
@property (nonatomic, copy) LXFlowCollectionChoosedChoicesCallback selectedGroupChoicesBlock;

///流水布局的列数，默认是3
@property (nonatomic, assign) NSUInteger columns;

///确认选项操作，所有选中项经过确认后才会记录用户行为
- (void)confirm;

///重置选项操作
- (void)reset;

///回滚到上次选中的选项
- (void)rebackLastSelectedState;

///获取到当前的选中选项
- (NSArray<NSArray<LXFilterChoice*>*>*)currentChoosedChoices;

@end

NS_ASSUME_NONNULL_END
