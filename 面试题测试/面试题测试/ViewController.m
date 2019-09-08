//
//  ViewController.m
//  面试题测试
//
//  Created by 种花家 on 2019/9/4.
//  Copyright © 2019 MrLu. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //题 1
    // 死锁
    // 同步提交任务，无论是提交到并发队列还是串行队列，都是在当前线程执行
    //1:dispatch_sync在等待block语句执行完成，而block语句需要在主线程里执行，所以dispatch_sync如果在主线程调用就会造成死锁
    //2:dispatch_sync是同步的，本身就会阻塞当前线程，也即主线程。而又往主线程里塞进去一个block，所以就会发生死锁。
    //1. Dispatch 的核心是 Queue，分并行和串行两种，Main Queue 是典型的串行 Queue。
    //2. dispatch_sync 方法要等待放入 Queue 的 block 完成才返回。
    //3. 放入 Main Queue 的 block 需要等当前执行的方法（通常是由一个 Source 0 事件触发的）返回才能依次执行。
    /*
     这里先分清两个概念：Queue 和 Async、Sync。
     Queue（队列）：队列分为串行和并行。串行队列上面你按照A、B、C、D的顺序添加四个任务，这四个任务按顺序执行，结束顺序也肯定是A、B、C、D。而并行队列上面这四个任务同时执行，完成的顺序是随机的，每次都可能不一样。
     Async VS Sync（异步执行和同步执行）:使用dispatch_async 调用一个block，这个block会被放到指定的queue队尾等待执行，至于这个block是并行还是串行执行只和dispatch_async参数里面指定的queue是并行和串行有关。但是dispatch_async会马上返回。
     使用dispatch_sync 同样也是把block放到指定的queue上面执行，但是会等待这个block执行完毕才会返回，阻塞当前queue直到sync函数返回。
     所以队列是串行、并行 和 同步、异步执行调用block是两个完全不一样的概念。
     这两个概念清楚了之后就知道为什么死锁了。
     分两种情况：
     1、当前queue是串行队列。
     当前queue上调用sync函数，并且sync函数中指定的queue也是当前queue。需要执行的block被放到当前queue的队尾等待执行，因为这是一个串行的queue，
     调用sync函数会阻塞当前队列,等待block执行 -> 这个block永远没有机会执行 -> sync函数不返回，所以当前队列就永远被阻塞了，这就造成了死锁。（这就是问题中在主线程调用sync函数，并且在sync函数中传入main_queue作为queue造成死锁的情况）。
     2、当前queue是并行队列。
     在并行的queue上面调用sync函数，同时传入当前queue作为参数，并不会造成死锁，因为block会马上被执行，所以sync函数也不会一直等待不返回造成死锁。但是在并行队列上调用sync函数传入当前队列作为参数的用法，想不出什么情况下才会这样用。
     */
    /*
     dispatch_sync(dispatch_get_main_queue(), ^{
     NSLog(@"1");
     });
     */
    
    //题 2
    // 正常执行
    //async 在主线程中 创建了一个异步线程 加入 全局并发队列，async 不会等待block 执行完成，立即返回
    //[2510:63555] 1
    //[2510:63555] 3
    //[2510:63555] 2
    /*
     NSLog(@"1"); //
     dispatch_async(dispatch_get_main_queue(), ^{
     NSLog(@"2"); //
     });
     NSLog(@"3");
     */
    //题  3
    // 正常执行
    // 在串行队列执行，不影响主队列执行，不再同一队列不会产生死锁
    /*
    NSLog(@"1");
    dispatch_queue_t serialqueue = dispatch_queue_create("serialqueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(serialqueue, ^{
        
        NSLog(@"2");
    });
    NSLog(@"3");
     */
    //题  4
    // 正常执行 1 2 3 4 5
    // dispatch_get_global_queue 全局并发队列,如果为自定义串行队列，2 3 会产生死锁
    /*
    NSLog(@"1");
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"2");
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
     */
    //题  5
    // 结果 1 5 2 4
    // 线程中的runloop默认是没有启动的状态
    NSLog(@"1");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"2");
        [self performSelector:@selector(logData) withObject:nil afterDelay:0];
        // 执行后runloop
        [[NSRunLoop currentRunLoop] run];// 1 5 2 3 4
        NSLog(@"4");
    });
    NSLog(@"5");
}
-(void)logData{
    // 执行方法的线程与调用的方法的线程为同一个
    NSLog(@"3");
    NSNumber *age = [NSNumber numberWithInt:20];
    NSString *name = @"李周";
    NSString *gender = @"女";
    NSArray *friends = @[@"谢华华",@"亚呼呼"];
    
    SEL selector = NSSelectorFromString(@"getAge:name:gender:friends:");
    
    ((void(*)(id,SEL,NSNumber*,NSString*,NSString*,NSArray*)) objc_msgSend)(self,selector,age,name,gender,friends);
}
- (void)getAge:(NSNumber *)age name:(NSString *)name gender:(NSString *)gender friends:(NSArray *)friends
{
    NSLog(@"%d----%@---%@---%@",[age intValue],name,gender,friends[0]);
}
@end

