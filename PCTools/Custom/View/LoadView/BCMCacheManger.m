//
//  BCMCacheManger.m
//  BankOfCommunications
//
//  Created by konghao on 2017/11/7.
//  Copyright © 2017年 P&C Information. All rights reserved.
//

#import "BCMCacheManger.h"

@implementation BCMCacheManger


- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bcmDidReceiveMemory) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}


singleton_implementation(@"BCMCacheManger");


- (void)bcmDidReceiveMemory
{
    _mjDragArray = nil;
    _mjFooterArray = nil;
    _mjHeaderArray = nil;
    _refreshBlueLoadingArray = nil;
    _refreshWhiteLoadingArray = nil;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}


- (NSArray *)mjFooterArray
{
    if (!_mjFooterArray.count) {
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        @autoreleasepool {
            for (int i=0; i<52; i++) {
                NSString * name = [NSString stringWithFormat:@"s_000%02d",i];
                UIImage * image = [UIImage imageNamed:name];
                if (image) {
                    [tmpArr addObject:image];
                }
                
            }
        }
        _mjFooterArray = tmpArr;
    }
    return _mjFooterArray;
    
}
//dloop_00001

- (NSArray *)mjPulling2Array
{
    //
    if (!_mjPulling2Array) {
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        for (int i=1; i<15; i++) {
            NSString * name = [NSString stringWithFormat:@"dloop_000%02d",i];
            //            NSString * path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
            //            UIImage * image = [UIImage imageWithContentsOfFile:path];
            UIImage * image = [UIImage imageNamed:name];
            if (image) {
//                [tmpArr addObject:image];
                                [tmpArr addObject:image];
            }
        }
        _mjPulling2Array = tmpArr;
    }
    return _mjPulling2Array;
}
- (NSArray *)mjPullingArray
{
//
    if (!_mjPullingArray) {
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        for (int i=1; i<35; i++) {
            NSString * name = [NSString stringWithFormat:@"ds_000%02d",i];
            //            NSString * path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
            //            UIImage * image = [UIImage imageWithContentsOfFile:path];
            UIImage * image = [UIImage imageNamed:name];
            if (image) {
                [tmpArr addObject:(id)image.CGImage];
            }
        }
        _mjPullingArray = tmpArr;
    }
    return _mjPullingArray;
}
- (NSArray *)mjHeaderArray
{
    if (!_mjHeaderArray.count) {
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        for (int i=1; i<51; i++) {
            NSString * name = [NSString stringWithFormat:@"dz_000%02d",i];
//            NSString * path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
//            UIImage * image = [UIImage imageWithContentsOfFile:path];
            UIImage * image = [UIImage imageNamed:name];
            if (image) {
                [tmpArr addObject:image];
            }
        }
        _mjHeaderArray = tmpArr;
    }
    return _mjHeaderArray;
    
}

- (NSArray *)mjDragArray
{
    if (!_mjDragArray.count) {
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        @autoreleasepool {

        for (int i=0; i<24; i++) {
            NSString * name = [NSString stringWithFormat:@"d_000%02d",i];
//            NSString * path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
//            UIImage * image = [UIImage imageWithContentsOfFile:path];
            UIImage * image = [UIImage imageNamed:name];

            if (image) {
                [tmpArr addObject:image];
            }
        }
        }
        _mjDragArray = tmpArr;
    }
    return _mjDragArray;
}


- (NSArray *)refreshBlueLoadingArray {
    
    if (!_refreshBlueLoadingArray.count) {
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        @autoreleasepool {
            
            for (NSInteger i = 1; i < 31; i++) {
                NSString *imageName = [NSString stringWithFormat:@"Loading_BlueCircle_%02ld", (long)i];
                UIImage *tempImage = [UIImage imageNamed:imageName];
                if (tempImage) {
                    [tmpArr addObject:tempImage];
                }
            }
        }
        _refreshBlueLoadingArray = tmpArr;
    }
    return _refreshBlueLoadingArray;
}

- (NSArray *)refreshWhiteLoadingArray {
    if (!_refreshWhiteLoadingArray.count) {
        NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:0];
        @autoreleasepool {
            for (NSInteger i=0; i<30; i++) {
                NSString * name = [NSString stringWithFormat:@"Loading_WhiteCircle_%02ld", (long)i];
//                NSString * path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
                UIImage * image = [UIImage imageNamed:name];
                if (image) {
                    [tmpArr addObject:image];
                }
            }
        }
        _refreshWhiteLoadingArray = tmpArr;
    }
    return _refreshWhiteLoadingArray;
}


@end
