//
//  NSArray+CGGeometry.m
//  SampleGPUImage
//
//  Created by sakiyamaK on 2017/02/19.
//  Copyright © 2017年 VELL. All rights reserved.
//

#import "NSArray+Geometry.h"

@implementation NSArray (Geometry)

-(CGPoint)CGPoint{
  CGFloat x = self[0] ? ((NSNumber*)self[0]).floatValue : 0;
  CGFloat y = self[1] ? ((NSNumber*)self[1]).floatValue : 0;
  return (CGPoint){x,y};
}

-(CGVector)CGVector{
  CGFloat x = self[0] ? ((NSNumber*)self[0]).floatValue : 0;
  CGFloat y = self[1] ? ((NSNumber*)self[1]).floatValue : 0;
  return (CGVector){x,y};
}


-(CGSize)CGSize{
  CGFloat w = self[0] ? ((NSNumber*)self[0]).floatValue : 0;
  CGFloat h = self[1] ? ((NSNumber*)self[1]).floatValue : 0;
  return (CGSize){w,h};
}

-(CGRect)CGRect{
  CGFloat x = self[0] ? ((NSNumber*)self[0]).floatValue : 0;
  CGFloat y = self[1] ? ((NSNumber*)self[1]).floatValue : 0;
  CGFloat w = self[2] ? ((NSNumber*)self[2]).floatValue : 0;
  CGFloat h = self[3] ? ((NSNumber*)self[3]).floatValue : 0;
  return (CGRect){x, y , w, h};
}

-(CGAffineTransform)CGAffineTransform{
  CGFloat a = self[0] ? ((NSNumber*)self[0]).floatValue : 0;
  CGFloat b = self[1] ? ((NSNumber*)self[1]).floatValue : 0;
  CGFloat c = self[2] ? ((NSNumber*)self[2]).floatValue : 0;
  CGFloat d = self[3] ? ((NSNumber*)self[3]).floatValue : 0;
  CGFloat dx = self[4] ? ((NSNumber*)self[4]).floatValue : 0;
  CGFloat dy = self[5] ? ((NSNumber*)self[5]).floatValue : 0;
  return (CGAffineTransform){a, b, c, d, dx, dy};

}

-(UIEdgeInsets)UIEdgeInsets{
  CGFloat top = self[0] ? ((NSNumber*)self[0]).floatValue : 0;
  CGFloat left = self[1] ? ((NSNumber*)self[1]).floatValue : 0;
  CGFloat bottom = self[2] ? ((NSNumber*)self[2]).floatValue : 0;
  CGFloat right = self[3] ? ((NSNumber*)self[3]).floatValue : 0;
  return (UIEdgeInsets){top, left, bottom, right};
}

-(UIOffset)UIOffset{
  CGFloat horizontal = self[0] ? ((NSNumber*)self[0]).floatValue : 0;
  CGFloat vertical = self[1] ? ((NSNumber*)self[1]).floatValue : 0;
  return (UIOffset){horizontal, vertical};
}

@end
