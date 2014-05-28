
#import <Foundation/Foundation.h>

@interface Payment : NSObject

@property (assign) int order;
@property (strong) NSDate *date;
@property (assign) double annuity;
@property (assign) double interest;
@property (assign) double principal;
@property (assign) double remainingDebt;

@end
