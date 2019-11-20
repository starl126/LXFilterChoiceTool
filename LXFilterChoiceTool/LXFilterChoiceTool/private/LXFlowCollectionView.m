//
//  LXFlowCollectionView.m
//  LXFilterChoiceTool
//
//  Created by 天边的星星 on 2019/11/18.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXFlowCollectionView.h"
#import "LXFilterChoice.h"
#import "LXFilterGroupChoice.h"

#define kLXFlowCellNormalColor (kLXHexColor(0x7D7D7D))
#define kLXFlowCellSelectColor (kLXHexColor(0x427AFF))
#define kLXFlowCellBorderWidth (1.0/UIScreen.mainScreen.scale)
#define kLXFlowCellCornerRadius 2.0
#define kLXFlowCellHorizonalMargin 4.0
#define kLXFlowCellSelectImgWidth 20.0
#define kLXFlowCellSelectImgHeight 20.0
#define kLXFlowCellTextFont  kLXSystemFont(12)
#define kLXFlowReusableViewColor (kLXHexColor(0x222222))
#define kLXFlowReusableFont  kLXMidBoldSystemFont(14)

#define kLXFlowLinesMargin 12.0
#define kLXFlowItemsMargin 12.0
#define kLXFlowEdgeInset UIEdgeInsetsMake(0, 12.0, 0, 12.0)
#define kLXFlowItemHeight 40.0
#define kLXFlowReusableHeight 44.0

@interface LXFlowChoiceCell: UICollectionViewCell

@property (nonatomic, strong) UILabel* contentLbl;
@property (nonatomic, strong) UIImageView* selectedImgV;

@property (nonatomic, strong) LXFilterChoice* choice;
@property (nonatomic, assign) BOOL needRefreshFrame;

@end

@implementation LXFlowChoiceCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = kLXFlowCellCornerRadius;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = kLXFlowCellNormalColor.CGColor;
        self.layer.borderWidth = kLXFlowCellBorderWidth;
    }
    return self;
}
- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow) {
        [self.contentView addSubview:self.contentLbl];
        [self.contentView addSubview:self.selectedImgV];
        self.needRefreshFrame = YES;
    }
}
- (void)setChoice:(LXFilterChoice *)choice {
    _choice = choice;
    self.contentLbl.text = choice.content;
    if (choice.isSelected) {
        self.contentLbl.textColor = kLXFlowCellSelectColor;
        self.layer.borderColor = kLXFlowCellSelectColor.CGColor;
        if (choice.isAllowMoreChoice) {
            self.selectedImgV.hidden = NO;
        }else {
            self.selectedImgV.hidden = YES;
        }
    }else {
        self.contentLbl.textColor = kLXFlowCellNormalColor;
        self.layer.borderColor = kLXFlowCellNormalColor.CGColor;
        self.selectedImgV.hidden = YES;
    }
    if (self.needRefreshFrame) {
        [self p_updateFrame];
        self.needRefreshFrame = NO;
    }
}
- (void)p_updateFrame {
    self.contentLbl.frame = CGRectMake(kLXFlowCellHorizonalMargin, 0, self.bounds.size.width-2*kLXFlowCellHorizonalMargin, self.bounds.size.height);
    self.selectedImgV.frame = CGRectMake(self.bounds.size.width-kLXFlowCellSelectImgWidth, self.bounds.size.height-kLXFlowCellSelectImgHeight, kLXFlowCellSelectImgWidth, kLXFlowCellSelectImgHeight);
}
- (UILabel *)contentLbl {
    if (!_contentLbl) {
        _contentLbl = [UILabel new];
        _contentLbl.numberOfLines = 0;
        _contentLbl.textAlignment = NSTextAlignmentCenter;
        _contentLbl.textColor = kLXFlowCellNormalColor;
        _contentLbl.font = kLXFlowCellTextFont;
    }
    return _contentLbl;
}
- (UIImageView *)selectedImgV {
    if (!_selectedImgV) {
        _selectedImgV = [[UIImageView alloc] initWithImage:kLXImageNamed(@"lx_whiteblueGou")];
        _selectedImgV.hidden = YES;
    }
    return _selectedImgV;
}

@end

@interface LXFlowCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel* contentLbl;
@property (nonatomic, copy) NSString* content;

@property (nonatomic, assign) BOOL needRefreshFrame;

@end

@implementation LXFlowCollectionReusableView

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow) {
        _contentLbl = ({
            UILabel* lbl = [UILabel new];
            lbl.font = kLXFlowReusableFont;
            lbl.textColor = kLXFlowReusableViewColor;
            lbl;
        });
        self.needRefreshFrame = YES;
        [self addSubview:_contentLbl];
    }
}
- (void)setContent:(NSString *)content {
    _content = content.copy;
    self.contentLbl.text = content;
    if (_needRefreshFrame) {
        self.contentLbl.frame = self.bounds;
    }
}

@end

@interface LXFlowCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

///流水布局的列数，默认是3
@property (nonatomic, assign) NSUInteger columns;

///flow layout
@property (nonatomic, weak) UICollectionViewFlowLayout* layout;

///数据源
@property (nonatomic, strong) NSArray<LXFilterGroupChoice*>* groupChoices;

///上一次选中的选项
@property (nonatomic, strong) NSMutableArray<LXFilterChoice*>* lastSelectedChoices;

///当前实时保存的选中选项
@property (nonatomic, strong) NSMutableArray<LXFilterChoice*>* instantSelectedChoices;

///重置的默认数据源
@property (nonatomic, strong) NSMutableArray<LXFilterChoice*>* resetSelectedChoices;

@end

@implementation LXFlowCollectionView

#pragma mark --- life cycle
- (instancetype)initWithFrame:(CGRect)frame groupChoices:(NSArray<LXFilterGroupChoice*>*)groupChoices {
    
    _columns = 3;
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.columns = 3;
        self.layout = layout;
        self.groupChoices = groupChoices.copy;
        self.lastSelectedChoices = [NSMutableArray array];
        self.instantSelectedChoices = [NSMutableArray array];
        self.resetSelectedChoices = [NSMutableArray array];
        self.backgroundColor = UIColor.whiteColor;
        [self p_initGroupChoices];
    }
    return self;
}
- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow) {
        [self p_updateFlowLayout];
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:LXFlowChoiceCell.class forCellWithReuseIdentifier:NSStringFromClass(LXFlowChoiceCell.class)];
        [self registerClass:LXFlowCollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(LXFlowCollectionReusableView.class)];
    }
}
///更新 flow layout的布局
- (void)p_updateFlowLayout {
    self.contentInset = kLXFlowEdgeInset;
    CGFloat validWidth = self.frame.size.width-kLXFlowEdgeInset.left-kLXFlowEdgeInset.right-(self.columns-1)*kLXFlowItemsMargin-1;
    CGFloat itemW = validWidth/self.columns;
    self.layout.itemSize = CGSizeMake(itemW, kLXFlowItemHeight);
}
///初始化选项LXFilterChoice对象内部计算性属性
- (void)p_initGroupChoices {
    __weak typeof(self) kLXWeakself = self;
    
    [self.groupChoices enumerateObjectsUsingBlock:^(LXFilterGroupChoice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        ///初始化被选中的选项数组
        [obj.groupChoices enumerateObjectsUsingBlock:^(LXFilterChoice * _Nonnull secObj, NSUInteger secIdx, BOOL * _Nonnull secStop) {
            secObj.groupTitle = obj.groupTitle;
            secObj.groupId = obj.groupId;
            secObj.groupExt = obj.groupExt;
            secObj.allowMoreChoice = obj.allowMoreChoice;
            
            if (secObj.isSelected) {//被选中
                [kLXWeakself.lastSelectedChoices addObject:secObj];
                [kLXWeakself.instantSelectedChoices addObject:secObj];
            }
            
            if (secObj.isAllowMoreChoice && secObj.isAllShortCut) {
                [kLXWeakself.resetSelectedChoices addObject:secObj];
            }
        }];
    }];
}
///点击选项时操作集合
- (void)p_actionForDealWithClickOneItem:(NSIndexPath*)indexPath {

//    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    
    NSArray<LXFilterChoice*>* groupChoices = self.groupChoices[indexPath.section].groupChoices;
    LXFilterChoice* choice = groupChoices[indexPath.item];
    
    [self p_updateAllChoicesChoosedStateAfterClickOneChoice:choice inGroup:self.groupChoices[indexPath.section]];
    
    [self p_updateChoosedChoicesForChoice:choice];
    
    NSIndexSet* set = [NSIndexSet indexSetWithIndex:indexPath.section];
    [UIView performWithoutAnimation:^{
        [self reloadSections:set];
    }];
    
//    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
//    printf("-----%lf\n",end-start);
    
    if (self.selectedGroupChoicesBlock) {
        NSArray* selectedArr = [self p_actionForDealWithSelectedChoices];
        self.selectedGroupChoicesBlock(selectedArr);
    }
}
///更新 实时被选中的选项数组
- (void)p_updateChoosedChoicesForChoice:(LXFilterChoice*)choice {
    
    __weak typeof(self) kLXWeakself = self;
    
    if (choice.isAllowMoreChoice) {//多选
        BOOL exist = YES;
        NSUInteger idx = [self.instantSelectedChoices indexOfObject:choice];
        if (idx == NSNotFound) {//不存在
            exist = NO;
        }
        if (exist) {//存在
            if (!choice.isSelected) {//未被选中
                [self.instantSelectedChoices removeObjectAtIndex:idx];
            }
        }else {//不存在
            if (choice.isAllShortCut) {//全部快捷键
                [self.instantSelectedChoices enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(LXFilterChoice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.groupId isEqualToString:choice.groupId] && ![obj.choiceId isEqualToString:choice.choiceId]) {
                        [kLXWeakself.instantSelectedChoices removeObjectAtIndex:idx];
                    }
                }];
                if (choice.isSelected) {
                    [self.instantSelectedChoices addObject:choice];
                }
            }else {//不是全部快捷键
                [self.instantSelectedChoices enumerateObjectsUsingBlock:^(LXFilterChoice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.groupId isEqualToString:choice.groupId] && obj.isAllShortCut) {
                        [kLXWeakself.instantSelectedChoices removeObjectAtIndex:idx];
                        *stop = YES;
                    }
                }];
                if (choice.isSelected) {
                    [self.instantSelectedChoices addObject:choice];
                }
            }
        }
    }else {//单选
        if (self.instantSelectedChoices.count) {
            [self.instantSelectedChoices enumerateObjectsUsingBlock:^(LXFilterChoice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.groupId isEqualToString:choice.groupId]) {
                    [kLXWeakself.instantSelectedChoices removeObjectAtIndex:idx];
                    *stop = YES;
                }
            }];
            if (choice.isSelected) {
                [self.instantSelectedChoices addObject:choice];
            }
        }else {
            [self.instantSelectedChoices addObject:choice];
        }
    }
}
///更新 所有选项的选中状态，当点击任何选项时
- (void)p_updateAllChoicesChoosedStateAfterClickOneChoice:(LXFilterChoice*)choice inGroup:(LXFilterGroupChoice*)group {
    if (choice.isAllowMoreChoice) {//多选
        choice.selected = !choice.isSelected;
        [group.groupChoices enumerateObjectsUsingBlock:^(LXFilterChoice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (choice.isAllShortCut) {
                if (![choice.choiceId isEqualToString:obj.choiceId]) {
                    obj.selected = NO;
                }
            }else {
                if (obj.isAllShortCut) {
                    obj.selected = NO;
                    *stop = YES;
                }
            }
        }];
    }else {//单选
        if (choice.atLeastOneChoice) {//有且必须有有一个值
            [group.groupChoices setValue:@(NO) forKeyPath:@"selected"];
            choice.selected = YES;
        }else {//可以没有值
            choice.selected = !choice.isSelected;
            [group.groupChoices enumerateObjectsUsingBlock:^(LXFilterChoice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ((![obj.choiceId isEqualToString:choice.choiceId]) && obj.isSelected) {
                    obj.selected = NO;
                    *stop = YES;
                }
            }];
        }
    }
}
///组装所有被选中选项
- (NSArray*)p_actionForDealWithSelectedChoices {
    NSMutableArray<NSString*>* groupIds = [NSMutableArray array];
    
    [self.instantSelectedChoices enumerateObjectsUsingBlock:^(LXFilterChoice * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![groupIds containsObject:obj.groupId]) {
            [groupIds addObject:obj.groupId];
        }
    }];
    if (groupIds.count == 0) {
        return nil;
    }
    
    NSMutableArray* topArrM = [NSMutableArray arrayWithCapacity:groupIds.count];
    for (NSString* groupId in groupIds) {
        NSMutableArray* arrM = [NSMutableArray array];
        
        for (NSUInteger i=0; i<self.instantSelectedChoices.count; i++) {
            LXFilterChoice* choice = self.instantSelectedChoices[i];
            if ([groupId isEqualToString:choice.groupId]) {
                [arrM addObject:choice];
            }
        }
        [topArrM addObject:arrM.copy];
    }
    return topArrM.copy;
}
- (void)confirm {
    [self.lastSelectedChoices setArray:self.instantSelectedChoices.copy];
    
    if (self.selectedGroupChoicesBlock) {
        NSArray* selectedArr = [self p_actionForDealWithSelectedChoices];
        self.selectedGroupChoicesBlock(selectedArr);
    }
}
- (void)reset {
    [self.instantSelectedChoices setValue:@(NO)  forKeyPath:@"selected"];
    [self.lastSelectedChoices    setValue:@(NO)  forKeyPath:@"selected"];
    [self.resetSelectedChoices   setValue:@(YES) forKeyPath:@"selected"];
    
    if (self.resetSelectedChoices.count) {
        [self.instantSelectedChoices setArray:self.resetSelectedChoices.copy];
        [self.lastSelectedChoices setArray:self.resetSelectedChoices.copy];
    }else {
        [self.instantSelectedChoices removeAllObjects];
        [self.lastSelectedChoices removeAllObjects];
    }
    [self reloadData];
    
    if (self.selectedGroupChoicesBlock) {
        NSArray* selectedArr = [self p_actionForDealWithSelectedChoices];
        self.selectedGroupChoicesBlock(selectedArr);
    }
}
- (void)rebackLastSelectedState {
    [self.instantSelectedChoices setValue:@(NO)  forKeyPath:@"selected"];
    [self.lastSelectedChoices    setValue:@(YES) forKeyPath:@"selected"];
    [self.instantSelectedChoices setArray:self.lastSelectedChoices.copy];
    [self reloadData];
}
- (NSArray<NSArray<LXFilterChoice*>*>*)currentChoosedChoices {
    return [self p_actionForDealWithSelectedChoices];
}

#pragma mark --- UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.groupChoices.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray <LXFilterChoice *>* choices = self.groupChoices[section].groupChoices;
    return choices.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LXFlowChoiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(LXFlowChoiceCell.class) forIndexPath:indexPath];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    LXFlowCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(LXFlowCollectionReusableView.class) forIndexPath:indexPath];
    //判断是否有section
    LXFilterGroupChoice* group = self.groupChoices[indexPath.section];
    if (group.groupTitle && group.groupTitle.length) {//有section view
        headerView.content = group.groupTitle;
        return headerView;
    }else {
        return nil;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    LXFilterGroupChoice* group = self.groupChoices[section];
    if (group.groupTitle && group.groupTitle.length) {//有section view
        return CGSizeMake(self.bounds.size.width, kLXFlowReusableHeight);
    }else {
        return CGSizeZero;
    }
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(LXFlowChoiceCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray <LXFilterChoice *>*choices = self.groupChoices[indexPath.section].groupChoices;
    cell.choice = choices[indexPath.item];
}
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(LXFlowCollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    LXFilterGroupChoice* group = self.groupChoices[indexPath.section];
    if (group.groupTitle && group.groupTitle.length) {
        view.content = group.groupTitle;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(p_actionForDealWithClickOneItem:) object:indexPath];
    [self performSelector:@selector(p_actionForDealWithClickOneItem:) withObject:indexPath afterDelay:0.08];
}
#ifdef DEBUG
- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
#endif

@end
