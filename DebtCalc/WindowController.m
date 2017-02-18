
#import "WindowController.h"
#import "Calculator.h"
#import "Payment.h"

@interface WindowController ()
@property (assign) double interestForSelection;
@property (weak) IBOutlet NSArrayController *arrayController;
@property (strong) Calculator *calculator;
@end

@implementation WindowController

- (id)initWithWindow:(NSWindow *)window {
   self = [super initWithWindow:window];
   if (self) {
      _calculator = [[Calculator alloc] init];
   }
   return self;
}

- (void)windowDidLoad {
   [super windowDidLoad];

   self.calculator.amount = 59000.0;
   self.calculator.annualInterestRate = 5.5;
   self.calculator.periodInMonths = 195;
   self.calculator.startDate = [NSDate dateWithNaturalLanguageString:@"12/11/2010"];

   [self loadData];

   [self.arrayController addObserver:self forKeyPath:@"arrangedObjects" options:0 context:nil];
}

- (void)dealloc {
   [self.arrayController removeObserver:self forKeyPath:@"arrangedObjects"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
   if ([object isEqual:self.arrayController]) {
      [self updateInterestForSelection];
   } else {
      [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
   }
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
   [self updateInterestForSelection];
}

- (void)updateInterestForSelection {
   NSIndexSet *selectionIndexes = [self.arrayController selectionIndexes];
   if ([selectionIndexes count]) {
      NSUInteger firstIndex = [selectionIndexes firstIndex];
      NSUInteger lastIndex = [selectionIndexes lastIndex];
      NSLog(@"%li, %li", firstIndex, lastIndex);
      self.interestForSelection = [self.calculator interestAmountFromMonth:firstIndex
                                                               untillMonth:lastIndex];
   }
   else {
      self.interestForSelection = 0.0;
   }
}

#pragma mark -

- (void)saveData {
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   [defaults setObject:@(self.calculator.amount) forKey:@"amount"];
   [defaults setObject:@(self.calculator.annualInterestRate) forKey:@"annualInterestRate"];
   [defaults setObject:@(self.calculator.periodInMonths) forKey:@"periodInMonths"];
}

- (void)loadData {
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   self.calculator.amount = [[defaults objectForKey:@"amount"] doubleValue] ? : 59000.0;
   self.calculator.annualInterestRate = [[defaults objectForKey:@"annualInterestRate"] doubleValue] ? : 5.5;
   self.calculator.periodInMonths = [[defaults objectForKey:@"periodInMonths"] doubleValue] ? : 195;
}

@end
