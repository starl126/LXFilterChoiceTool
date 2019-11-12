//
//  LXFilterChoice.h
//  LXFilterChoiceTool
//
//  Created by 天边的星星 on 2019/11/8.
//  Copyright © 2019 starxin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///单个选项
@interface LXFilterChoice : NSObject

///选项文本内容，必传参数
@property (nonatomic, copy, nonnull) NSString* content;
///选项唯一标识符，必传参数
@property (nonatomic, copy, nonnull) NSString* choiceId;
///选项是否被选中
@property (nonatomic, assign, getter=isSelected) BOOL selected;
///必须有一个选项被选中，非必传
@property (nonatomic, assign, getter=atLeastOneChoice)  BOOL mustHaveChoice;
///一键全选，表明此选项和其他同级选项互斥关系，一般用于类似于'全部'
@property (nonatomic, assign, getter=isAllShortCut) BOOL allShortCut;
///扩展字符串，非必传
@property (nonatomic, copy, nullable) NSString* extStr;
///扩展属性，非必传
@property (nonatomic, strong, nullable) id ext;

#pragma mark --- 内部计算属性，非传参数
///选项依附于LXFilterGroupChoice对象的是否允许多选
@property (nonatomic, assign, getter=isAllowMoreChoice) BOOL allowMoreChoice;
///该选项依附于LXFilterGroupChoice对象id
@property (nonatomic, copy, readonly) NSString* groupId;
///该选项依附于LXFilterGroupChoice对象组标题
@property (nonatomic, copy, nullable, readonly) NSString* groupTitle;
///该选项依附于LXFilterGroupChoice对象扩展属性
@property (nonatomic, copy, nullable, readonly) id groupExt;

#pragma mark --- 下级选项数组
@property (nonatomic, strong, nullable) NSArray <LXFilterChoice *>* subChoices;

@end

NS_ASSUME_NONNULL_END
