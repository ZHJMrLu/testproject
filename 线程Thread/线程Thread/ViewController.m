//
//  ViewController.m
//  线程Thread
//
//  Created by bus365-04 on 2019/8/20.
//  Copyright © 2019 MrLu. All rights reserved.
//

#import "ViewController.h"
#import "TicketManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self testNSThread];
}
#pragma mark - NSThread
-(void)testNSThread{
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [button setTitle:@"NSThread" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nsthreadClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(100, 150, 100, 100)];
    [button setTitle:@"NSThread" forState:UIControlStateNormal];
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
