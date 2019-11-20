//
//  ViewController.m
//  LXFilterChoiceTool
//
//  Created by 天边的星星 on 2019/11/7.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "ViewController.h"
#import "LXFilterSingleTableView.h"
#import "LXFilterLevelTableView.h"
#import "LXFilterChoice.h"
#import "LXFilterGroupChoice.h"
#import "LXFlowCollectionView.h"
#import "Test1.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray<LXFilterChoice*>* allAddrs;
@property (nonatomic, strong) LXFilterLevelTableView* tableView;
@property (nonatomic, strong) LXFlowCollectionView* flowCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"主要";
    self.view.backgroundColor = UIColor.lightGrayColor;
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc] initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(p_actionForClickReset)];
    self.navigationItem.rightBarButtonItem = rightBar;
}
- (void)p_actionForClickReset {
//    [self.tableView reset];
    NSInteger index = 0;
    if (0 == index) {
        [self.flowCollectionView reset];
    }else if (1 == index) {
        [self.flowCollectionView rebackLastSelectedState];
    }else {
        [self.flowCollectionView confirm];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
 
//    [self p_testArrayValueSetPerformance];
    
    
    [self p_setupFlowChoiceCollectionView];
//    [self p_setupLevelChoiceTableView];
    
//    CGRect frame = self.view.frame;
//    [UIView animateWithDuration:1.0 animations:^{
//        self.view.frame = CGRectMake(0, 100, frame.size.width-160, frame.size.height-200);
//    }];
}
///测试性能
- (void)p_testArrayValueSetPerformance {
    NSArray<Test1*>* arr1 = [self p_setupTest];
    NSArray<Test1*>* arr2 = [self p_setupTest];
    
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    [arr1 makeObjectsPerformSelector:@selector(setContent:) withObject:@"222"];
    [arr1 makeObjectsPerformSelector:@selector(setContent:) withObject:@"111"];
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    printf("makeObjects---%lf", end-start);
    
    start = CFAbsoluteTimeGetCurrent();
    [arr1 setValue:@"222" forKey:@"content"];
    [arr2 setValue:@"111" forKey:@"content"];
    end = CFAbsoluteTimeGetCurrent();
    printf("setValue---%lf", end-start);
    
    start = CFAbsoluteTimeGetCurrent();
    [arr1 enumerateObjectsUsingBlock:^(Test1 * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.content = @"222";
    }];
    [arr2 enumerateObjectsUsingBlock:^(Test1 * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.content = @"111";
    }];
    end = CFAbsoluteTimeGetCurrent();
    printf("enumerate---%lf", end-start);
}
///测试
- (NSArray*)p_setupTest {
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    
    NSMutableArray* arrM = [NSMutableArray array];
    for (int i=0; i<10000; i++) {
        Test1* t1 = [Test1 new];
        t1.selected = NO;
        t1.content = [NSString stringWithFormat:@"content:%d", i];
        [arrM addObject:t1];
    }
    
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    printf("\n创建数组：%lf\n", end-start);
    return arrM.copy;
}
///测试流水多选
- (void)p_setupFlowChoiceCollectionView {
    
    NSMutableArray* groupArrM = [NSMutableArray array];
    
    for (int i=0; i<5; i++) {
        LXFilterGroupChoice* group = [LXFilterGroupChoice new];
        group.groupTitle = [NSString stringWithFormat:@"group:%d", i];
        group.groupId = [NSString stringWithFormat:@"%d", i];
        group.allowMoreChoice = YES;
//        group.mustHaveChoice = NO;
        
        NSMutableArray* choiceArrM = [NSMutableArray array];
        for (int j=0; j<8; j++) {
            LXFilterChoice* choice = [LXFilterChoice new];
            choice.content = [NSString stringWithFormat:@"content:%d-%d",i,j];
            choice.choiceId = [NSString stringWithFormat:@"%d", j];
            if (0 == j) {
                choice.allShortCut = YES;
                choice.selected = YES;
            }
            [choiceArrM addObject:choice];
        }
        group.groupChoices = choiceArrM.copy;
        
        [groupArrM addObject:group];
    }
    
    LXFlowCollectionView* flowCollection = [[LXFlowCollectionView alloc] initWithFrame:self.view.bounds
                                                                          groupChoices:groupArrM.copy];
    [self.view addSubview:flowCollection];
    flowCollection.selectedGroupChoicesBlock = ^(NSArray<NSArray<LXFilterChoice *> *> * _Nullable selectedGroupArr) {
        for (NSArray* arr in selectedGroupArr) {
            for (LXFilterChoice* one in arr) {
                printf("数组：%tu, 选中----%s\n",arr.count,one.content.UTF8String);
            }
        }
    };
    self.flowCollectionView = flowCollection;
}
///测试多级单选
- (void)p_setupLevelChoiceTableView {
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    
    NSMutableArray* topArrM = [NSMutableArray array];
    for (int i=0; i<15; i++) {
        LXFilterChoice* first = [LXFilterChoice new];
        first.content = [NSString stringWithFormat:@"一级选项--%d", i];
        first.choiceId = [NSString stringWithFormat:@"%d", i];
        if (i == 14) {
            first.selected = YES;
        }
        
        NSMutableArray* arrM = [NSMutableArray array];
        for (int j=0; j<15; j++) {
            LXFilterChoice* second = [LXFilterChoice new];
            second.content = [NSString stringWithFormat:@"%d: 二级选项--%d", i, j];
            second.choiceId = [NSString stringWithFormat:@"%d", j];
            if (j == 14) {
                second.selected = YES;
            }
            
            NSMutableArray* thirdM = [NSMutableArray array];
            for (int k=0; k<20; k++) {
                LXFilterChoice* third = [LXFilterChoice new];
                third.content = [NSString stringWithFormat:@"%d:%d: 二级选项--%d", i, j, k];
                third.choiceId = [NSString stringWithFormat:@"%d", k];
                if (k == 19) {
                    third.selected = YES;
                }
                
                [thirdM addObject:third];
            }
            second.subChoices = thirdM.copy;
            
            [arrM addObject:second];
        }
        first.subChoices = arrM.copy;
        
        [topArrM addObject:first];
    }
    
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    NSLog(@"------%lf", end-start);
    
    LXFilterLevelTableView* tableView = [[LXFilterLevelTableView alloc] initWithFrame:self.view.bounds
                                                                              choices:topArrM.copy
                                                                               inView:self.view];
    [self.view addSubview:tableView];
    [tableView initPresentNextLevelTableView];
    
    tableView.selectedChoicesBlock = ^(NSArray<LXFilterChoice *> * _Nonnull selectedArr) {
        for (LXFilterChoice* one in selectedArr) {
            printf("%s\n", one.content.UTF8String);
        }
    };
    
    self.tableView = tableView;
}
///测试单级单选或者多选
- (void)p_setupSingleChoiceTableView {
    NSMutableArray<LXFilterChoice*>* arrM = [NSMutableArray arrayWithCapacity:5];
    for (int i=0; i<50; i++) {
        NSString* content = [NSString stringWithFormat:@"选项--%d", i];
        NSString* choiceId = [NSString stringWithFormat:@"%d", i];
        LXFilterChoice* choice = [self p_setSingleChoiceWithContent:content choiceId:choiceId];
        [arrM addObject:choice];
    }
    
    LXFilterSingleTableView* tableView = [[LXFilterSingleTableView alloc] initWithFrame:self.view.bounds choices:arrM.copy];
    [self.view addSubview:tableView];
    tableView.selectedChoicesBlock = ^(NSArray<LXFilterChoice *> * _Nullable choicesArr, BOOL valid) {
        for (LXFilterChoice* one in choicesArr) {
            NSLog(@"%@---%d", one, valid);
        }
    };
}
- (LXFilterChoice *)p_setSingleChoiceWithContent:(NSString*)content choiceId:(NSString*)choiceId {
    LXFilterChoice* choice = [LXFilterChoice new];
    choice.content = content.copy;
    choice.choiceId = choiceId.copy;
    choice.mustHaveChoice = NO;
    choice.allowMoreChoice = YES;
    return choice;
}

#pragma mark --- lazy

@end
