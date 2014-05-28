
#import "CalculatorTest.h"
#import "Calculator.h"
#import "Payment.h"

@implementation CalculatorTest

- (void)testCalculate {
   Calculator *calc = [[Calculator alloc] init];
   double payment = [calc calculateMontlyPaymentForAmount:59000.0 annualInterestRate:5.5 periodInMonths:195];

   NSLog(@"Montly Payement %f", payment);
}

- (void)testPlan {
   Calculator *calc = [[Calculator alloc] init];
   calc.amount = 59000.0;
   calc.annualInterestRate = 5.0;
   calc.periodInMonths = 315;
   
   NSArray *paymentPlan = [calc paymentPlan];
   
   for (Payment *payment in paymentPlan) {
      NSLog(@"%@", payment);
   }
}

- (void)testInterestAmountFromMonthUntillMonth {
   Calculator *calc = [[Calculator alloc] init];
   calc.amount = 59000.0;
   calc.annualInterestRate = 5.0;
   calc.periodInMonths = 315;
   
   //NSLog(@"IntersetAmountFromMonthUntillMonth: %f", [calc interestAmountFromMonth:0 untillMonth:315]);
}
@end
