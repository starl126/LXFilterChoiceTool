//
//  LXTestV1.m
//  LXFilterChoiceTool
//
//  Created by 天边的星星 on 2019/11/12.
//  Copyright © 2019 starxin. All rights reserved.
//

#import "LXTestV1.h"

@implementation LXTestV1

- (void)willMoveToSuperview:(UIView *)newSuperview {
    NSLog(@"%s,%@---%@",__PRETTY_FUNCTION__,newSuperview, NSStringFromCGRect(self.frame));
}
- (void)didMoveToSuperview {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)willMoveToWindow:(UIWindow *)newWindow {
    NSLog(@"%s--%@", __PRETTY_FUNCTION__, newWindow);
}
- (void)didMoveToWindow {
    NSLog(@"%s---%@", __PRETTY_FUNCTION__, self.window);
}

@end
