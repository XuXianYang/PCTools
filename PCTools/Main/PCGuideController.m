//
//  PCGuideController.m
//  PCTools
//
//  Created by apple on 2019/12/23.
//  Copyright © 2019 apple. All rights reserved.
//

#import "PCGuideController.h"

@interface PCGuideController ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *scrollView1;
@property (nonatomic, strong)UIPageControl *pageControl;

@end

@implementation PCGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initGuide];
}
- (void)initGuide{
    NSArray *array = [NSArray arrayWithObjects:@"1", @"2",@"3", @"4",@"5",nil];
   
    self.scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView1 setContentSize:CGSizeMake(self.view.frame.size.width * array.count, self.view.frame.size.height)];
    self.scrollView1.bounces = NO;
    [self.scrollView1 setPagingEnabled:YES];
    self.scrollView1.delegate = self;
    self.scrollView1.showsHorizontalScrollIndicator = NO;
    [self.view addSubview: self.scrollView1];
    
    for (int i=0; i<array.count; i++) {
        UIImageView *imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[array objectAtIndex:i]]];
        imgView.clipsToBounds=YES;
        imgView.contentMode=UIViewContentModeScaleAspectFill;
        [imgView setFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.scrollView1 addSubview:imgView];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//在imageview3上加载一个透明的button
    [button setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    [button setFrame:CGRectMake(self.view.frame.size.width*(array.count-1)+100, self.view.frame.size.height - 100,  self.view.frame.size.width - 200, 40)];
    [button addTarget:self action:@selector(firstpressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView1 addSubview:button];
    button.layer.cornerRadius = 20;
    [button setTitle:@"进入" forState:UIControlStateNormal];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 30, self.view.frame.size.width - 20, 20)];
    self.pageControl.currentPageIndicatorTintColor = MainColor;
    self.pageControl.pageIndicatorTintColor = UIColorFromRGB(0x666666);
    self.pageControl.numberOfPages = array.count;
    self.pageControl.currentPage = 0;
    [self.view addSubview: self.pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = fabs(self.scrollView1.contentOffset.x) / self.view.frame.size.width;
    self.pageControl.currentPage = index;
}
- (void)firstpressed:(UIButton *)button{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isLaunched"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [APPDELEGATE startApp];
}

@end
