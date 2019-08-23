//
//  TicketManager.m
//  线程Thread
//
//  Created by bus365-04 on 2019/8/20.
//  Copyright © 2019 MrLu. All rights reserved.
//

#import "TicketManager.h"

#define totalCount 50
@interface TicketManager()
/** 剩余票数 */
@property(nonatomic,assign)NSInteger  leftTickets;
/** 卖出票数 */
@property(nonatomic,assign)NSInteger  saleCount;
/** 卖票点 */
@property(nonatomic,strong)NSThread * threadBJ;
/** 卖票点 */
@property(nonatomic,strong)NSThread * threadSH;
/** <#name#> */
@property(nonatomic,strong)NSCondition * ticketContion;
@end
@implementation TicketManager
-(instancetype)init{
    if (self = [super init]) {
        self.leftTickets = totalCount;
        self.threadBJ = [[NSThread alloc]initWithTarget:self selector:@selector(sale) object:nil];
        self.threadBJ.name = @"BJ";
        self.threadSH = [[NSThread alloc]initWithTarget:self selector:@selector(sale) object:nil];
        self.threadSH.name = @"SH";
        
        self.ticketContion = [[NSCondition alloc]init];
    }
    return self;
}
-(void)sale{
    // 问题 不同线程卖同一张票 加锁的方式解决
    
    // 线程Thread[31219:356402] 当前余票 45 已经卖出票数 5
    // 线程Thread[31219:356403] 当前余票 45 已经卖出票数 5
    while (YES) {
        // 方法一
//        @synchronized (self) {
//            if (self.leftTickets > 0) {
//                [NSThread sleepForTimeInterval:0.5];
//                self.leftTickets--;
//                self.saleCount = totalCount - self.leftTickets;
//                NSLog(@"当前余票 %ld 已经卖出票数 %ld",self.leftTickets,self.saleCount);
//            }
//        }
        // 方法二
        [self.ticketContion lock];
        if (self.leftTickets > 0) {
            [NSThread sleepForTimeInterval:0.5];
            self.leftTickets--;
            self.saleCount = totalCount - self.leftTickets;
            NSLog(@"当前余票 %ld 已经卖出票数 %ld",self.leftTickets,self.saleCount);
        }
        [self.ticketContion unlock];
    }
}
-(void)startSale{
    [self.threadBJ start];
    [self.threadSH start];
}
@end
