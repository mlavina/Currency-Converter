//
//  ViewController.m
//  CurrencyConverter
//
//  Created by MMstudent on 3/10/14.
//  Copyright (c) 2014 SBU. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    //Initialiez the Dictionary
    _rates = [[NSMutableDictionary alloc] init];
  
    /*
     *this is all to get rid of the keyboard when the UIPicker is clicked
     *because the UIPicker is too big
     */
    self.input.delegate = self;
    _hiddenButtonToHideKeyboard.hidden=YES;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //Get the data for the currency converter from the following url
    NSURL *url = [[NSURL alloc]initWithString:@"https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"];
    self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    self.parser.delegate = self;
    [_parser parse];
 
    //Since the file I am using converts everything into Eur rates this needs to be manually added
    [_rates setObject:@"1.0" forKey:@"EUR"];
    _currencies = [[_rates allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];

}
/*
 *Methods for parsing
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    //NSLog(@"Attributes: %@", attributeDict);
    NSString *currency = [attributeDict objectForKey:@"currency"];
    //NSLog(@"%@",country);
    NSString *rate = [attributeDict objectForKey:@"rate"];
    //NSLog(@"%@",rate);
  
    if (currency && rate) {
        [_rates setObject:rate forKey:currency];

    }
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //if(string.length>0)
        //NSLog(@"Characters: %@", string);
}


/*
 *Methods to remove keyboard 
 */

-(void)onKeyboardAppear:(NSNotification *)notification
{
    _hiddenButtonToHideKeyboard.hidden=NO;
}

-(void)onKeyboardHide:(NSNotification *)notification
{
    _hiddenButtonToHideKeyboard.hidden=YES;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_input resignFirstResponder];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

/*
 *These methods make the UIPicker
 */

#pragma mark Picker Data Source Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [_currencies count];
    
}

#pragma mark Picker Delegate Methods

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [_currencies objectAtIndex:row];
    
}


//This method calculates the currency and outputs it
- (IBAction)buttonPressed:(id)sender {

    NSString *from = [_currencies objectAtIndex:[_fromCurrency selectedRowInComponent:0]];
    NSString *to = [_currencies objectAtIndex:[_toCurrency selectedRowInComponent:0]];
    NSString *stringRate = [_rates objectForKey:from];
    double divRate = [stringRate doubleValue];
    stringRate = [_rates objectForKey:to];
    double mulRate = [stringRate doubleValue];
    
    double inputAmount = [_input.text doubleValue];
    double outputAmount = (inputAmount/divRate) * mulRate;
    //[_output setText:[NSString stringWithFormat:@"%1.0f Kilometers Per Hour",m]];
    
    [_output setText:[NSString stringWithFormat:@"%.02f %@ is %.02f %@", inputAmount, from,outputAmount,to]];
    [self.input setText:nil];
    [self.input resignFirstResponder];
    
}

- (IBAction)hiddenButtonToHideKeyboard:(id)sender {
    [self.output setText:nil];
    [self.input resignFirstResponder];
}
@end
