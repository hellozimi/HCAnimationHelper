//
//  ViewController.m
//  HCAnimatorExample
//
//  Created by Simon Andersson on 12/18/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "ViewController.h"
#import "HCAnimator.h"

@interface ViewController ()

@end

@implementation ViewController

float abc(float t, float b, float c, float d) {
    if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
    return c/2*((t-=2)*t*t*t*t + 2) + b;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    v.backgroundColor = [UIColor redColor];
    
    [HCAnimator periodWithDuration:1.3 delay:1.0 timingFunction:abc updateBlock:^(float progress) {
        float left = (320 - 25) * progress;
        
        CGRect rect = v.frame;
        rect.origin.x = left;
        
        v.frame = rect;
    } completeBlock:^{
        NSLog(@"Complete");
    }];
    
    [self.view addSubview:v];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
