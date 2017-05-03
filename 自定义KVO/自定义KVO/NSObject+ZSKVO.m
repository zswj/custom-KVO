//
//  NSObject+ZSKVO.m
//  自定义KVO
//
//  Created by kkk on 17/5/3.
//  Copyright © 2017年 bianming. All rights reserved.
//

#import "NSObject+ZSKVO.h"
#import <objc/message.h>
@implementation NSObject (ZSKVO)
- (void)ZS_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    //动态建个子类! 重写监听属性的set方法
    /*
     1.自定义一个类 继承与self 
     2.重写父类的被监听的属性的set方法 (age)
     3.调用obsetver 的observeValueForKeyPath方法
     */
    //动态添加一个类
    NSString * oldClassN = NSStringFromClass([self class]);
    NSString * newClassN = [@"zs_" stringByAppendingString:oldClassN];
    const char *name = [newClassN UTF8String];
    //创建Person的子类
    Class MyClass = objc_allocateClassPair([self class], name, 0);
    //重写setAge方法
    class_addMethod(MyClass, @selector(setAge:), (IMP)setAge, "v@:i");
    //注册一个类(注册这个子类)
    objc_registerClassPair(MyClass);
    
    //修改被观察对象的isa指针  也就是self的isa指针 此刻self就是继承与Person的子类对象
    object_setClass(self, MyClass);
    
    //将观察者属性保存到当前累里面(被监听的值改变的时候,可取出执行方法)
    objc_setAssociatedObject(self, (__bridge const void*)@"objc", observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
}
//相当于重写setAge方法 实现
void setAge(id self, SEL _cmd, int age) {
    /*
     要调用super 的setAge方法
     让这个类指针指向父类 调用setAge方法后 在让这个类指向子类
     */
    //保存当前类
    Class myClass = [self class];
    NSLog(@"调用了没有%@", self);
    //将self的isa指针改成父类 调用父类的 setAge方法
    object_setClass(self, class_getSuperclass([self class]));
    
    //调用父类
    objc_msgSend(self, @selector(setAge:), age);
    
    //通知观察者
    //拿出观察者
    id objc = objc_getAssociatedObject(self, (__bridge const void*)@"objc");
    //通知观察者 执行方法
    objc_msgSend(objc, @selector(observeValueForKeyPath:ofObject:change:context:),self,@"age", nil, nil);
    
    
    //再把当前类改成子类
    object_setClass(self, myClass);
}



@end
