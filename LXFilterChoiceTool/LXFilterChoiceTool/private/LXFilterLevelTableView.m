//
//  LXFilterTableView.m
//  LXFilterChoiceTool
//
//  Created by 天边的星星 on 2019/11/8.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXFilterLevelTableView.h"
#import "LXFilterChoice.h"
#import "LXLevelChoiceCell.h"

static CGFloat kLXLevelTableCellHeight = 50.0f;

@interface LXFilterLevelTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UIView* inView;
///所有被选中的选项数组，仅在第0级所在table view中使用
@property (nonatomic, strong) NSMutableArray<LXFilterChoice*>* selectedChoices;
///用于默认初始化滚动，仅在第一次加载时使用,selectedIdxForScroll=-1代表不进行初始化滚动
@property (nonatomic, assign) NSInteger selectedIdxForScroll;
///用于table view的背景颜色
@property (nonatomic, strong) NSArray* backColorArr;

///上一次选中的选项
@property (nonatomic, strong) NSIndexPath* lastSelectedIndexPath;

@end


@implementation LXFilterLevelTableView

#pragma mark --- life cycle
- (instancetype)initWithFrame:(CGRect)frame choices:(NSArray<LXFilterChoice*>*)choices inView:(UIView*)inView {
    if (self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        _marginLeftAndRight = frame.origin.x;
        _wholeWidth = frame.size.width;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = kLXLevelTableCellHeight;
        
        _choices = choices.copy;
        _selectedIdxForScroll = -1;
        
        _inView = inView;
        
        __weak typeof(self) kLXWeakself = self;
        [choices enumerateObjectsUsingBlock:^(LXFilterChoice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.choiceId == 0) {
                obj.choiceId = [NSString stringWithFormat:@"%tu", idx];
            }
            if (obj.isSelected) {
                kLXWeakself.selectedIdxForScroll = idx;
                kLXWeakself.lastSelectedIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            }
        }];
        
        [self registerClass:LXLevelChoiceCell.class forCellReuseIdentifier:NSStringFromClass(LXLevelChoiceCell.class)];
    }
    return self;
}
///处理默认滚动
- (void)didMoveToWindow {
    if (self.window) {
//        NSLog(@"%@---%d",self.window,self.currentLevel);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.selectedIdxForScroll != -1) {
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.selectedIdxForScroll inSection:0];
                [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                self.selectedIdxForScroll = -1;
            }
        });
    }
}

#pragma mark --- actions
- (void)setChoices:(NSArray<LXFilterChoice *> *)choices {
    _choices = choices;
    [_choices enumerateObjectsUsingBlock:^(LXFilterChoice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.choiceId == 0) {
            obj.choiceId = [NSString stringWithFormat:@"%tu", idx];
        }
    }];
    [self reloadData];
}
///递归重置选项id，默认是从0,1,2...递增
- (void)p_actionForInitChoiceIdInArr:(NSArray<LXFilterChoice*>*)dataArr {
    __weak typeof(self) kLXWeakself = self;
    [dataArr enumerateObjectsUsingBlock:^(LXFilterChoice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.choiceId == 0) {
            obj.choiceId = [NSString stringWithFormat:@"%tu", idx];
            [kLXWeakself p_actionForInitChoiceIdInArr:obj.subChoices];
        }
    }];
}
///实时获取多级联动选中的选项数组
- (NSArray<LXFilterChoice*>*)currentSelectedChoiceArr {
    if (0 == self.currentLevel) {
        self.selectedChoices = [NSMutableArray array];
        [self p_getAllLevelSelectedChoicesInArr:self.choices];
    }
    
    return self.selectedChoices.copy;
}
///获取所有层级的被选中的选项
- (void)p_getAllLevelSelectedChoicesInArr:(NSArray<LXFilterChoice*>*)dataArr {
    __weak typeof(self) kLXWeakself = self;
    [dataArr enumerateObjectsUsingBlock:^(LXFilterChoice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            [kLXWeakself.selectedChoices addObject:obj];
            if (obj.subChoices && obj.subChoices.count) {
                [kLXWeakself p_getAllLevelSelectedChoicesInArr:obj.subChoices];
            }
            *stop = YES;
        }
    }];
}
///获取最顶级的table view对象
- (LXFilterLevelTableView*)topFilterTableView {
    if (self.parentTableView) {
        return [self.parentTableView topFilterTableView];
    }else {
        return self;
    }
}
///获取最下级的table view对象
- (LXFilterLevelTableView*)bottomFilterTableView {
    if (self.childTableView) {
        return [self.childTableView bottomFilterTableView];
    }else {
        return self;
    }
}
///更新当前table view以及所有父table view尺寸和位置，传入总的table view级联层级个数
- (void)updateParentTableViewFrameWithTotalCount:(NSUInteger)count {
    CGFloat width = self.wholeWidth/count;
    CGFloat x = width*self.currentLevel+_marginLeftAndRight-0.5;
    CGRect frame = self.frame;
    
    self.frame = CGRectMake(x, frame.origin.y, width+0.5, frame.size.height);
    if (self.parentTableView) {
        [self.parentTableView updateParentTableViewFrameWithTotalCount:count];
    }
}
///更新当前table view以及其所有子table view的尺寸和位置
- (void)updateTableViewFrame:(LXFilterLevelTableView*)tableView originX:(CGFloat)originX {
    if (tableView == 0) {
        return;
    }
    CGRect frame = tableView.frame;
    tableView.frame = CGRectMake(frame.origin.x+originX, frame.origin.y, frame.size.width, frame.size.height);
    if (tableView.childTableView) {
        [self updateTableViewFrame:tableView.childTableView originX:originX];
    }
}
///移除所有的下级table view
- (void)removeAllChildTableView {
    if (self.childTableView) {
        [self.childTableView removeAllChildTableView];
        [self.childTableView removeFromSuperview];
    }
}
///重置数据源选中状态,用于多级联动
- (void)p_resetDataSourceSelectCondition:(NSArray<LXFilterChoice*>*)datasource {
    __weak typeof(self) kLXWeakself = self;
    [datasource enumerateObjectsUsingBlock:^(LXFilterChoice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            obj.selected = NO;
            if (obj.subChoices && obj.subChoices.count) {
                [kLXWeakself p_resetDataSourceSelectCondition:obj.subChoices];
            }
            *stop = YES;
        }
    }];
}
///重置选项
- (void)reset {
    [self p_resetDataSourceSelectCondition:self.choices];
    [self removeAllChildTableView];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self updateParentTableViewFrameWithTotalCount:self.currentLevel+1];
    } completion:nil];
    [self reloadData];
}
///确认选项
- (void)confirm {
    if (self.selectedChoicesBlock) {
        self.selectedChoicesBlock(self.currentSelectedChoiceArr);
    }
}
///初始化选中项的下级选项控件
- (void)initPresentNextLevelTableView {
    
    NSArray<LXFilterChoice*>* selectedArr = self.currentSelectedChoiceArr;
    if (!selectedArr || selectedArr.count==0) {
        CGRect frame = self.frame;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, self.wholeWidth, frame.size.height);
        return;
    }
    NSUInteger levelCount = selectedArr.count;
    if (selectedArr.lastObject.subChoices && selectedArr.lastObject.subChoices.count) {
        levelCount += 1;
    }
    //计算
    CGFloat totalWidth = self.wholeWidth;
    NSUInteger currentTotal = levelCount;
    CGFloat width = totalWidth/currentTotal;
    
    __block CGFloat x = 0;
    CGFloat y = self.frame.origin.y;
    CGFloat height = self.frame.size.height;
    
    NSMutableArray<LXFilterLevelTableView*>* childVcArr = [NSMutableArray array];
    for (int i=1; i<levelCount; i++) {
        x = width*i+self.frame.origin.x-0.5;
        //创建新的下级table view
        LXFilterChoice* choice = selectedArr[i-1];
        LXFilterLevelTableView* childTableView = [[LXFilterLevelTableView alloc] initWithFrame:CGRectMake(x, y, width+0.5, height)
                                                                                       choices:choice.subChoices
                                                                                        inView:self.inView];

        childTableView.marginLeftAndRight = self.marginLeftAndRight;
        childTableView.backgroundColor = self.backColorArr[i];
        childTableView.currentLevel = i;
        childTableView.wholeWidth = self.wholeWidth;
        if (0 == childVcArr.count) {
            childTableView.parentTableView = self;
            self.childTableView = childTableView;
        }else {
            childTableView.parentTableView = childVcArr.lastObject;
            childVcArr.lastObject.childTableView = childTableView;
        }
        [self.inView addSubview:childTableView];
        [self.inView bringSubviewToFront:childTableView];
        [childVcArr addObject:childTableView];
    }
    
    CGRect frame = self.frame;
    self.frame = CGRectMake(self.marginLeftAndRight-0.5, frame.origin.y, width+0.5, frame.size.height);
    
    [childVcArr removeAllObjects];
    childVcArr = nil;
}
///播放堆栈视频动效
+ (void)p_stackAnimationWithBlock:(dispatch_block_t)block completion:(dispatch_block_t)completion {
    [UIView animateWithDuration:0.2f delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (block) {
            block();
        }
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}
///创建下级选项下拉控件
- (LXFilterLevelTableView*)p_createNextLevelTableViewFrame:(CGRect)frame choices:(NSArray<LXFilterChoice*>*)choices  {
    //创建新的下级table view
    LXFilterLevelTableView* childTableView = [[LXFilterLevelTableView alloc] initWithFrame:frame
                                                                                   choices:choices
                                                                                    inView:self.inView];
    childTableView.marginLeftAndRight = self.marginLeftAndRight;
    childTableView.currentLevel = self.currentLevel+1;
    childTableView.parentTableView = self;
    childTableView.backgroundColor = self.backColorArr[self.currentLevel+1];
    childTableView.selectedChoicesBlock = self.selectedChoicesBlock;
    childTableView.wholeWidth = self.wholeWidth;
    
    return childTableView;
}

#pragma mark --- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.choices.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LXLevelChoiceCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(LXLevelChoiceCell.class) forIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(LXLevelChoiceCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.choice  = self.choices[indexPath.row];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LXFilterChoice *choice = self.choices[indexPath.row];
    
    //重置排除当前选项之外的其他同级选项以及其下级选项状态
    [self p_resetDataSourceSelectCondition:choice.subChoices];
    choice.selected = !choice.isSelected;
    
    //更新上一个选中cell的UI
    if (_lastSelectedIndexPath) {
        LXLevelChoiceCell* lastCell = [tableView cellForRowAtIndexPath:_lastSelectedIndexPath];
        self.choices[_lastSelectedIndexPath.row].selected = NO;
        lastCell.choice = self.choices[_lastSelectedIndexPath.row];
    }
    //更新当前选中cell的UI
    LXLevelChoiceCell* currentCell = [tableView cellForRowAtIndexPath:indexPath];currentCell.selected = YES;
    currentCell.choice = choice;
    if (choice.isSelected) {
        _lastSelectedIndexPath = indexPath.copy;
    }else {
        _lastSelectedIndexPath = nil;
    }
    
    if (choice.isSelected) {//被选中
        if (choice.subChoices && choice.subChoices.count) {
            if (self.childTableView) {//如果下级存在
                [LXFilterLevelTableView p_stackAnimationWithBlock:^{
                    CGFloat originX = self.wholeWidth - self.childTableView.childTableView.frame.origin.x;
                    [self updateTableViewFrame:self.childTableView.childTableView originX:originX];
                    [self.childTableView updateParentTableViewFrameWithTotalCount:self.childTableView.currentLevel+1];
                    self.childTableView.choices = choice.subChoices;
                } completion:^{
                    [self.childTableView removeAllChildTableView];
                }];
            }else {
                //计算
                CGFloat totalWidth = self.wholeWidth;
                NSUInteger currentTotal = self.currentLevel+2;
                CGFloat width = totalWidth/currentTotal;
                
                //创建新的下级table view
                CGFloat height = self.frame.size.height;
                CGFloat x = self.wholeWidth;
                LXFilterLevelTableView* childTableView = [self p_createNextLevelTableViewFrame:CGRectMake(x, self.frame.origin.y, width, height) choices:choice.subChoices];
                self.childTableView = childTableView;
                [self.inView addSubview:childTableView];
                
                //更新所有的父级联的frame
                width = self.wholeWidth/currentTotal;
                x = width*(self.currentLevel+1)+self.marginLeftAndRight-0.5;
                [LXFilterLevelTableView p_stackAnimationWithBlock:^{
                    [self updateParentTableViewFrameWithTotalCount:currentTotal];
                    childTableView.frame = CGRectMake(x, self.frame.origin.y, width, height);
                } completion:0];
            }
        }else {//第一级table view回调才有效
            if (self.topFilterTableView.selectedChoicesBlock) {
                self.topFilterTableView.selectedChoicesBlock(self.topFilterTableView.currentSelectedChoiceArr);
            }
        }
    }else {
        [LXFilterLevelTableView p_stackAnimationWithBlock:^{
            [self updateTableViewFrame:self.childTableView originX:self.wholeWidth-self.childTableView.frame.origin.x];
            [self updateParentTableViewFrameWithTotalCount:self.currentLevel+1];
        } completion:^{
            [self removeAllChildTableView];
        }];
    }
}

#pragma mark --- lazy
- (NSArray *)backColorArr {
    if (!_backColorArr) {
        _backColorArr = @[
                          kLXHexColor(0xffffff), kLXHexColor(0xfbfbfb), kLXHexColor(0xf5f5f5),
                          kLXHexColor(0xf0f0f0), kLXHexColor(0xeaeaea), kLXHexColor(0xe5e5e5)
                          ];
    }
    return _backColorArr;
}
#ifdef DEBUG
- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
#endif

@end
