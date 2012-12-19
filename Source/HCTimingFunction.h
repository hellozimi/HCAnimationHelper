//
//  HCTimingFunction.h
//  HCAnimatorExample
//
//  Created by Simon Andersson on 12/19/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCTimingFunction : NSObject

float HCTimingFunctionLinear(float time, float begin, float change, float duration);

@end
