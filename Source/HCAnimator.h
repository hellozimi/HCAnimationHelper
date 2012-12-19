//
//  HCAnimator.h
//  HCAnimatorExample
//
//  Created by Simon Andersson on 12/18/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCTimingFunction.h"

typedef void(^HCAnimatorUpdateBlock)(float progress);
typedef void(^HCAnimatorCompleteBlock)();
typedef float(*HCAnimatorTimingFunction)(float time, float begin, float change, float duration);

@interface HCAnimatorTiming : NSObject
@property (nonatomic, assign) float duration;
@property (nonatomic, assign) float delay;
@property (nonatomic, assign) float startOffset;
@property (nonatomic, assign) float value;

+ (HCAnimatorTiming *)timing;
@end

@interface HCAnimatorOperation : NSObject
@property (nonatomic, strong) HCAnimatorTiming *timing;
@property (nonatomic, copy) HCAnimatorUpdateBlock updateBlock;
@property (nonatomic, copy) HCAnimatorCompleteBlock completeBlock;
@property (nonatomic, assign) HCAnimatorTimingFunction timingFunction;

+ (HCAnimatorOperation *)operation;
@end


@interface HCAnimator : NSObject

@property (nonatomic, readonly) float offset;

+ (void)periodWithDuration:(float)duration updateBlock:(HCAnimatorUpdateBlock)updateBlock;
+ (void)periodWithDuration:(float)duration updateBlock:(HCAnimatorUpdateBlock)updateBlock completeBlock:(HCAnimatorCompleteBlock)completeBlock;

+ (void)periodWithDuration:(float)duration delay:(float)delay updateBlock:(HCAnimatorUpdateBlock)updateBlock completeBlock:(HCAnimatorCompleteBlock)completeBlock;
+ (void)periodWithDuration:(float)duration delay:(float)delay timingFunction:(HCAnimatorTimingFunction)timingFunction updateBlock:(HCAnimatorUpdateBlock)updateBlock completeBlock:(HCAnimatorCompleteBlock)completeBlock;


+ (HCAnimator *)sharedAnimator;
- (void)addOperation:(HCAnimatorOperation *)opertaion;

@end
