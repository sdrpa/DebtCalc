
#import "Calculator.h"
#import "Payment.h"

@implementation Calculator

+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
   NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
   if ([key isEqualToString:@"monthlyPayment"] ||
       [key isEqualToString:@"paymentPlan"] ||
       [key isEqualToString:@"totalInterest"])
   {
      NSArray *affectingKeys = @[@"amount", @"annualInterestRate", @"periodInMonths", @"startDate"];
      keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
   }
   return keyPaths;
}

- (double)monthlyPayment {
   double payment = [self calculateMonthlyPaymentForAmount:self.amount
                                        annualInterestRate:self.annualInterestRate
                                            periodInMonths:self.periodInMonths];
   return (self.periodInMonths == 0) ? 0 : payment;
}

- (double)calculateMonthlyPaymentForAmount:(double)amount
                        annualInterestRate:(double)annualRate
                            periodInMonths:(NSUInteger)period {
   if (annualRate == 0) {
      return amount/period;
   }
   double rate = (annualRate / 12.0) / 100.0;
   double payment = (amount * rate) / (1.0 - pow(1.0 + rate, -(double)period));
   return payment;
}


- (NSArray *)paymentPlan {
   NSUInteger monthsRemaining = self.periodInMonths;
   double monthlyPayment = [self calculateMonthlyPaymentForAmount:self.amount annualInterestRate:self.annualInterestRate periodInMonths:monthsRemaining];
   double rest = self.amount;
   double rate = (self.annualInterestRate / 12.0) / 100.0;
   
   double lastRest = self.amount;
   NSUInteger c = 1;
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

- (double)totalInterest {
   return [self interestAmountFromMonth:0 untillMonth:self.periodInMonths];
}

- (double)interestAmountFromMonth:(NSUInteger)startMonth untillMonth:(NSUInteger)endMonth {
   if (endMonth < startMonth) {
      NSAssert(false, nil);
   }
   NSArray *paymentPlan = self.paymentPlan;
   if ([paymentPlan count] == 0) {
      return 0;
   }
   double total = 0;
   for (NSUInteger i = startMonth; i <= endMonth; i++) {
      if (i == [paymentPlan count]) {
         break;
      }
      Payment *payment = [paymentPlan objectAtIndex:i];
      total += [payment interest];
   }
   if (endMonth == startMonth) {
      total = [[paymentPlan objectAtIndex:startMonth] interest];
   }
   return total;
}

- (void)setNilValueForKey:(NSString *)key {
   if ([key isEqualToString:@"amount"] ||
       [key isEqualToString:@"annualInterestRate"] ||
       [key isEqualToString:@"periodInMonths"])
   {
      [self setValue:@(0) forKey:key];
      return;
   }
   [super setNilValueForKey:key];
}

@end
