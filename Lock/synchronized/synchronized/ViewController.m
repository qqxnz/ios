//
//  ViewController.m
//  synchronized
//
//  Created by LVFM on 2021/3/31.
//

#import "ViewController.h"

@interface ViewController ()
/// 窗口1
@property (nonatomic, strong) NSThread *thread1;
/// 窗口2
@property (nonatomic, strong) NSThread *thread2;
/// 窗口3
@property (nonatomic, strong) NSThread *thread3;

@property (nonatomic, strong) NSMutableArray *ticketPool;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ticketPool = [[NSMutableArray alloc]init];
    
    self.thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTickets) object:nil];
    [self.thread1 setName:@"窗口A"];
    self.thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTickets) object:nil];
    [self.thread2 setName:@"窗口B"];
    self.thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTickets) object:nil];
    [self.thread3 setName:@"窗口C"];
    
    [self addTicket:@"普通"];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self.thread1 start];
    [self.thread2 start];
    [self.thread3 start];
}

- (void)saleTickets
{
    NSLog(@"开始卖票");
    while (YES) {
        //模拟耗时操作
        if([NSThread.currentThread.name isEqualToString:@"窗口B"]){
            if(self.ticketPool.count < 10 && self.ticketPool.count > 7){
                NSLog(@"-窗口B-线程-耗时操作");
                [NSThread sleepForTimeInterval:1.0];
            }
        }
        
       NSString *ticket = [self getTicketWithPool];
        if(ticket){
            NSLog(@"%@-%@",NSThread.currentThread.name,ticket);
        }else{
            NSLog(@"%@-票卖光了!",NSThread.currentThread.name);
            break;
        }
    }
    NSLog(@"结束卖票");
}

- (NSString *)getTicketWithPool
{
    @synchronized (self.ticketPool) {
        if(self.ticketPool.count > 0){
            //模拟耗时操作
//            if([NSThread.currentThread.name isEqualToString:@"窗口A"]){
//                if(self.ticketPool.count < 10 && self.ticketPool.count > 7){
//                    NSLog(@"-窗口A-锁-耗时操作");
//                    [NSThread sleepForTimeInterval:1.0];
//                }
//            }
            NSString *ticket = self.ticketPool[self.ticketPool.count - 1];
            [self.ticketPool removeObject:ticket];
            return ticket;
        }else{
            return nil;
        }
    }
}

- (void)addTicket:(NSString *)type
{
    for (NSInteger index = 0; index < 100; index++) {
        NSString *ticket = [NSString stringWithFormat:@"%@-%ld",type,index];
        @synchronized (self.ticketPool) {
            [self.ticketPool addObject:ticket];
        }
    }
    
}

@end
