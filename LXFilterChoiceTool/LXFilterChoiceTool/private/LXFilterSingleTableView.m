//
//  LXFilterSingleTableView.m
//  LXFilterChoiceTool
//
//  Created by 天边的星星 on 2019/11/8.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXFilterSingleTableView.h"
#import "LXSingleChoiceCell.h"
#import "LXFilterChoice.h"

static CGFloat kLXSingleTableCellHeight = 50.0f;

@interface LXFilterSingleTableView ()<UITableViewDelegate,UITableViewDataSource> {
    
@private
    ///数据源
    NSArray<LXFilterChoice*>* _choices;
    ///上一次确认的选项数组
    NSMutableArray<LXFilterChoice*>* _choosedChoices;
    ///上一个确认的选项索引素组
    NSMutableArray<NSIndexPath*>* _choosedIndexPathArr;
    ///判断是否是多选
    BOOL _allowMoreChoice;
}

@end

@implementation LXFilterSingleTableView

#pragma mark --- life cycle
- (instancetype)initWithFrame:(CGRect)frame choices:(NSArray<LXFilterChoice*> *)choices {
    if (self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        self.delegate = self;
        self.dataSource = self;
        
        _choices = choices;
        if (choices && choices.count) {
            _allowMoreChoice = choices.firstObject.isAllowMoreChoice;
        }
        _choosedChoices = [NSMutableArray array];
        _choosedIndexPathArr = [NSMutableArray array];
        
        self.rowHeight = kLXSingleTableCellHeight;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = UIColor.whiteColor;
        [self registerClass:LXSingleChoiceCell.class forCellReuseIdentifier:NSStringFromClass(LXSingleChoiceCell.class)];
    }
    return self;
}

#pragma mark --- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _choices.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXSingleChoiceCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(LXSingleChoiceCell.class)];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(LXSingleChoiceCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    LXFilterChoice* choice = _choices[indexPath.row];
    cell.choice = choice;
}
///校正选中的选项数组和索引
- (void)p_actionForCorrectChoosedChoicesInChoice:(LXFilterChoice*)choice indexPath:(NSIndexPath*)indexPath {
    BOOL exist = NO;
    for (NSUInteger i=0; i<_choosedChoices.count; i++) {
        LXFilterChoice* obj = _choosedChoices[i];
        if ([obj.choiceId isEqualToString:choice.choiceId]) {
            exist = YES;
            if (!choice.isSelected) {
                [_choosedChoices removeObjectAtIndex:i];
                [_choosedIndexPathArr removeObjectAtIndex:i];
            }
            break;
        }
    }
    if (!exist) {//不存在
        [_choosedChoices addObject:choice];
        [_choosedIndexPathArr addObject:indexPath];
    }
}
///处理多选类型的选中选项
- (BOOL)p_actionForDealWithMoreChoiceSelectRow:(NSIndexPath *)indexPath choice:(LXFilterChoice*)choice {
    
    BOOL valid = YES;
    if (choice.atLeastOneChoice) {//至少有一个值
        if (_choosedChoices            &&
            _choosedChoices.count == 1 &&
            [choice.choiceId isEqualToString:_choosedChoices.firstObject.choiceId]) {//已选项只有一个值且是同一个选项
            choice.selected = YES;
            valid = NO;
        }else {
            choice.selected = !choice.isSelected;
        }
    }else {//可有可无
        choice.selected = !choice.isSelected;
    }
    //从已选的选项中排除
    [self p_actionForCorrectChoosedChoicesInChoice:choice indexPath:indexPath];
    return valid;
}
///处理单选类型的选中选择
- (BOOL)p_actionForDealWithSingleChoiceSelectRow:(NSIndexPath *)indexPath choice:(LXFilterChoice *)choice {
    
    BOOL valid = YES;
    if (choice.atLeastOneChoice) {//必须且只能选中一个选项
        if (choice.isSelected) {
            valid = NO;
        }else {//需要重置其他选项的选中状态
            if (_choosedChoices && _choosedChoices.count==1) {
                _choosedChoices.firstObject.selected = NO;
                LXSingleChoiceCell* choosedCell = [self cellForRowAtIndexPath:_choosedIndexPathArr.firstObject];
                choosedCell.choice = _choosedChoices.firstObject;
                [_choosedChoices removeAllObjects];
                [_choosedIndexPathArr removeAllObjects];
            }
            choice.selected = YES;
            [_choosedChoices addObject:choice];
            [_choosedIndexPathArr addObject:indexPath.copy];
        }
    }else {//可以不选中任何选项
        choice.selected = !choice.isSelected;
        //需要重置其他选项的选中状态
        if (_choosedChoices.count==1 && [_choosedChoices.firstObject.choiceId isEqualToString:choice.choiceId]) {//点击的和上一次一样的选项
            [_choosedChoices removeAllObjects];
            [_choosedIndexPathArr removeAllObjects];
        }else {//不一样
            if (_choosedChoices.count==1) {
                _choosedChoices.firstObject.selected = NO;
                LXSingleChoiceCell* choosedCell = [self cellForRowAtIndexPath:_choosedIndexPathArr.firstObject];
                choosedCell.choice = _choosedChoices.firstObject;
            }
            [_choosedChoices setArray:@[choice]];
            [_choosedIndexPathArr setArray:@[indexPath.copy]];
        }
    }
    return valid;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LXSingleChoiceCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    LXFilterChoice* choice = _choices[indexPath.row];
    
    BOOL valid = YES;
    if (_allowMoreChoice) {//支持多选
        valid = [self p_actionForDealWithMoreChoiceSelectRow:indexPath choice:choice];
    }else {//单选
        valid = [self p_actionForDealWithSingleChoiceSelectRow:indexPath choice:choice];
    }
    cell.choice = choice;

    if (self.selectedChoicesBlock) {
        self.selectedChoicesBlock(_choosedChoices, valid);
    }
}
#ifdef DEBUG
- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
#endif

@end
