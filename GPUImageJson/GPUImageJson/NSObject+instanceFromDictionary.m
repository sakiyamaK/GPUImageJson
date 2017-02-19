//
//  NSObject+BuildInvocation.m
//  SampleGPUImage
//
//  Created by sakiyamaK on 2017/02/18.
//  Copyright © 2017年 VELL. All rights reserved.
//

#import "NSObject+instanceFromDictionary.h"
#import "NSArray+Geometry.h"

@implementation NSObject (instanceFromDictionary)


- (instancetype)instanceFromDictionary:(NSDictionary*)paramDic{
  NSDictionary *initMethodDic = [self getInitMethodDic:paramDic];

  if(!initMethodDic) return self.init;
  
  bool isClassMethod = [self isClassMethod:initMethodDic];
  
  NSMutableArray *paramList = @[].mutableCopy;
  for (NSDictionary *subParamDic in initMethodDic[@"param_list"]) {
    id value = nil;
    id type = subParamDic[@"type"];
    if([self isPrimitiveType:type] || [type isEqualToString:@"NSString"] || [type isEqualToString:@"instance"]){
      value = subParamDic[@"value"];
    }
    else{
      Class class = NSClassFromString(type);
      value = [[class alloc] instanceFromDictionary:subParamDic];
      type = @"instance";
    }
    [paramList addObject:@{@"type":type, @"value":value}];
  }
  NSString *methodName = initMethodDic[@"method_name"];
  return [self instanceWithMethodName:methodName withIsClassMethod:isClassMethod withParamList:paramList];
}

- (instancetype)instanceWithMethodName:(NSString*)methodName
                     withIsClassMethod:(BOOL)isClassMethod
                         withParamList:(NSArray*)paramList{
  NSInvocation *invocation = [self invocationWithTarget:isClassMethod ? self.class : self
                                              withClass:self.class
                                             withMethod:methodName
                                      withIsClassMethod:isClassMethod
                                          withParamList:paramList];
  [invocation invoke];
  [invocation getReturnValue:(void*)&self];
  return self;
}

- (void)methodFromDictionary:(NSDictionary*)paramDic{
  
  NSString *methodName = paramDic[@"method_name"];
  BOOL isClassMethod = [self isClassMethod:paramDic];
  NSArray *paramList = paramDic[@"param_list"];

  NSMutableArray *subParamList = @[].mutableCopy;
  for (NSDictionary *paramDic in paramList) {
    id type = paramDic[@"type"];
    id value = nil;
    if([self isPrimitiveType:type] || [type isEqualToString:@"NSString"] || [type isEqualToString:@"instance"]){
      value = paramDic[@"value"];
    }
    else{
      Class class = NSClassFromString(type);
      value = [[class alloc] instanceFromDictionary:paramDic];
      type = @"instance";
    }
    [subParamList addObject:@{@"type":type, @"value":value}];
  }
  [self invocationWithTarget:self withClass:self.class withMethod:methodName withIsClassMethod:isClassMethod withParamList:subParamList];
}

- (NSInvocation*)invocationWithTarget:(id)target withClass:(Class)class withMethod:(NSString*)method withIsClassMethod:(BOOL)isClassMethod withParamList:(NSArray*)paramList{
  
  SEL selector = NSSelectorFromString(method);
  NSMethodSignature *signature = nil;
  if(isClassMethod) signature = [class methodSignatureForSelector:selector];
  else signature = [class instanceMethodSignatureForSelector:selector];
  
  NSString *errorMessage = [NSString stringWithFormat:@"%@ class does not have %@ selector", NSStringFromClass(class), method];
  NSAssert(signature, errorMessage);
  
  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
  [invocation retainArguments];
  invocation.target = target;
  invocation.selector = selector;
  
  for (int i = 0; i < paramList.count; i++) {
    
    NSDictionary *paramDic = paramList[i];
    NSString *type = paramDic[@"type"];
    id value = paramDic[@"value"];
    
    void *arg = (void*)&value;
    
    if([type isEqualToString:@"char"]){
      char v = ((NSNumber*)value).charValue;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"unsigned_char"]){
      unsigned char v = ((NSNumber*)value).unsignedCharValue;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"short"]){
      short v = ((NSNumber*)value).shortValue;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"unsigned_short"]){
      unsigned short v = ((NSNumber*)value).shortValue;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"int"]){
      int v = ((NSNumber*)value).intValue;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"unsigned_int"]){
      unsigned int v = ((NSNumber*)value).unsignedIntValue;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"long"]){
      long v = ((NSNumber*)value).longValue;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"unsigned_long"]){
      unsigned long v = ((NSNumber*)value).longValue;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"long_long"]){
      long long v = ((NSNumber*)value).longLongValue;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"unsigned_long_long"]){
      unsigned long long v = ((NSNumber*)value).unsignedLongLongValue;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"float"]){
      float v = ((NSNumber*)value).floatValue;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"double"]){
      double v = ((NSNumber*)value).doubleValue;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"bool"]){
      bool v = ((NSNumber*)value).boolValue;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"NSInteger"]){
      NSInteger v = ((NSNumber*)value).integerValue;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"NSUInteger"]){
      NSUInteger v = ((NSNumber*)value).unsignedIntegerValue;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"CGPoint"]){
      CGPoint v = ((NSArray*)value).CGPoint;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"CGVector"]){
      CGVector v = ((NSArray*)value).CGVector;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"CGSize"]){
      CGSize v = ((NSArray*)value).CGSize;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"CGRect"]){
      CGRect v = ((NSArray*)value).CGRect;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"CGAffineTransform"]){
      CGAffineTransform v = ((NSArray*)value).CGAffineTransform;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"UIEdgeInsets"]){
      UIEdgeInsets v = ((NSArray*)value).UIEdgeInsets;
      arg = (void*)&v;
    }
    else if([type isEqualToString:@"UIEdgeInsets"]){
      UIOffset v = ((NSArray*)value).UIOffset;
      arg = (void*)&v;
    }
    
    [invocation setArgument:arg atIndex:i+2];
  }
  return invocation;
}

//- (NSInvocation*)invocationWithSelector:(SEL)selector args:(void *)arg1, ...{
//  va_list params;
//  va_start(params, arg1);
//
//  void *arg = arg1;
//
//  NSMethodSignature *signature = [self methodSignatureForSelector:selector];
//  NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
//  [invocation retainArguments];
//  invocation.target = self;
//  invocation.selector = selector;
//
//  for (int i = 2; arg != nil; i++) {
//    [invocation setArgument:arg atIndex:i];
//    arg = va_arg(params, void*);
//  }
//  va_end(params);
//  return invocation;
//}


-(BOOL)isPrimitiveType:(NSString*)type{
  NSArray *noTypeList = @[@"int", @"long", @"float", @"double", @"CGRect", @"CGPoint", @"CGSize"];
  for(NSString *noType in noTypeList) if([type isEqualToString:noType]) return YES;
  return NO;
}

-(BOOL)isClassMethod:(NSDictionary*)methodDic{
  for(NSString *methodType in methodDic[@"method_type_list"]){
    if(methodType &&[methodType rangeOfString:@"class"].location != NSNotFound){
        return YES;
    }
  }
  return NO;
}

-(BOOL)isInitMethod:(NSDictionary*)methodDic{
  for(NSString *methodType in methodDic[@"method_type_list"]){
    if(methodType &&[methodType rangeOfString:@"init"].location != NSNotFound){
      return YES;
    }
  }
  return NO;
}


-(NSDictionary*)getInitMethodDic:(NSDictionary*)argrDic{
  for(NSDictionary *methodDic in argrDic[@"method_list"]){
    if([self isInitMethod:methodDic]) return methodDic;
  }
  return nil;
}


@end
