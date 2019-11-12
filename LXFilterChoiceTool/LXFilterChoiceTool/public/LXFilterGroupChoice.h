//
//  LXFilterSeriesChoice.h
//  LXFilterChoiceTool
//
//  Created by 天边的星星 on 2019/11/8.
//  Copyright © 2019 starxin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LXFilterChoice;

NS_ASSUME_NONNULL_BEGIN
///一组选项
@interface LXFilterGroupChoice : NSObject

///组唯一标识,必传
@property (nonatomic, copy, nonnull) NSString* groupId;
///组标题，非必传。
@property (nonatomic, copy, nullable) NSString* groupTitle;
///组下的选项数组，非必传。
@property (nonatomic, strong, nullable) NSArray<LXFilterChoice*>* groupChoices;
///该组是否允许多选，默认值NO
@property (nonatomic, assign, getter=isAllowMoreChoice) BOOL allowMoreChoice;
///该组至少有一个选项被选中，默认值NO
@property (nonatomic, assign, getter=atLeastOneChoice)  BOOL mustHaveChoice;
///扩展属性，用于扩展，非必传
@property (nonatomic, copy, nullable) id groupExt;

@end

NS_ASSUME_NONNULL_END
