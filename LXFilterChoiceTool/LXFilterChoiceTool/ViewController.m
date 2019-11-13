//
//  ViewController.m
//  LXFilterChoiceTool
//
//  Created by 天边的星星 on 2019/11/7.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "ViewController.h"
#import "LXFilterSingleTableView.h"
#import "LXFilterChoice.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"主要";
    [self p_setupSingleChoiceTableView];
}
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

@end
