//
//  LXLevelChoiceCell.h
//  LXFilterChoiceTool
//
//  Created by 天边的星星 on 2019/11/13.
//  Copyright © 2019 starxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXFilterChoice;
NS_ASSUME_NONNULL_BEGIN

///多级单选的控件
@interface LXLevelChoiceCell : UITableViewCell

@property (nonatomic, strong) LXFilterChoice* choice;

@end

NS_ASSUME_NONNULL_END
