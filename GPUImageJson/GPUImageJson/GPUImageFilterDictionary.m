//
//  GPUImageFilter+CreateFromJson.m
//  SampleGPUImage
//
//  Created by sakiyamaK on 2017/02/18.
//  Copyright © 2017年 VELL. All rights reserved.
//

#import "GPUImageFilterDictionary.h"
#import "NSObject+instanceFromDictionary.h"

@interface GPUImageFilterDictionary()
@property (nonatomic, strong)NSMutableDictionary *picturesPool;
@end

@implementation GPUImageFilterDictionary

-(instancetype)initWithJsonFilePath:(NSString*)jsonFilePath{
  if(!(self=super.init))return nil;

  _picturesPool = @{}.mutableCopy;
  
  NSDictionary *jsonDic = [self jsonToDictionaryWithPath:jsonFilePath];
  
  self.version = jsonDic[@"ver"];
  self.key = jsonDic[@"key"];
  self.type = jsonDic[@"type"];
  
  if([self.type isEqualToString:@"GPUImagePicture"]){
    GPUImagePicture *p = (GPUImagePicture *)[self createGPUImageOutput:jsonDic];
    self.gpuImage = (GPUImageOutput*)p;
  }
  else if([self.type isEqualToString:@"GPUImageFilterGroup"]){
    GPUImageFilterGroup *g = (GPUImageFilterGroup *)[self createFilterGroup:jsonDic];
    self.gpuImage = (GPUImageOutput*)g;
  }
  else{
    GPUImageFilter *f = (GPUImageFilter *)[self createGPUImageOutput:jsonDic];
    self.gpuImage = (GPUImageOutput*)f;
  }
  
  return self;
}

- (GPUImageFilterGroup*)createFilterGroup:(NSDictionary*)filterDics{
  
  GPUImageFilterGroup *g = GPUImageFilterGroup.new;
  
  NSAssert(_picturesPool != nil, @"_picturesPool is not nil");
  
  NSMutableDictionary *filters = @{}.mutableCopy;
  
  //filterの生成
  for(NSDictionary* filterDic in filterDics[@"create"]){
    NSString *key = filterDic[@"key"];
    NSString *type = filterDic[@"type"];
    if([type isEqualToString:@"GPUImagePicture"]){
      GPUImagePicture *p = (GPUImagePicture*)[self createGPUImageOutput:filterDic];
      _picturesPool[key] = p;
      filters[key] = p;
    }
    else{
      GPUImageFilter *f = (GPUImageFilter*)[self createGPUImageOutput:filterDic];
      filters[key] = f;
    }
  }
  
  //add_target
  for(NSDictionary* t in filterDics[@"add_targets"]){
    GPUImageOutput *output = filters[t[@"from"]];
    GPUImageFilter *filter = filters[t[@"to"]];
    NSNumber *location = t[@"location"];
    if(location)[output addTarget:filter atTextureLocation:location.intValue];
    else [output addTarget:filter];
    if([output isKindOfClass:GPUImagePicture.class]){
      GPUImagePicture *p = (GPUImagePicture*)output;
      [p processImage];
    }
  }
  
  //initial
  NSMutableArray *initialFilters = @[].mutableCopy;
  for(id key in filterDics[@"initialFilters"]){
    [initialFilters addObject:filters[key]];
  }
  
  //terminal
  id key = filterDics[@"terminalFilter"];
  id terminalFilter = filters[key];
  
  
  g.initialFilters = initialFilters;
  g.terminalFilter = terminalFilter;
  
  return g;
}

- (GPUImageOutput*)createGPUImageOutput:(NSDictionary*)filterDic{
  Class class = NSClassFromString(filterDic[@"type"]);
  id instance = [[class alloc] instanceFromDictionary:filterDic];
  
  if(filterDic[@"property_list"]){
    for(NSDictionary *propertyDic in filterDic[@"property_list"]){
      NSString *property = propertyDic[@"property"];
      id value = propertyDic[@"value"];
      [instance setValue:value forKey:property];
    }
  }
  
  if(filterDic[@"method_list"]){
    for(NSDictionary *methodDic in filterDic[@"method_list"]){
      if([instance isInitMethod:methodDic])continue;
      [instance methodFromDictionary:methodDic];
    }
  }
  return (GPUImageOutput*)instance;
}


#pragma mark - support method
- (NSDictionary*)jsonToDictionaryWithPath:(NSString*)fileName {
  NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
  if (!path || !path.length) return @{};
  NSError *error;
  NSString *str = [NSString stringWithContentsOfFile:path usedEncoding:NULL error:&error];
  if (error) {
    NSLog(@"%@ - %@", path, error.localizedDescription);
    return @{};
  }
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
  if (error) {
    NSLog(@"%@ - %@", path, error.localizedDescription);
    return @{};
  }
  return json;
}


@end
