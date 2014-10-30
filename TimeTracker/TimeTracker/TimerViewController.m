//
//  TimerViewController.m
//  TimeTracker
//
//  Created by david on 28/10/2014.
//  Copyright (c) 2014 david. All rights reserved.
//

#import "TimerViewController.h"
#import "WorkOutModel.h"
#import "TimerStage.h"


@interface TimerViewController ()

@property(nonatomic,assign) SystemSoundID sysSoundID;
@end

NSUInteger hours,minutes,seconds;
NSUInteger secondremains;
NSUInteger counts=4;

NSUInteger RecordCount=1;
NSString *StageName;

NSURL *sound_url_ping=nil;
NSURL *sound_url_glass=nil;
NSMutableArray *lstStages;
NSMutableArray *original_lstStages;

@implementation TimerViewController

#pragma -
#pragma mark application save resign
/* variables for application resign and reactivate*/
NSString *kSavedStages=@"KeyStages";


-(void)savePlayStatus{
    [[NSUserDefaults standardUserDefaults] setObject:lstStages forKey:kSavedStages];
}

-(void)loadPlayStatus{
    lstStages =[[NSUserDefaults standardUserDefaults] objectForKey:kSavedStages];
}

//\[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PausePlay:) name:UIApplicationWillResignAcitveNotification object:nil];


#pragma -
#pragma make Timer functions
-(void)UpdateingCount:(NSTimer *)theTimer{
    if (counts>1) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)sound_url_ping,&_sysSoundID);
        AudioServicesPlaySystemSound(self.sysSoundID);
        
        counts--;
        
    }else if(counts==1){
        
        
        AudioServicesRemoveSystemSoundCompletion(self.sysSoundID);
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)sound_url_glass,&_sysSoundID);
        AudioServicesPlaySystemSound(self.sysSoundID);
        AudioServicesRemoveSystemSoundCompletion(self.sysSoundID);
        counts--;
        
    }else
    {
        
        if (secondremains>0) {
            secondremains--;
            [self PrintLablelWithTimeFormat:secondremains];
            
            
            if (secondremains<=6) {
                [self MakeAlert:secondremains];
                if (secondremains<=0) {
                    [self SWitchStage];
                }
                
            }
            
        }
    }
    
    if (counts>0) {
        _countdownLabel.text=[NSString stringWithFormat:@"%d",counts];
    }
    else{
        //  [self SWitchStage];
        _countdownLabel.text=[self PrintLablelWithTimeFormat:secondremains];    }
    
}

-(void)countdownTimer{
    
    timer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(UpdateingCount:) userInfo:nil repeats:YES];
    
    
}

-(IBAction)StartTimer:(id)sender{
    
    UIButton *button=sender;
    NSString *currentButton=[sender currentTitle];
    if ([currentButton isEqualToString:@"Start"]) {
        [button setTitle:@"Stop" forState:UIControlStateNormal];
        
        if (timer==nil) {
            
            [self countdownTimer];
            
            
        }
    }
    else
    {
        [self PauseTimer:sender];
        
    }
    
}

-(IBAction)PauseTimer:(id)sender{
    UIButton *button=sender;
    NSString *currentButton=[sender currentTitle];
    if ([currentButton isEqualToString:@"Stop"]) {
        [button setTitle:@"Start" forState:UIControlStateNormal];
    }
    
    if (timer!=nil) {
        [timer invalidate];
        timer=nil;
    }
}

-(IBAction)StopTimer:(id)sender{
    secondremains=0;
    
    _countdownLabel.text=[NSString stringWithFormat:@"%02d:%02d:%02d", 0,0,0];
    if (timer!=nil) {
        [timer invalidate];
        timer=nil;
    }
}

-(void)MakeAlert:(NSUInteger)seconds{
    if (seconds>=6)  return;
    
    if (seconds>=1) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)sound_url_ping,&_sysSoundID);
        AudioServicesPlaySystemSound(self.sysSoundID);
        
        
    }else if(seconds<1){
        
        
        AudioServicesRemoveSystemSoundCompletion(self.sysSoundID);
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)sound_url_glass,&_sysSoundID);
        AudioServicesPlaySystemSound(self.sysSoundID);
        AudioServicesRemoveSystemSoundCompletion(self.sysSoundID);
        
    }
}

-(IBAction)Reset:(id)sender
{
    if (timer!=nil) {
        [timer invalidate];
        timer=nil;
    }
    
    lstStages=[NSMutableArray arrayWithArray:original_lstStages];
    [_tableStages reloadData];
    
    TimerStage *astage=[lstStages objectAtIndex:0];
    secondremains=astage.length;
    
    _stageLabel.text=[NSString stringWithFormat:@"Lap %d %@",astage.lap,astage.stageName];
    _countdownLabel.text=[self PrintLablelWithTimeFormat:secondremains];
    counts=4;
    
    
    
}


-(void)SWitchStage{
    
    if ([lstStages count]>1) {
        [lstStages removeObjectAtIndex:0] ;
        [_tableStages reloadData];
        TimerStage *astage=[lstStages objectAtIndex:0];
        
        secondremains=astage.length;
        
        _stageLabel.text=[NSString stringWithFormat:@"Lap %d %@",astage.lap,astage.stageName];
        
        astage=nil;
        
    }
    else
    {
        
        if (timer!=nil) {
            [timer invalidate];
            timer=nil;
            _stageLabel.text=@"WELL DONE";
            lstStages=nil;
            [_tableStages reloadData];
        }
        
        
    }
    
    
    
    
    
    
}

-(void)LoadStags:(WorkOutModel *)workout{
    
    if (workout.numberOfIntervals==0) {
        workout.numberOfIntervals=maxPlayLap;
    }
    lstStages=[[NSMutableArray alloc] initWithCapacity:workout.numberOfIntervals*2];
    
    NSUInteger lengthforInteval=workout.workoutInterval;
    NSUInteger lengthforRest=workout.restLength;
    NSUInteger loops=workout.numberOfIntervals;
    
    workout=nil;
    
    for (NSUInteger i=1; i<=loops; i++) {
        TimerStage *stage1=[[TimerStage alloc]init];
        stage1.lap=i;
        stage1.stageName=@"Interval";
        stage1.length=lengthforInteval;
        [lstStages addObject:stage1];
        
        
        TimerStage *stage2=[[TimerStage alloc]init];
        
        stage2.lap=i;
        stage2.stageName=@"Rest";
        stage2.length=lengthforRest;
        [lstStages addObject:stage2];
        stage1=nil;
        stage2=nil;
        
        
        
    }
    
    original_lstStages=[NSMutableArray arrayWithArray:lstStages];
    
    
    
}

-(NSString *)PrintLablelWithTimeFormat:(NSUInteger)isecondremains{
    hours=isecondremains/3600;
    minutes=(isecondremains%3600)/60;
    seconds=(isecondremains%3600)%60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours,minutes,seconds];
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    sound_url_ping=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Ping" ofType:@"aiff"]];
    sound_url_glass=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Glass" ofType:@"aiff"]];
    
    
    //WorkOutModel *objWorkout=[self objWorkout];
    
    
    secondremains=_objWorkout.workoutInterval;
    _countdownLabel.text=[self PrintLablelWithTimeFormat:secondremains];
    
    
    StageName=kWorkInterval;
    _stageLabel.text=[NSString stringWithFormat:@"Lap %d %@",1,StageName];
    [self LoadStags:_objWorkout];
    
    
    _tableStages.dataSource=self;
    _tableStages.delegate=self;
    [self.view addSubview:self.tableStages];
    
    
  

}


#pragma -
#pragma make table delegate and datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return lstStages.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TimerStageControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    TimerStage *stage=[lstStages objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"Lap %d %@ %@",stage.lap,stage.stageName,[self PrintLablelWithTimeFormat:stage.length]];
    stage=nil;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2!=0) {
        UIColor *alterColor=[UIColor colorWithWhite:0.8 alpha:0.1];
        cell.backgroundColor=alterColor;
    }
}

-(void)viewDidAppear:(BOOL)animated{
}



@end
