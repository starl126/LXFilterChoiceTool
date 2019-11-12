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
    NSArray<LXFilterChoice*>* _choices;
    LXFilterChoice* _choosedChoice;
    NSIndexPath* _choosedIndexPath;
}

@end

@implementation LXFilterSingleTableView

#pragma mark --- life cycle
- (instancetype)initWithFrame:(CGRect)frame choices:(NSArray<LXFilterChoice*> *)choices {
    if (self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        self.delegate = self;
        self.dataSource = self;
        
        _choices = choices;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LXSingleChoiceCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    LXFilterChoice* choice = _choices[indexPath.row];
    
    BOOL valid = YES;
    if (choice.atLeastOneChoice) {//必须且只能选中一个选项
        if (choice.isSelected) {
            valid = NO;
        }else {//需要重置其他选项的选中状态
            if (_choosedChoice) {
                _choosedChoice.selected = NO;
                LXSingleChoiceCell* choosedCell = [tableView cellForRowAtIndexPath:_choosedIndexPath];
                choosedCell.choice = _choosedChoice;
            }
        }
        choice.selected = YES;
        _choosedChoice = choice;
        _choosedIndexPath = indexPath.copy;
    }else {//可以不选中任何选项
        choice.selected = !choice.isSelected;
        //需要重置其他选项的选中状态
        if (_choosedChoice && [_choosedChoice.choiceId isEqualToString:choice.choiceId]) {//点击的和上一次一样的选项
            _choosedChoice = nil;
            _choosedIndexPath = nil;
        }else {//不一样
            if (_choosedChoice) {
                _choosedChoice.selected = NO;
                LXSingleChoiceCell* choosedCell = [tableView cellForRowAtIndexPath:_choosedIndexPath];
                choosedCell.choice = _choosedChoice;
            }
            _choosedChoice = choice;
            _choosedIndexPath = indexPath.copy;
        }
    }

    cell.choice = choice;
    
    if (self.selectedChoiceBlock) {
        self.selectedChoiceBlock(_choosedChoice, valid);
    }
}
#ifdef DEBUG
- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
#endif

@end
