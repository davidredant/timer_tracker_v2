//
//  TimerStage.m
//  TimeTracker
//
//  Created by david on 28/10/2014.
//  Copyright (c) 2014 david. All rights reserved.
//

#import "TimerStage.h"

@implementation TimerStage

-(id)initWithStageName:(NSString *)stageName withLap:(NSInteger)lap withLength:(NSInteger)length{
    if (self=[super init]) {
        _stageName=[stageName copy];
        _lap=lap;
        _length=length;
    }
    return self;
}

@end
