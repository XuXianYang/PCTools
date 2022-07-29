//
#import "PCBaseTextField.h"

@implementation PCBaseTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuV = [UIMenuController sharedMenuController];
    if (menuV) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}
@end
