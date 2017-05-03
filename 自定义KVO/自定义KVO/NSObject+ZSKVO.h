//
//  NSObject+ZSKVO.h
//  自定义KVO
//
//  Created by kkk on 17/5/3.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZSKVO)

- (void)ZS_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

@end
