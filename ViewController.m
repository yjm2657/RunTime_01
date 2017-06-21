//
//  ViewController.m
//  RunTime_01
//
//  Created by YJM on 2017/5/27.
//  Copyright © 2017年 YJM. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/objc-runtime.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Person *person = [[Person alloc]init];
    NSLog(@"%p",person);
    
    NSLog(@"%p",[person class]);
    
    NSLog(@"%p",[person class]);
    
    NSLog(@"%p",object_getClass(person));
//   前三个 都是访问的对象的地址
    
    NSLog(@"%p",object_getClass([person class]));
//    这个为 Person类的元类地址
    
    NSLog(@"%p",object_getClass([object_getClass([person class]) class]));
    
    NSLog(@"%p",object_getClass([NSObject class]));
    
//    注意 元类的调用只能用object_getclass()或者objc_class()获得,使用对象调用class方法师无法获取到元类的,它只是返回当前类对象而已
    
// 2.SEL Method IMP
    /*
     SEL是系统在编译过程中,会根据方法的名字以及参数序列生成一个用来区分这个方法的唯一ID,这个ID就是SEL类型的.
     我们需要注意的是,只要这个方法的名字和参数序列完全相同,那么他们的ID编号就是相同的
     */
    //获取SEL的几种方法
    SEL aSel = @selector(didReceiveMemoryWarning);
    SEL a_Sel = NSSelectorFromString(@"didReceiveMemoryWarning");
    SEL b_Sel = sel_registerName("didReceiveMemoryWarning");//不用@表示字符串  直接用""
    NSLog(@"%p---%p----%p",aSel,a_Sel,b_Sel);
    
    /*
     Method
        Method从字面上的看就是方法的意思.Method其实就是objec_method的结构体指针,
        结构如下:
        struct objc_method{
            SEL method_name       方法名
            char *method_types    参数类型以及返回值类型编码
            IMP method_imp        方法实现指针
        }
     */
    
    /*
     IMP 
     IMP即implementation,为指向函数实现的指针,如果我们能够获取到这个指针,则可以直接调用该方法,充分证实了它就是一个函数指针.
     */
    //获取IMP
    
    //通过Method获取IMP
    IMP method_getImplementation(Method m);
    //返回方法的具体实现
    IMP class_getMethodImplementation(Class cls, SEL name);
    IMP class_getMethodImplementation_stret ( Class cls, SEL name);
    
    //获取到IMP之后可直接调用方法
    SEL aSel_s = @selector(didReceiveMemoryWarning);
    Method method = class_getInstanceMethod([self class], aSel_s);
    IMP imp = method_getImplementation(method);
    ((void (*) (id, SEL)) (void  *)imp)(self, aSel);
    
//3.Ivar
    /*
     在Class结构体中,有一个ivar的链表结构,其中存储着所有变量信息(Ivar的数组),每一个Ivar指针对应一个变量元素.同时通过系统API,我们看到Ivar也是一个结构体,
     struct objc_ivar{
        char *ivar_name
        char *ivar_type
        int ivar_offset
        in space
     }
     */
    //对ivar的操作有一下方法
    
    //获取类中指定名称成员变量
    Ivar class_getInstanceVaribale( Class cls, const char *name);
    //获取类变量
    Ivar class_getClassVaribale(Class cls, const char *name);
    //获取整个成员变量列表
    Ivar *class_copyIvarList(Class cls, unsigned int *outCount);
    
#warning 需要注意的是:class_copIvarList这个函数,返回全部实例变量的数组,数组中每个ivar指向该成员变量信息的objc_ivar结构体的指针.这个数组不包含在父类中声明的变量.outCount指针返回数组的大小,我们必须用free()来释放这个数组
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
