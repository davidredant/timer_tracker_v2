//
//  TimerStage.h
//  TimeTracker
//
//  Created by david on 28/10/2014.
//  Copyright (c) 2014 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerStage : NSObject

@property(nonatomic, copy)NSString *stageName;
@property(nonatomic, assign)NSInteger lap;
@property (nonatomic, assign)NSInteger length;

-(id)initWithStageName:(NSString *)stageName withLap:(NSInteger)lap withLength:(NSInteger)length;
@end
