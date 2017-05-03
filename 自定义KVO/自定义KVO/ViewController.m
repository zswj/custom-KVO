//
//  ViewController.m
//  自定义KVO
//
//  Created by kkk on 17/5/3.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+ZSKVO.h"
@interface ViewController ()

@property (nonatomic, strong) Person *p;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Person *p = [[Person alloc] init];
    p.age = 18;
    _p = p;
    //自定义KVO
    [p ZS_addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"监听到了");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _p.age = 99;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
