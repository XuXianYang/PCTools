//
//  PNCView.m
//  PNCLibrary
//
//  Created by 张瑞 on 14-7-28.
//  Copyright (c) 2014年 张瑞. All rights reserved.
//

#import "PNCView.h"
#import <QuartzCore/QuartzCore.h>

@interface PNCView (PNCLibraryPrivate)

/**
 *	@brief	初始化视图
 */
- (void)initView;

@end

@implementation PNCView
@synthesize userinfo = _userinfo;
@synthesize inset = _inset;

#pragma mark - lifecycle


- (id)init{
	self = [self initWithFrame:CGRectZero];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _userinfo = nil;
        _inset = UIEdgeInsetsZero;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}


@end
