//
//  SoundViewController.m
//  TimeTracker
//
//  Created by david on 29/10/2014.
//  Copyright (c) 2014 david. All rights reserved.
//

#import "SoundViewController.h"
#import "SoundListViewController.h"

@interface SoundViewController ()
@property (strong, nonatomic) IBOutlet UIButton *btnBeeps;
@property (strong, nonatomic) IBOutlet UIButton *btnSound;

@end

@implementation SoundViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [_btnBeeps addTarget:self action:@selector(addSegueToButton) forControlEvents:UIControlEventTouchUpInside];
    [_btnSound addTarget:self action:@selector(addSegueToButton) forControlEvents:UIControlEventTouchUpInside];
}


-(void)addSegueToButton{
    [self performSegueWithIdentifier:@"beep" sender:self];
    [self performSegueWithIdentifier:@"sound" sender:self];

}

-(IBAction)buttonPickBeep:(id)sender{
    
    

    
}

-(IBAction)buttonPickupSound:(id)sender{
    }


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController navigationItem].title=@"ok";
    
    
        
    
}


@end
