
#import "Payment.h"

@implementation Payment

- (NSString *)description {
   return [NSString stringWithFormat:@"Annuity: %f, Interest: %f, Principal: %f, Remaining Debt: %f", self.annuity, self.interest, self.principal, self.remainingDebt];
}

@end
