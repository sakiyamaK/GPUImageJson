//
//  GPUImageFilter+CreateFromJson.h
//  SampleGPUImage
//
//  Created by sakiyamaK on 2017/02/18.
//  Copyright © 2017年 VELL. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@interface GPUImageFilterDictionary : NSObject
@property(nonatomic, strong)NSString *version;
@property(nonatomic, strong)NSString *key;
@property(nonatomic, strong)NSString *type;
@property(nonatomic, strong)GPUImageOutput *gpuImage;
-(instancetype)initWithJsonFilePath:(NSString*)jsonFilePath;
@end
