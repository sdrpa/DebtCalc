
#import <Foundation/Foundation.h>

@interface Calculator : NSObject

@property (assign) double amount;
@property (assign) double annualInterestRate;
@property (assign) NSUInteger periodInMonths;
@property (strong) NSDate *startDate;

@property (assign, readonly) double monthlyPayment;
@property (assign, readonly) double totalInterest;
@property (strong, readonly) NSArray *paymentPlan;

- (double)calculateMonthlyPaymentForAmount:(double)amount
                        annualInterestRate:(double)annualRate
                            periodInMonths:(NSUInteger)period;
- (double)interestAmountFromMonth:(NSUInteger)startMonth untillMonth:(NSUInteger)endMonth;

@end
