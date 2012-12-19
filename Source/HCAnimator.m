//
//  HCAnimator.m
//  HCAnimatorExample
//
//  Created by Simon Andersson on 12/18/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "HCAnimator.h"

#define kHCAnimatorFramerate 1.0/60

@interface HCAnimator () {
    NSMutableArray *_operations;
    NSMutableArray *_expiredOperations;
    NSTimer *_timer;
}

@end

@implementation HCAnimatorTiming

+ (HCAnimatorTiming *)timing {
    return [[self alloc] init];
}

@end

@implementation HCAnimatorOperation

+ (HCAnimatorOperation *)operation {
    return [[self alloc] init];
}

@end

@implementation HCAnimator

static HCAnimator *INSTANCE = nil;


+ (void)periodWithDuration:(float)duration updateBlock:(HCAnimatorUpdateBlock)updateBlock {
    [HCAnimator periodWithDuration:duration updateBlock:updateBlock completeBlock:nil];
}

+ (void)periodWithDuration:(float)duration updateBlock:(HCAnimatorUpdateBlock)updateBlock completeBlock:(HCAnimatorCompleteBlock)completeBlock {
    [HCAnimator periodWithDuration:duration delay:0 updateBlock:updateBlock completeBlock:completeBlock];
}

+ (void)periodWithDuration:(float)duration delay:(float)delay updateBlock:(HCAnimatorUpdateBlock)updateBlock completeBlock:(HCAnimatorCompleteBlock)completeBlock {
    [HCAnimator periodWithDuration:duration delay:delay timingFunction:nil updateBlock:updateBlock completeBlock:completeBlock];
}

+ (void)periodWithDuration:(float)duration delay:(float)delay timingFunction:(HCAnimatorTimingFunction)timingFunction updateBlock:(HCAnimatorUpdateBlock)updateBlock completeBlock:(HCAnimatorCompleteBlock)completeBlock {
    HCAnimatorOperation *operation = [HCAnimatorOperation operation];
    operation.completeBlock = completeBlock;
    operation.updateBlock = updateBlock;
    operation.timingFunction = timingFunction;
    
    HCAnimatorTiming *timing = [HCAnimatorTiming timing];
    timing.duration = duration;
    timing.delay = delay;
    timing.startOffset = [[HCAnimator sharedAnimator] offset];
    
    operation.timing = timing;
    
    [[HCAnimator sharedAnimator] addOperation:operation];
}

// Singeton
+ (HCAnimator *)sharedAnimator {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        INSTANCE = [[HCAnimator alloc] init];
    });
    return INSTANCE;
}

- (id)init {
    self = [super init];
    if (self) {
        _operations = [[NSMutableArray alloc] init];
        _expiredOperations = [[NSMutableArray alloc] init];
        
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:kHCAnimatorFramerate target:self selector:@selector(update) userInfo:nil repeats:YES];
        }
    }
    return self;
}

- (void)addOperation:(HCAnimatorOperation *)opertaion {
    [_operations addObject:opertaion];
}

- (void)update {
    
    _offset += kHCAnimatorFramerate;
    
    
    for (__strong HCAnimatorOperation *operation in _operations) {
        HCAnimatorTiming *timing = operation.timing;
        
        if (self.offset <= timing.startOffset + timing.delay) {
            continue;
        }
        
        if (!operation.timingFunction) {
            operation.timingFunction = HCTimingFunctionLinear;
        }
        
        
        if (self.offset <= timing.startOffset + timing.delay + timing.duration) {
            timing.value = operation.timingFunction(self.offset - timing.startOffset - timing.delay, 0, 1, timing.duration);
        }
        else {
            timing.value = 1.0;
            [_expiredOperations addObject:operation];
        }
        
        if (operation.updateBlock) {
            operation.updateBlock(timing.value);
        }
    }
    
    for (__strong HCAnimatorOperation *operation in _expiredOperations) {
        if (operation.completeBlock) {
            operation.completeBlock();
        }
        
        [_operations removeObject:operation];
        operation = nil;
    }
    
    [_expiredOperations removeAllObjects];
}

@end
