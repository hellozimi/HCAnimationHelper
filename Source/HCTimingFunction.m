//
//  HCTimingFunction.m
//  HCAnimatorExample
//
//  Created by Simon Andersson on 12/19/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "HCTimingFunction.h"

@implementation HCTimingFunction

float HCTimingFunctionLinear(float time, float begin, float change, float duration) {
    return change * time / duration + begin;
}

@end

// -c *(t/=d)*(t-2) + b;

// -end * t * (t - 2.f) -1.f;