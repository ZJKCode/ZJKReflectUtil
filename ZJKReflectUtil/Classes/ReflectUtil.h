//
//  ReflectUtil.h
//  ZJKReflectUtil
//
//  Created by zhangjikuan on 2019/11/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReflectUtil : NSObject
{
    
    NSMutableDictionary   *typeind;
}

//in terms of the Class name to build an object instance of the Class name specified
-(id)buildTargetObjectByClassName:(NSString *)classname;
//in terms of the Class name and a single param and constructor to build an object instance of the Class name specified
-(id)buildTargetObjectByClassName:(NSString *)classname andSingleParam:(NSObject *)param andConstructorName:(NSString *)constructor;

//in terms of the Class name and a map parameters and constructor to build a instance of the Class name specified
-(id)buildTargetObjectByClassName:(NSString *)classname andInitParamWithMap:(NSDictionary *)param andConstructorName:(NSString *)constructor;

//in terms of the Class name and a array parameters and constructor to build a instance of the Class name specified
-(id)buildTargetObjectByClassName:(NSString *)classname andInitParamWithArray:(NSArray *)param andConstructorName:(NSString *)constructor;

//in terms of the instance of an object and a array parameters and method to call a method of the instance dynamically.
-(id)dynamicCallingByInstance:(NSObject *)instance andInitParamWithArray:(NSArray *)param andMethodName:(NSString *)method;

-(id)dynamicCallingBySingleton:(NSString *)classname andInitParamWithArray:(NSArray *)param andMethodName:(NSString *)method;

//tranform the nsmutabledictionary object to the object that the classname variable specified
-(id)transformResult:(NSMutableDictionary *)resultset ToObject:(NSString *)classname;
@end

NS_ASSUME_NONNULL_END
