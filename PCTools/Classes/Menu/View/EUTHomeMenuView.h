//
//  EUTHomeMenuView.h
//  EUTTools
//
//  Created by apple on 2020/1/2.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HomeMenuViewDelegate <NSObject>
//按钮点击回调
-(void)itemBtnAction:(NSInteger)index title:(NSString*)title;

@end
@interface EUTHomeMenuView : UIView

@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,strong)NSMutableArray * dataArr;

@property(nonatomic,weak)id<HomeMenuViewDelegate>viewDelegate;

@end

NS_ASSUME_NONNULL_END
