//
//  ViewController.m
//  线程Thread
//
//  Created by bus365-04 on 2019/8/20.
//  Copyright © 2019 MrLu. All rights reserved.
//

#import "ViewController.h"
#import "TicketManager.h"
#import "SingleDemo.h"
#import "CustomOPeration.h"

@interface ViewController ()
/** <#name#> */
@property(nonatomic,strong)NSOperationQueue * operationQueue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self testNSThread];
//    [self testGCD];
    [self testNSOperation];
}
#pragma mark - NSOperation
-(void)testNSOperation{
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 150, 50)];
    [button setTitle:@"NSOperation" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(operationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(100, 150, 250, 50)];
    [button setTitle:@"NSOperationQueue" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(operationQueueClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 250, 50)];
    [button setTitle:@"CustomOperation" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(customOperationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
#pragma mark NSOperation
-(void)operationClick{
    /** 方式一
    NSLog(@"invocationOperationAction");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInvocationOperation * operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(invocationOperationAction) object:nil];
        [operation start]; // 在当前线程执行
        NSLog(@"invocationOperationAction end");
    });
    */
    /** 方式二
    NSLog(@"NSBlockOperation");
    NSBlockOperation * blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"NSBlockOperation begin");
        for (int i = 0 ; i < 3; i ++) {
            NSLog(@"NSBlockOperation %d",i);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    [blockOperation start];
    */
    
    
}
-(void)invocationOperationAction{
    NSLog(@"invocationOperationAction begin");
    for (int i = 0 ; i < 3; i ++) {
        NSLog(@"InvocationOperation %d",i);
        [NSThread sleepForTimeInterval:2];
    }
}
#pragma mark NSOperationQueue
-(void)operationQueueClick{
    NSLog(@"NSOperationQueue");
    NSBlockOperation * blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"NSOperationQueue begin");
        for (int i = 0 ; i < 3; i ++) {
            NSLog(@"NSOperationQueue %d",i);
            [NSThread sleepForTimeInterval:2];
        }
    }];
    // 异步执行 开启新线程
    if (!self.operationQueue) {
        self.operationQueue = [[NSOperationQueue alloc]init];
    }
    [self.operationQueue addOperation:blockOperation];
    NSLog(@"NSOperationQueue end");
}
#pragma mark CustomOperation
-(void)customOperationClick{
    
    NSLog(@"CustomOPeration start");
    
    if (!self.operationQueue) {
        self.operationQueue = [[NSOperationQueue alloc]init];
    }
    // 设置最大并发数
//    [self.operationQueue setMaxConcurrentOperationCount:1];
    
    CustomOPeration * customA = [[CustomOPeration alloc]initWithName:@"OperationA"];
    
    CustomOPeration * customB = [[CustomOPeration alloc]initWithName:@"OperationB"];
    
    CustomOPeration * customC = [[CustomOPeration alloc]initWithName:@"OperationC"];
    
    CustomOPeration * customD = [[CustomOPeration alloc]initWithName:@"OperationD"];
    
    // 设置依赖 不能相互依赖
    [customD addDependency:customA];
    [customA addDependency:customC];
    [customC addDependency:customB];
    
    [self.operationQueue addOperation:customA];
    
    [self.operationQueue addOperation:customB];
    
    [self.operationQueue addOperation:customC];
    
    [self.operationQueue addOperation:customD];
    
    
    NSLog(@"CustomOPeration end");
}
#pragma mark - GCD
-(void)testGCD{
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 150, 50)];
    [button setTitle:@"GCD" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gcdClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(100, 150, 150, 50)];
    [button setTitle:@"global_queue" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(global_queueClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 150, 50)];
    [button setTitle:@"create_queue" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gcdCreateClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(100, 250, 150, 50)];
    [button setTitle:@"GCD_group" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gcdGroupClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(100, 300, 150, 50)];
    [button setTitle:@"GCD_group_test" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gcdGroupTestClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(100, 350, 150, 50)];
    [button setTitle:@"GCD_single" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gcdSingleClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
#pragma mark gcd 初识
-(void)gcdClick{
    NSLog(@"执行GCD");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"开始GCD");
        [NSThread sleepForTimeInterval:3];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回调到主线程");
        });
    });
    
}
#pragma mark global_queue
-(void)global_queueClick{
    // dispatch_get_global_queue 第一个参数优先级
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@"start task 1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 1");
        
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"start task 2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 2");
        
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"start task 3");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 3");
        
    });
}
#pragma mark queue_create
-(void)gcdCreateClick{
    // 同一个线程
    /** 第二个参数
     串行 DISPATCH_QUEUE_SERIAL 等于NULL 同一个线程id
     并行 DISPATCH_QUEUE_CONCURRENT 创建新的线程
     */
    NSLog(@"执行create");
    dispatch_queue_t queue = dispatch_queue_create("com.gcd.create", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"start task 1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 1");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"start task 2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 2");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"start task 3");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 3");
    });
    
}
#pragma mark Group
-(void)gcdGroupClick{
    
    NSLog(@"执行");
    dispatch_queue_t queue = dispatch_queue_create("com.gcd.group", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_t grpup = dispatch_group_create();
    
    dispatch_group_async(grpup, queue, ^{
        NSLog(@"start task 1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 1");
    });
    
    dispatch_group_async(grpup, queue, ^{
        NSLog(@"start task 2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 2");
    });
    
    dispatch_group_async(grpup, queue, ^{
        NSLog(@"start task 3");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 3");
    });
    
    dispatch_group_notify(grpup, queue, ^{
        NSLog(@"all task complete"); // 此时不在主线程 与最后一个任务的线程id相同
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"all task complete in main queue");
        });
    });
}
#pragma mark gcdGroupTest
-(void)gcdGroupTestClick{
    NSLog(@"执行");
    dispatch_queue_t queue = dispatch_queue_create("com.gcd.group", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_t grpup = dispatch_group_create();
    
    
    /*
    dispatch_group_async(grpup, queue, ^{
         [self sendRequest1:^{ // 异步请求 代码不停留 继续执行
            NSLog(@"request1 complete");
        }];
        
    });
    
    dispatch_group_async(grpup, queue, ^{
        [self sendRequest2:^{
            NSLog(@"request2 complete");
        }];
    });
     */
    /*  dispatch_group_enter dispatch_group_leave 成对出现 */
    dispatch_group_enter(grpup);
    [self sendRequest1:^{
        NSLog(@"request1 complete");
        dispatch_group_leave(grpup);
    }];
    
    dispatch_group_enter(grpup);
    [self sendRequest2:^{
        NSLog(@"request2 complete");
        dispatch_group_leave(grpup);
    }];
    
    dispatch_group_notify(grpup, queue, ^{
        NSLog(@"all task complete"); // 此时不在主线程 与最后一个任务的线程id相同
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"all task complete in main queue");
        });
    });
}
-(void)sendRequest1:(void(^)(void))block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"start task 1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 1");
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block();
            }
        });
    });
}
-(void)sendRequest2:(void(^)(void))block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"start task 2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end task 2");
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block();
            }
        });
    });
}
#pragma mark 单例
-(void)gcdSingleClick{
    SingleDemo * single = [SingleDemo instance];
    NSLog(@"%@",single);
    
    /** 拓展 */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"这句log只执行一次");
    });
}
#pragma mark - NSThread
-(void)testNSThread{
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 50)];
    [button setTitle:@"NSThread" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nsthreadClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(100, 150, 100, 50)];
    [button setTitle:@"NSThreadDemo" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nsthreadDemoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
#pragma mark NSThread init
-(void)nsthreadClick{
    NSLog(@"main-thread");
    
    NSThread * thread1 = [[NSThread alloc]initWithTarget:self selector:@selector(runThread1) object:nil];
    [thread1 start];
    // 线程名称
    thread1.name = @"Thread1";
    // 优先级 介于 0 - 1
    thread1.threadPriority = 0.5;
    
    [NSThread detachNewThreadSelector:@selector(runThread2) toTarget:self withObject:nil];
    
    [self performSelectorInBackground:@selector(runThread3) withObject:nil];
    
    NSLog(@"main-thread");
}
-(void)runThread1{
    /**
     [30298:398711] main-thread
     [30298:398711] main-thread
     [30298:399050] sub-thread
     [30298:399050] 1
     */
    NSLog(@"sub-thread alloc");
    for (int i = 1 ; i < 10 ; i ++ ) {
        NSLog(@"%d",i);
        sleep(1);
        NSString * name = [NSThread currentThread].name;
        NSLog(@"currentThread name %@",name);
    }
}
-(void)runThread2{
    
    NSLog(@"sub-thread detachNewThreadSelector");
    for (int i = 1 ; i < 10 ; i ++ ) {
        NSLog(@"%d",i);
        sleep(1);
    }
}
-(void)runThread3{
    
    NSLog(@"sub-thread performSelectorInBackground");
    for (int i = 1 ; i < 10 ; i ++ ) {
        NSLog(@"%d",i);
        sleep(1);
        if (i == 5) {
            [self performSelectorOnMainThread:@selector(runMainThread) withObject:nil waitUntilDone:YES];
        }
    }
}
-(void)runMainThread{
    NSLog(@"back main Thread");
}
#pragma mark NSThread demo
-(void)nsthreadDemoClick{
    TicketManager * manager = [[TicketManager alloc]init];
    [manager startSale];
}
@end
