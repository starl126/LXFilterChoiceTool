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

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray<LXFilterChoice*>* allAddrs;
@property (nonatomic, strong) LXFilterLevelTableView* tableView;

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
    [self.tableView reset];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self p_setupLevelChoiceTableView];
//    CGRect frame = self.view.frame;
//    [UIView animateWithDuration:1.0 animations:^{
//        self.view.frame = CGRectMake(0, 100, frame.size.width-160, frame.size.height-200);
//    }];
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
