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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"主要";
    self.view.backgroundColor = UIColor.lightGrayColor;
    
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
    for (int i=0; i<30; i++) {
        LXFilterChoice* first = [LXFilterChoice new];
        first.content = [NSString stringWithFormat:@"一级选项--%d", i];
        first.choiceId = [NSString stringWithFormat:@"%d", i];
        if (i == 13) {
            first.selected = YES;
        }
        
        NSMutableArray* arrM = [NSMutableArray array];
        for (int j=0; j<40; j++) {
            LXFilterChoice* second = [LXFilterChoice new];
            second.content = [NSString stringWithFormat:@"%d: 二级选项--%d", i, j];
            second.choiceId = [NSString stringWithFormat:@"%d", j];
            if (j == 39) {
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
                
                NSMutableArray* fourM = [NSMutableArray array];
                for (int p=0; p<40; p++) {
                    LXFilterChoice* four = [LXFilterChoice new];
                    four.content = [NSString stringWithFormat:@"最后一级: %d", p];
                    four.choiceId = [NSString stringWithFormat:@"%d", p];
                    if (p==20) {
                        four.selected = YES;
                    }
                    [fourM addObject:four];
                }
                third.subChoices = fourM.copy;
                
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
