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
@end
@implementation TicketManager
-(instancetype)init{
    if (self = [super init]) {
        self.leftTickets = totalCount;
        self.threadBJ = [[NSThread alloc]initWithTarget:self selector:@selector(sale) object:nil];
        self.threadBJ.name = @"BJ";
        self.threadSH = [[NSThread alloc]initWithTarget:self selector:@selector(sale) object:nil];
        self.threadSH.name = @"SH";
    }
    return self;
}
-(void)sale{
    while (YES) {
        if (self.leftTickets > 0) {
            [NSThread sleepForTimeInterval:0.5];
            self.leftTickets--;
            self.saleCount = totalCount - self.leftTickets;
            NSLog(@"当前余票 %ld 已经卖出票数 %ld",self.leftTickets,self.saleCount);
        }
    }
}
-(void)startSale{
    [self.threadBJ start];
    [self.threadSH start];
}
@end
