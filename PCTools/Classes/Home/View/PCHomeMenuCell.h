//
//  PCHomeMenuCell.h
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PCHomeMenuCellDelegate <NSObject>

- (void)btnAction:(NSInteger)index title:(NSString*)currentTitle;

@end
@interface PCHomeMenuCell : UITableViewCell

@property (weak, nonatomic) id<PCHomeMenuCellDelegate> delegate;

@property(nonatomic,retain)NSArray *dataArr;

@property(nonatomic,copy)NSString *headerViewTitle;

@property(nonatomic,assign)BOOL isShowWeather;


@end

NS_ASSUME_NONNULL_END
