//
//  ReflectUtil.m
//  ZJKReflectUtil
//
//  Created by zhangjikuan on 2019/11/4.
//

#import "ReflectUtil.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "objc/objc.h"
#import "objc/objc-api.h"

#define ARRAY(...) ([NSArray arrayWithObjects: IDARRAY(__VA_ARGS__) count: IDCOUNT(__VA_ARGS__)]
#define $set(...)     ((NSSet *)[NSSet setWithObjects:__VA_ARGS__,nil])

@implementation ReflectUtil

-(id)init{
    
    self=[super init];
    if (self) {
        
        typeind=[[NSMutableDictionary alloc] init];
        
        [typeind setValue:@"0" forKey:@"Ti"]; //for integer data type;
        
        [typeind setValue:@"1" forKey:@"Td"]; //for double data type;
        
        [typeind setValue:@"2" forKey:@"Tq"]; //for long long int data type;
        
        [typeind setValue:@"3" forKey:@"Tl"]; //for long data type;
        
        [typeind setValue:@"4" forKey:@"Tf"]; //for float data type;
        
        [typeind setValue:@"5" forKey:@"TQ"]; // for unsigned long long int data type;
        
        [typeind setValue:@"6" forKey:@"Tc"];// for BOOL datatype;
        
        [typeind setValue:@"7" forKey:@"T@\"NSString\""];//for NSString data type;
        
        [typeind setValue:@"8" forKey:@"T@\"NSDate\""]; // for NSDate data type;
        
        [typeind setValue:@"9" forKey:@"T@\"NSData\""];// for NSData data type;
        
        [typeind setValue:@"10" forKey:@"T@"];//for id data type;
        
        return self;
    }
    return nil;
    
}



//使用默认构造函数的构建器
-(id)buildTargetObjectByClassName:(NSString *)classname{
    
    Class defineclass = [self getClassByName:classname];
#if !__has_feature(objc_arc)
    id selfdefine=[[[defineclass alloc]init] autorelease];
#else
    id selfdefine =[[defineclass alloc]init];
#endif
    return selfdefine;
    
}


// use the dictionary and constructor and classname to instant an object.

-(id)buildTargetObjectByClassName:(NSString *)classname andInitParamWithMap:(NSDictionary *)param andConstructorName:(NSString *)constructor{
    
    if (!classname) {
        
        return nil;
    }
    
    id instance = [[self getClassByName:classname] alloc];
    
    SEL  sel = NSSelectorFromString(constructor);
    
    NSMethodSignature   *singlenature =[instance methodSignatureForSelector:sel];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:singlenature];
    
    [invocation setTarget:instance];
    
    [invocation setSelector:sel];
    
    
    NSUInteger i = 1;
    
    for (NSString  *key in [param allKeys]) {
        
        id object =[param valueForKey:key];
        
        [invocation setArgument:&object atIndex:++i];
        
    }
    [invocation invoke];
    
    void* data = NULL;
    
    if ([singlenature methodReturnLength]) {
        
        [invocation getReturnValue:&data];
        
    }
    return (__bridge id)data;
    
    return nil;
}

- (NSMethodSignature *)classMethodSignatureWithClass:(Class)clazz selector:(SEL)selector{
    
    
    printf("%s",method_getTypeEncoding(class_getClassMethod(clazz, selector)));
    return  [NSMethodSignature signatureWithObjCTypes:method_getTypeEncoding(class_getClassMethod(clazz, selector))];
    
}


-(id)dynamicCallingBySingleton:(NSString *)classname andInitParamWithArray:(NSArray *)param andMethodName:(NSString *)method{
    if (!classname) {
        
        return nil;
    }
    Class class = [self getClassByName:classname];
    
    SEL  sel = NSSelectorFromString(method);
    
    
    
    NSMethodSignature   *singlenature =[self classMethodSignatureWithClass:class selector:sel];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:singlenature];
    
    [invocation setTarget:class];
    
    [invocation setSelector:sel];
    
      NSUInteger i = 1;
    
    for (id object in param) {
        
        [invocation setArgument:(void *)&object atIndex:++i];
        
    }
    [invocation invoke];
    
    void* data = NULL;
    
    if ([singlenature methodReturnLength]!=0) {
        
        [invocation getReturnValue:&data];
        
    }
    return (__bridge id)data;
    
    return nil;
    
}

// use the array and constructor and classname to instant an object
-(id)buildTargetObjectByClassName:(NSString *)classname andInitParamWithArray:(NSArray *)param andConstructorName:(NSString *)constructor{
    if (!classname) {
        
        return nil;
    }
    id instance = [[self getClassByName:classname] alloc];
    
    SEL   sel=NSSelectorFromString(constructor);
    
    NSMethodSignature   *singlenature =[instance methodSignatureForSelector:sel];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:singlenature];
    
    [invocation setTarget:instance];
    
    [invocation setSelector:sel];
    
    NSUInteger i = 1;
    for (id object in param) {
        
        [invocation setArgument:(void *)&object atIndex:++i];
        
    }
    [invocation invoke];
    void* data = NULL;
    
    if ([singlenature methodReturnLength]) {
        
        [invocation getReturnValue:&data];
        
    }
    return (__bridge id)data;
    
}

// use the array and constructor and classname to instant an object

-(id)buildTargetObjectByClassName:(NSString *)classname andSingleParam:(NSObject *)param andConstructorName:(NSString *)constructor{
    if (!classname) {
        
        return nil;
    }
    id instance =[[self getClassByName:classname] alloc];
    
    SEL  sel = NSSelectorFromString(constructor);
    
    NSMethodSignature   *singlenature = [instance methodSignatureForSelector:sel];
    
    NSInvocation   *invocation = [NSInvocation invocationWithMethodSignature:singlenature];
    
    [invocation setTarget:instance];
    
    [invocation setSelector:sel];
    
    [invocation setArgument:&param atIndex:2];
    
    [invocation invoke];
    
    void* data = NULL;
    
    if ([singlenature methodReturnLength]) {
        
        [invocation getReturnValue:&data];
        
    }
    return (__bridge id)data;
    
}
/*
 - (id)performSelector:(SEL)aSelector withParameters:(void *)firstParameter, ... {
 NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
 NSUInteger length = [signature numberOfArguments];
 NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
 [invocation setTarget:self];
 [invocation setSelector:aSelector];
 
 [invocation setArgument:&firstParameter atIndex:2];
 va_list arg_ptr;
 va_start(arg_ptr, firstParameter);
 for (NSUInteger i = 3; i < length; ++i) {
 void *parameter = va_arg(arg_ptr, void *);
 [invocation setArgument:&parameter atIndex:i];
 }
 va_end(arg_ptr);
 
 [invocation invoke];
 
 if ([signature methodReturnLength]) {
 id data;
 [invocation getReturnValue:&data];
 return data;
 }
 return nil;
 }
 */


-(id)transformResult:(NSMutableDictionary *)resultset ToObject:(NSString *)classname{
    
    Class defineclass=NSClassFromString(classname);
    
    id selfdefineobj=[[defineclass alloc] init];
    
    unsigned int outcount;
    int i;
    objc_property_t *propertyX=class_copyPropertyList(defineclass, &outcount);//获得属性列表
    for (i=0; i<outcount; i++) {
        
        objc_property_t  currentproperty=propertyX[i];
        
        const char* propertyname=property_getName(currentproperty);
        
        
        NSString *objcname=[[NSString alloc] initWithCString:propertyname encoding:NSUTF8StringEncoding];
        
        
        NSString *methodlowercase=[NSMutableString stringWithFormat:@"%@%@:",@"set",objcname];
        
        SEL mysel=[self confirmWithMethodWillbeCalling:defineclass methodName:methodlowercase];
        
        NSString *datatype=[self getPropertyType:currentproperty];
        
        NSString *tind=[typeind valueForKey:datatype];
        
        id values=[self setValueFor:objcname datatypeind:[tind intValue]  valueMap:resultset] ;
        
#if !__has_feature(objc_arc)
        [objcname release];
#endif
        
        if (values!=nil && mysel) {
            
            //objc_msgSend(selfdefineobj,mysel,values);
            [self InvokenFunctionByName:mysel instance:selfdefineobj andSingleParam:values];
        }
    }
    
    return selfdefineobj;
    
}

// use the array and method name and instance to dynamic calling a method of the current instance.
-(id)dynamicCallingByInstance:(NSObject *)instance andInitParamWithArray:(NSArray *)param andMethodName:(NSString *)method{
    
    SEL   sel=NSSelectorFromString(method);
    
    NSMethodSignature   *singlenature =[instance methodSignatureForSelector:sel];
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:singlenature];
    
    [invocation setTarget:instance];
    
    [invocation setSelector:sel];
    
    NSUInteger i = 1;
    for (id object in param) {
        
        [invocation setArgument:(void *)&object atIndex:++i];
        
    }
    [invocation invoke];
    void* data;
    if ([singlenature methodReturnLength]!=0) {
        
        [invocation getReturnValue:&data];
        return (__bridge id)data;
    }
    
    return nil;
}


-(id)setValueFor:(NSString *)column datatypeind:(NSInteger)ind valueMap:(NSMutableDictionary *)result{
    
    id returnvalue=nil;
    switch (ind) {
        case 0: //int
            
            returnvalue=[[NSNumber alloc] initWithInt:([result valueForKey:column]==nil  ?  0 : [[result valueForKey:column] intValue])];
            break;
        case 1: //double
            
            returnvalue=[[NSNumber alloc] initWithDouble:([result valueForKey:column]==nil ? 0.0: [[result valueForKey:column] doubleValue])];
            
            break;
            
        case 2: //longlong
            
            returnvalue =[[NSNumber alloc] initWithLongLong:([result valueForKey:column]==nil ? 0: [[result valueForKey:column] longLongValue])];
            break;
            
        case 3://long
            
            returnvalue =[[NSNumber alloc] initWithLongLong:([result valueForKey:column]==nil ? 0: [[result valueForKey:column] longValue])];
            break;
        case 4: //float
            
            returnvalue=[[NSNumber alloc] initWithDouble:([result valueForKey:column]==nil ? 0.0: [[result valueForKey:column] floatValue])];
            break;
        case 5: //unsignedlonglongint
            
            returnvalue=[[NSNumber alloc] initWithDouble:([result valueForKey:column]==nil ? 0.0: [[result valueForKey:column] unsignedLongLongValue])];
            
            break;
        case 6: //bool
            
            
            returnvalue = [[NSNumber alloc] initWithBool:[[result valueForKey:column] boolValue]];
            
            break;
        case 7: //string
            returnvalue=[result valueForKey:column]==nil ? @"" : [result valueForKey:column];
            break;
        case 8: //date
            returnvalue=[result valueForKey:column];
            break;
        case 9: //data
            returnvalue=[result valueForKey:column];
            break;
        case 10: //id
            returnvalue=[result objectForKey:column];
            break;
        default:
            break;
    }
    
    return returnvalue ;
}

-(SEL)confirmWithMethodWillbeCalling:(Class)myclass methodName:(NSString *)name{
    unsigned int outcount;
    Method *methods=class_copyMethodList(myclass, &outcount);
    int i;
    for(i=0;i<outcount;i++){
        Method methodx=methods[i];
        SEL mesel=method_getName(methodx);
        NSString *methodinfo=NSStringFromSelector(mesel);
        
        if([name compare:methodinfo options:NSCaseInsensitiveSearch|NSNumericSearch]==NSOrderedSame){
            free(methods);
            return mesel;
        }
    }
    free(methods);
    return nil;
}

-(NSString *) getPropertyType:(objc_property_t )property {
    
    const char *attributes = property_getAttributes(property);
    NSString *typestring=[NSMutableString stringWithCString:attributes encoding:NSUTF8StringEncoding];
    NSArray *typecomponent=[typestring componentsSeparatedByString:@","];
    
    if ([typecomponent count]>0) {
        return (NSString *)[typecomponent objectAtIndex:0];
    }
    return @"";
}

-(NSMutableDictionary *)transformNsObjectToMap:(NSObject *)obj{
#if !__has_feature(objc_arc)
    NSMutableDictionary *dict=[[[NSMutableDictionary alloc] init] autorelease];
#else
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
#endif
    unsigned int outcount;
    int i;
    
    objc_property_t *propertyX=class_copyPropertyList([obj class], &outcount);//获得属性列表
    for (i=0; i<outcount; i++) {
        objc_property_t  currentproperty=propertyX[i];
        const char* propertyname=property_getName(currentproperty);
#if !__has_feature(objc_arc)
        NSString *objcname=[[[NSString alloc] initWithCString:propertyname encoding:NSUTF8StringEncoding] autorelease];
#else
        NSString *objcname=[[NSString alloc] initWithCString:propertyname encoding:NSUTF8StringEncoding];
#endif
//        NSString *methodlowercase=objcname;
//        SEL method=NSSelectorFromString(methodlowercase);
        // id value=objc_msgSend(obj,method);
        id value =nil;
        
        [dict setValue:value==nil ? @"" :value forKey:objcname ];
        
    }
    
    return dict;
}


-(Class)getClassByName:(NSString *)classname{
    
    Class defineclass=NSClassFromString(classname);
    
    return defineclass;
}

-(void)InvokenFunctionByName:(SEL)sel instance:(id)instance andSingleParam:(NSObject *)param {
    
    NSMethodSignature   *singlenature = [instance methodSignatureForSelector:sel];
    
    NSInvocation   *invocation = [NSInvocation invocationWithMethodSignature:singlenature];
    
    [invocation setTarget:instance];
    
    [invocation setSelector:sel];
    
    [invocation setArgument:&param atIndex:2];
    
    [invocation invoke];
    
    
}
@end
