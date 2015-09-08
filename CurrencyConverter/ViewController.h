//
//  ViewController.h
//  CurrencyConverter
//
//  Created by MMstudent on 3/10/14.
//  Copyright (c) 2014 SBU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSXMLParserDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate> {
    
}

@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSArray *currencies;
@property (nonatomic, strong) NSMutableDictionary *rates;
@property (strong, nonatomic) IBOutlet UITextField *input;
@property (strong, nonatomic) IBOutlet UILabel *output;

@property (strong, nonatomic) IBOutlet UIButton *hiddenButtonToHideKeyboard;

@property (strong, nonatomic) IBOutlet UIPickerView *fromCurrency;
@property (strong, nonatomic) IBOutlet UIPickerView *toCurrency;
- (IBAction)buttonPressed:(id)sender;

- (IBAction)hiddenButtonToHideKeyboard:(id)sender;


@end
