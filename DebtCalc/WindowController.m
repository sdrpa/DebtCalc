
#import "WindowController.h"
#import "Calculator.h"
#import "Payment.h"

@interface WindowController () {
   Calculator *_calc;
}
@property (assign) double amount;
@property (assign) double annualInterestRate;
@property (assign) int periodInMonths;
@property (assign) int totalInterest;
@property (assign) int interestForSelection;
@property (assign) double monthlyPayment;

@property (strong) NSArray *paymentPlan;
@property (weak) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSDatePicker *startDatePicker;
@end

@implementation WindowController

- (id)initWithWindow:(NSWindow *)window {
   self = [super initWithWindow:window];
   if (self) {
      _amount = 59000.0;
      _annualInterestRate = 5.5;
      _periodInMonths = 195;
      _monthlyPayment = 0.0;
      
      [self loadData];
   }
   return self;
}

- (void)windowDidLoad {
   [super windowDidLoad];
   
   // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
   [self.startDatePicker setDateValue:[NSDate dateWithNaturalLanguageString:@"12/11/2010"]];
   [self calculate];
}

- (void)saveData {
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   [defaults setObject:@(self.amount) forKey:@"amount"];
   [defaults setObject:@(self.annualInterestRate) forKey:@"annualInterestRate"];
   [defaults setObject:@(self.periodInMonths) forKey:@"periodInMonths"];
}

- (void)loadData {
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   self.amount = [[defaults objectForKey:@"amount"] doubleValue] ? : 59000.0;
   self.annualInterestRate = [[defaults objectForKey:@"annualInterestRate"] doubleValue] ? : 5.5;
   self.periodInMonths = [[defaults objectForKey:@"periodInMonths"] doubleValue] ? : 195;
}

- (void)calculate {
   _calc = [[Calculator alloc] init];
   _calc.amount = [self amount];
   _calc.annualInterestRate = [self annualInterestRate];
   _calc.periodInMonths = [self periodInMonths];
   _calc.startDate = [self.startDatePicker dateValue];
   
   self.monthlyPayment = [_calc montlyPayment];
   self.paymentPlan = [_calc paymentPlan];
   self.totalInterest = [_calc interestAmountFromMonth:0 untillMonth:[self periodInMonths]];
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification {
   if (self.amount && self.annualInterestRate && self.periodInMonths)
   {
      [self calculate];
   }
}

- (IBAction)dateDidChange:(id)sender {
   [self calculate];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
   NSTableView *tableView = [notification object];
   NSIndexSet *selectedRows = [tableView selectedRowIndexes];
   if ([selectedRows count]) {
      self.interestForSelection = [_calc interestAmountFromMonth:(int)[selectedRows firstIndex]
                                                     untillMonth:(int)[selectedRows lastIndex]];
   }
   else {
      self.interestForSelection = 0.0;
   }
}

@end
