//
//  ViewController.m
//  NSLock
//
//  Created by LVFM on 2021/3/31.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong) NSLock *lock;
@property (nonatomic, assign) NSInteger ticketCount;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //实例化
    _lock = [[NSLock alloc] init];
    
    _ticketCount = 100;
    
    dispatch_queue_t queue = dispatch_queue_create( "QiMultiThreadSafeQueue", DISPATCH_QUEUE_CONCURRENT);
    
    for(NSInteger i= 0; i< 10; i++) {
        dispatch_async(queue, ^{
            [self testNSLock];
        });
    }
}

//测试方法
- ( void)testNSLock
{
    while( 1) {
        //lock函数在成功加锁之间会一直阻塞，而tryLock会尝试加锁，如果不成功，不会阻塞，而是直接返回NO，lockBeforeDate则是阻塞到传入的NSDate日期为止。
        [_lock lock];
        if(_ticketCount > 0) {
            _ticketCount --;
            NSLog(@ "--->> %@已购票1张，剩余%ld张", [NSThread currentThread], (long)_ticketCount);
        }else{
            [_lock unlock];
            return;
        }
        [_lock unlock];
        sleep( 0.2);
    }
}



@end
