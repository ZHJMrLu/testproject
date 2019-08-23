//
//  SingleDemo.m
//  线程Thread
//
//  Created by bus365-04 on 2019/8/22.
//  Copyright © 2019 MrLu. All rights reserved.
//

#import "SingleDemo.h"

@implementation SingleDemo
+(instancetype)instance{
    static dispatch_once_t onceToken;
    static SingleDemo * single = nil;
    dispatch_once(&onceToken, ^{
        single = [[SingleDemo alloc]init];
        NSLog(@"SingleDemo init");
    });
    return single;
}
@end
