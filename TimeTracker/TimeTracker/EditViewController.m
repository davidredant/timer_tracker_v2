//
//  EditViewController.m
//  TimeTracker
//
//  Created by david on 22/10/2014.
//  Copyright (c) 2014 david. All rights reserved.
//

#import "EditViewController.h"
#import "WorkOutModel.h"
#import "WorkoutList.h"
#import "AppDelegate.h"

@interface EditViewController ()
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *txtField;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,assign) NSInteger  tagOfEditingTextField;
@property (nonatomic,strong) NSMutableDictionary *tempValues;

@end

@implementation EditViewController
-(IBAction)Cancel:(id)sender{
      [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //load datepicker for text2 and textfield 3
   
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(Cancel:)];
    self.navigationItem.leftBarButtonItem=cancelButton;
   
    UIBarButtonItem *saveButton=[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem=saveButton;

    _datePicker=[[UIDatePicker alloc] init];
    [_datePicker setDatePickerMode:UIDatePickerModeCountDownTimer];
    _datePicker.backgroundColor=[UIColor grayColor];
    NSInteger i=0;
    for (UITextField *txtFeild in _txtField) {
        if (i==0) {
            txtFeild.tag=kWorkoutNameIndex;
        }
        if (i==1) {
            txtFeild.tag=kWorkoutInterval;
        }
        if (i==2) {
            txtFeild.tag=kRestLength;
        }
        if (i==3) {
            txtFeild.tag=kNumberOfIntervals;
        }
        txtFeild.delegate=self;
        if (i==1|| i==2) {
            [self LoadDatePicker:txtFeild];
        }
        i++;
    }
    
    //initialise the tempvalues dictionary to save temporily the text field values
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc] init];
    self.tempValues=dictionary;
    
    //load data if mode is edit
    WorkOutModel *objWorkout=[self objWorkout];
    if (objWorkout) {
        i=0;
        for (UITextField *txtFeild in _txtField) {
            if (i==0) {
                txtFeild.text=objWorkout.workoutName;
                


            }
            if (i==1) {
                txtFeild.text=[self ConvertIntToDateTime: objWorkout.workoutInterval];
                
            }
            if (i==2) {
                txtFeild.text=[self ConvertIntToDateTime: objWorkout.restLength];
                
            }
            if (i==3) {
                txtFeild.text=[NSString stringWithFormat:@"%d",objWorkout.numberOfIntervals];
               
              
            }
            
            NSNumber *tagNum=[[NSNumber alloc] initWithInt:txtFeild.tag];
            [_tempValues setObject:txtFeild.text forKey:tagNum];
            i++;
        }

    }
    
    
   
    
    
}





-(IBAction)save:(id)sender{
    UITextField *lastTextField=(UITextField *)[self.view viewWithTag:_tagOfEditingTextField];
    [lastTextField resignFirstResponder];
    NSString *message=[self IsValidated];
    if ([message length]>0) {
        NSString *m=[NSString stringWithFormat:@"%@ could not be empty",message];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:m delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        
        
        [alert show];
        return;
    }else
    {
        
        NSString *workoutName=@"";
        NSInteger workoutInterval=0;
        NSInteger RestLength=0;
        NSInteger numberOfIntervals=0;
        
        for (NSNumber *key in [_tempValues allKeys]) {
            switch ([key intValue]) {
                    
                case kWorkoutNameIndex:
                    workoutName=[_tempValues objectForKey:key];
                    break;
                case kWorkoutInterval:
                    
                    workoutInterval=[self ConvertTimerToInt:[_tempValues objectForKey:key]];
                    break;
                case kRestLength:
                    RestLength=[self ConvertTimerToInt:[_tempValues objectForKey:key]];
                    break;
                case kNumberOfIntervals:
                    numberOfIntervals=[[_tempValues objectForKey:key] integerValue];
                    break;
            }
        }
        
        WorkOutModel *workoutModel=[[WorkOutModel alloc]initWithWorkoutName:workoutName workoutInterval:workoutInterval restLength:RestLength numberOfInterval:numberOfIntervals];
        
        WorkoutList *workoutList=[[WorkoutList alloc] init];
        if ([self objWorkout]) {
            [workoutList updateWorkout:workoutModel];
        }
        else
        {
            [workoutList addWorkout:workoutModel];
        }
        
        workoutModel=nil;
        
       
        //nav back to previous main form
        [self.navigationController popViewControllerAnimated:YES];
       // UITableViewController *parent=[self.navigationController.viewControllers lastObject];
        
        
        
       // [parent.tableView reloadData];
        
       
    }
    
    
    
}



-(NSNumber *)ConvertIntToNumber:(int)val{
    return [[NSNumber alloc] initWithInt:val];
}

-(NSString *)IsValidated{
    NSNumber *key;
    key=[[NSNumber alloc] initWithInt:kWorkoutNameIndex];
    if([_tempValues objectForKey:key]==nil)
        return @"Workout Name";
    key=[[NSNumber alloc] initWithInt:kWorkoutInterval];
    if([_tempValues objectForKey:key]==nil)
        return @"Workout Interval";
    
    key=[[NSNumber alloc] initWithInt:kRestLength];
    if([_tempValues objectForKey:key]==nil)
        return @"Rest Duration";
    key=[[NSNumber alloc] initWithInt:kNumberOfIntervals];
    if([_tempValues objectForKey:key]==nil)
        return @"Number of Intervals";
    return @"";
    
}

-(NSInteger)ConvertTimerToInt:(NSString *)timerInString{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=@"HH:mm:ss";
    NSDate *timeDate=[formatter dateFromString:timerInString];
    formatter.dateFormat=@"HH";
    NSInteger hour=[[formatter stringFromDate:timeDate] intValue];
    formatter.dateFormat=@"mm";
    NSInteger minute=[[formatter stringFromDate:timeDate] intValue];
    formatter.dateFormat=@"ss";
    NSInteger second=[[formatter stringFromDate:timeDate] intValue];
    second +=hour*3600+minute*60;
    return second;
}


-(NSString *)ConvertIntToDateTime :(NSInteger)inputSeconds{
    NSString *formatterDate=@"00:00:00";
    NSUInteger hours,minutes,seconds;
    hours=inputSeconds/3600;
    minutes=(inputSeconds%3600)/60;
    seconds=(inputSeconds%3600)%60;
    formatterDate=[NSString stringWithFormat:@"%02d:%02d:%02d", hours,minutes,seconds];
    return formatterDate;
}


-(void)LoadDatePicker:(id)sender{
    UITextField *txtField=nil;
    txtField=(UITextField *)sender;
    _datePicker=[[UIDatePicker alloc] init];
    
    [_datePicker setDatePickerMode:UIDatePickerModeCountDownTimer];
    _datePicker.backgroundColor=[UIColor grayColor];
    
    [_datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDoubleTapped:)];
    tapGR.numberOfTapsRequired=1;
    [_datePicker addGestureRecognizer:tapGR];
    
    [txtField setInputView:_datePicker];

}

-(void)updateTextField:(id)sender{
    
    UITextField *atxtField=nil;
    atxtField=(UITextField *)[self.view viewWithTag:_tagOfEditingTextField];
    UIDatePicker *picker=(UIDatePicker *)sender;
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
     [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:picker.date]];
    
}

-(void)viewDoubleTapped:(UITapGestureRecognizer *)tapGR{
    
    UITextField *txtField=nil;
    txtField=(UITextField *)[self.view viewWithTag:_tagOfEditingTextField];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    UIDatePicker *picker=(UIDatePicker *)tapGR.view;
    
    
    NSString *curDate=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:picker.date]];
    if([curDate isEqualToString:@"00:00:00"])
    {
        curDate=@"00:01:00";
    }
    txtField.text=curDate;
    [txtField resignFirstResponder];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _tagOfEditingTextField=  textField.tag;
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSString *val=@"99";
    if ([textField.text isEqualToString:@"∞"]) {
        val=@"99";
    }
    else
        val=textField.text;
    NSNumber *tagNum=[[NSNumber alloc] initWithInt:textField.tag];
    [_tempValues setObject:val forKey:tagNum];
    
    [self textFieldDone:self];
    
    
}

-(void)textFieldDone:(id)sender
{
    [sender resignFirstResponder];
}



@end
