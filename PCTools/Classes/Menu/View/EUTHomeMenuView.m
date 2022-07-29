//
//  EUTHomeMenuView.m
//  EUTTools
//
//  Created by apple on 2020/1/2.
//  Copyright © 2020 apple. All rights reserved.
//

#import "EUTHomeMenuView.h"
#import "EUTHomeMenuCell.h"
@interface EUTHomeMenuView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,assign)CGFloat cellWidth;
@property(nonatomic,assign)CGFloat cellHeight;

@end

@implementation EUTHomeMenuView

-(instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = MainBgColor;
        _dataArr = [NSMutableArray array];
        self.cellWidth = (kScreenW - 40 -kAutoScale(30))/2;
        self.cellHeight = self.cellWidth*(7/17);
        [self createSubView];
    }
    return self;
}
-(void)createSubView {
    //创建布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置垂直间距
    layout.minimumLineSpacing = kAutoScale(20);
    _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.sectionInset = UIEdgeInsetsMake(kAutoScale(20), 0, kAutoScale(20), 0);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = MainBgColor;
    _collectionView.layer.backgroundColor = MainBgColor.CGColor;
    _collectionView.showsVerticalScrollIndicator = NO;
    //注册item类型
    [_collectionView registerClass:[EUTHomeMenuCell class] forCellWithReuseIdentifier:@"EUTHomeMenuCell"];
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
}
#pragma mark collectionDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EUTHomeMenuCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EUTHomeMenuCell" forIndexPath:indexPath];
    cell.dataDict = self.dataArr[indexPath.row];
    return cell;
}
//头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
//设置每组组头大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath  {
    return CGSizeMake(self.cellWidth, 70);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArr[indexPath.item];
    NSInteger index = [dict[@"index"] integerValue];
    NSString *titleStr = dict[@"title"];
    if([self.viewDelegate respondsToSelector:@selector(itemBtnAction:title:)]){
        [self.viewDelegate itemBtnAction:index title:titleStr];
    }
}
@end
