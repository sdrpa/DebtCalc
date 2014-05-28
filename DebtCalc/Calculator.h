
#import <Foundation/Foundation.h>

@interface Calculator : NSObject

@property (assign) double amount;
@property (assign) double annualInterestRate;
@property (assign) int periodInMonths;
@property (assign, readonly) double monthlyPayment;
@property (strong) NSDate *startDate;

- (double)montlyPayment;
- (double)calculateMontlyPaymentForAmount:(double)amount annualInterestRate:(double)annualRate periodInMonths:(int)period;
- (NSArray *)paymentPlan;
- (double)interestAmountFromMonth:(int)startMonth untillMonth:(int)endMonth;

@end
