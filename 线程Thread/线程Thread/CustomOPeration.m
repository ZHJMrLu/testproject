//
//  CustomOPeration.m
//  线程Thread
//
//  Created by bus365-04 on 2019/8/24.
//  Copyright © 2019 MrLu. All rights reserved.
//

#import "CustomOPeration.h"
@interface CustomOPeration()
/** <#name#> */
@property(nonatomic,copy)NSString * operationName;
/** <#name#> */
@property(nonatomic,assign)BOOL  over;
@end
@implementation CustomOPeration
-(instancetype)initWithName:(NSString *)name{
    if (self = [super init]) {
        self.operationName = name;
    }
    return self;
}
#pragma mark 重写main函数
- (void)main{
//    for (int i = 0 ; i < 3; i ++) {
//        NSLog(@"%@ %d",self.operationName,i);
//        [NSThread sleepForTimeInterval:1];
//    }
    /**
     main函数直接执行 然后异步在执行
     2019-08-24 16:37:56.997227+0800 线程Thread[19761:274477] OperationA
     2019-08-24 16:37:56.997227+0800 线程Thread[19761:274478] OperationC
     2019-08-24 16:37:56.997226+0800 线程Thread[19761:274483] OperationD
     2019-08-24 16:37:56.997226+0800 线程Thread[19761:274476] OperationB
     */
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:1];
        if (self.cancelled) {
            return ;
        }
        NSLog(@"%@",self.operationName);
        self.over = YES;
    });
    // 添加判断 一直执行
    /**
     2019-08-24 16:41:48.589416+0800 线程Thread[19890:276737] OperationB
     2019-08-24 16:41:49.590558+0800 线程Thread[19890:276736] OperationC
     2019-08-24 16:41:50.595875+0800 线程Thread[19890:276737] OperationA
     2019-08-24 16:41:51.599212+0800 线程Thread[19890:276736] OperationD
     */
    while (!self.over && !self.cancelled) {
        [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}
@end
