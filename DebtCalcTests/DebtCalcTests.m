
#import <XCTest/XCTest.h>

#import "Calculator.h"
#import "Payment.h"

@interface DebtCalcTests : XCTestCase
@end

@implementation DebtCalcTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

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
