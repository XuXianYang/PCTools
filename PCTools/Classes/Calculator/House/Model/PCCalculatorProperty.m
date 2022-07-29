#import "PCCalculatorProperty.h"

@implementation PCCalculatorProperty

+ (PCCalculatorProperty *)shareCalculator {

    static PCCalculatorProperty *calculaProperty = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calculaProperty = [[self alloc]init];
    });
    return calculaProperty;
}
- (NSMutableArray *)dengebenxiArray {
    if (!_dengebenxiArray) {
        self.dengebenxiArray = [NSMutableArray array];
    }
    return _dengebenxiArray;
}
@end
