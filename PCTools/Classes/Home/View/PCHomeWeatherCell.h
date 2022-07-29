//
//  PCHomeWeatherCell.h
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PCHomeWeatherCellDelegate <NSObject>

- (void)btnAction:(NSInteger)index title:(NSString*)currentTitle;

@end

@interface PCHomeWeatherCell : UITableViewCell

@property (weak, nonatomic) id<PCHomeWeatherCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
