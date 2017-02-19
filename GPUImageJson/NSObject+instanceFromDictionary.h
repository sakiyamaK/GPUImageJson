//
//  NSObject+BuildInvocation.h
//  SampleGPUImage
//
//  Created by sakiyamaK on 2017/02/18.
//  Copyright © 2017年 VELL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (instanceFromDictionary)
- (instancetype)instanceFromDictionary:(NSDictionary*)paramDic;
- (void)methodFromDictionary:(NSDictionary*)paramDic;
-(BOOL)isInitMethod:(NSDictionary*)methodDic;
@end
