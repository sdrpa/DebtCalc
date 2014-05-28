
#import "Calculator.h"
#import "Payment.h"

@implementation Calculator

- (id)init{
   self = [super init];
   if (self) {
   }
   return self;
}

- (double)montlyPayment {
   return [self calculateMontlyPaymentForAmount:self.amount annualInterestRate:self.annualInterestRate periodInMonths:self.periodInMonths];
}

- (double)calculateMontlyPaymentForAmount:(double)amount annualInterestRate:(double)annualRate periodInMonths:(int)period {
   double rate =  (annualRate / 12.0) / 100.0;
   double payment = (amount * rate) / (1.0 - pow(1.0 + rate, -period));
   return payment;
}

- (NSArray *)paymentPlan {
   int monthsRemaining = self.periodInMonths;
   double monthlyPayment = [self calculateMontlyPaymentForAmount:self.amount annualInterestRate:self.annualInterestRate periodInMonths:monthsRemaining];
   double rest = self.amount;
   double rate =  (self.annualInterestRate / 12.0) / 100.0;
   
   double lastRest = self.amount;
   int c = 1;
   NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:monthsRemaining];
   
   NSDate *date = (self.startDate) ? : [NSDate new];
   NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
   [dateComponents setMonth:1];
   NSCalendar *calendar = [NSCalendar currentCalendar];
   
   while (monthsRemaining > 0) {
      double interest = rest * rate;
      rest = rest - (monthlyPayment - interest);
      
      date = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
      
      //NSLog(@"%i. Anuitet: %f, Iznos kamate: %f, Iznos glavnice: %f, Ostatak duga: %f", c, monthlyPayment, interest, lastRest - rest ,rest);
      Payment *payment = [[Payment alloc] init];
      payment.order = c;
      payment.date = date;
      payment.annuity = monthlyPayment;
      payment.interest = interest;
      payment.principal = lastRest - rest;
      payment.remainingDebt = rest;
      [mutableArray addObject:payment];
      
      monthsRemaining--;
      lastRest = rest;
      c++;
   }
   
   return [NSArray arrayWithArray:mutableArray];
}

- (double)interestAmountFromMonth:(int)startMonth untillMonth:(int)endMonth {
   if (endMonth < startMonth) {
      NSAssert(false, nil);
   }
   NSArray *paymentPlan = [self paymentPlan];
   double total = 0;
   for (int i = startMonth; i < endMonth; i++) {
      Payment *payment = [paymentPlan objectAtIndex:i];
      total += [payment interest];
   }
   if (endMonth == startMonth) {
      return [[paymentPlan objectAtIndex:startMonth] interest];
   }
   return total;
}

@end
