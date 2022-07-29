//
//  SynopticNetworkCustomView.h
//  SynopticNetwork
//
//  Created by he on 2018/7/31.
//  Copyright © 2018年 HeFengTianQi. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 浮窗样式 (仅SynopticNetworkCustomViewTypeHorizontal样式才会显示全部内容)
 - SynopticNetworkCustomViewTypeVertical:   竖向长方形   宽高比 1/1 （默认）
 - SynopticNetworkCustomViewTypeHorizontal: 横向显示全部内容   宽高比 15/2
 - SynopticNetworkCustomViewTypeHorizontalShort: 横向显示部分内容   宽高比 25/12
 - SynopticNetworkCustomViewTypeSquare:     正方形  宽高比 1/1
 - SynopticNetworkCustomViewTypeCircle:     圆形   宽高比 1/1
 */
typedef NS_ENUM(NSInteger, SynopticNetworkCustomViewType) {
    SynopticNetworkCustomViewTypeVertical,
    SynopticNetworkCustomViewTypeHorizontal,
    SynopticNetworkCustomViewTypeHorizontalShort,
    SynopticNetworkCustomViewTypeSquare,
    SynopticNetworkCustomViewTypeCircle
};

/**
 视图悬浮位置（相对于整个屏幕）
 
 - SynopticNetworkCustomViewPositionCenter: 居中
 - SynopticNetworkCustomViewPositionTopLeft: 左上
 - SynopticNetworkCustomViewPositionTopRight: 右上
 - SynopticNetworkCustomViewPositionBottomLeft: 左下
 - SynopticNetworkCustomViewPositionBottomRight: 右下
 */
typedef NS_ENUM(NSInteger, SynopticNetworkCustomViewPosition) {
    SynopticNetworkCustomViewPositionCenter,
    SynopticNetworkCustomViewPositionTopLeft,
    SynopticNetworkCustomViewPositionTopRight,
    SynopticNetworkCustomViewPositionBottomLeft,
    SynopticNetworkCustomViewPositionBottomRight
};
/**
 插件内容水平方向显示对齐方式
 
 - SynopticNetworkContentViewAlignmentCenter: 内容居中（默认）
 - SynopticNetworkContentViewAlignmentLeft: 内容居左
 - SynopticNetworkContentViewAlignmentRight: 内容居右
 
 */
typedef NS_ENUM(NSInteger, SynopticNetworkContentViewAlignment) {
    SynopticNetworkContentViewAlignmentCenter,
    SynopticNetworkContentViewAlignmentLeft,
    SynopticNetworkContentViewAlignmentRight
};
/**
 拖拽方向
 
 - SynopticNetworkCustomViewDragDirectionAny: 任意方向 （默认）
 - SynopticNetworkCustomViewDragDirectionHorizontal: 水平方向
 - SynopticNetworkCustomViewDragDirectionVertical: 垂直方向
 */
typedef NS_ENUM(NSInteger, SynopticNetworkCustomViewDragDirection) {
    SynopticNetworkCustomViewDragDirectionAny,
    SynopticNetworkCustomViewDragDirectionHorizontal,
    SynopticNetworkCustomViewDragDirectionVertical,
};

/**
 图标样式
 
 - SynopticNetworkCustomViewIconTypeLight: 亮色系
 - SynopticNetworkCustomViewIconTypeDark: 暗色系
 */
typedef NS_ENUM(NSInteger, SynopticNetworkCustomViewIconType) {
    SynopticNetworkCustomViewIconTypeLight,
    SynopticNetworkCustomViewIconTypeDark
};
@interface SynopticNetworkCustomView : UIView


/**
 设置悬浮位置,设置此方法只改变位置不改变大小
 */
@property (nonatomic,assign) SynopticNetworkCustomViewPosition viewPosition;

/**
 设置插件内容水平方向显示对齐方式
 */
@property (nonatomic,assign) SynopticNetworkContentViewAlignment contentViewAlignmen;

/**
 设置图标样式（默认亮色系）
 */
@property (nonatomic,assign) SynopticNetworkCustomViewIconType iconType;

/**
 SynopticNetworkCustomView的内边距
 */
@property (nonatomic,assign) UIEdgeInsets padding;

/**
 设置背景颜色
 */
@property (nonatomic,strong) UIColor *backgroundColor;

/**
 设置背景图片
 */
@property (nonatomic,strong) UIImage *contentViewBackgroundImage;

/**
 导航条背景颜色
 */
@property (nonatomic,strong) UIColor *navigationBarBackgroundColor;

/**
 进度条颜色
 */
@property (nonatomic,strong) UIColor *progressColor;
/**
 文字颜色 默认白色
 */
@property (nonatomic,strong) UIColor *textColor;

/**
 是不是能拖曳，默认为NO
 YES，能拖曳,有默认背景颜色
 NO，不能拖曳,默认背景颜色透明
 */
@property (nonatomic,assign) BOOL dragEnable;

/**
 是不是总保持在父视图边界，默认为NO,有黏贴边界效果
 isKeepBounds = YES，它将自动黏贴边界，而且是最近的边界
 isKeepBounds = NO， 它将不会黏贴在边界，它是free(自由)状态，跟随手指到任意位置，但是也不可以拖出给定的范围frame
 */
@property (nonatomic,assign) BOOL isKeepBounds;

/**
 活动范围，默认为父视图的frame范围内（因为拖出父视图后无法点击，也没意义）
 如果设置了，则会在给定的范围内活动
 如果没设置，则会在父视图范围内活动
 注意：设置的frame不要大于父视图范围
 注意：设置的frame为0，0，0，0表示活动的范围为默认的父视图frame，如果想要不能活动，请设置dragEnable这个属性为NO
 */
@property (nonatomic,assign) CGRect freeRect;

/**
 拖曳的方向，默认为any，任意方向
 */
@property (nonatomic,assign) SynopticNetworkCustomViewDragDirection dragDirection;

#pragma mark 初始化方法

/**
 @param frame 视图frame
 @param type 浮窗样式枚举(视图会根据浮窗样式的宽高比进行布局，因此如果传入宽高不符合比例会自动计算出符合宽高比的最大视图尺寸，您可以通过contentViewAlignmen来设置内容显示的对齐方式)
 @param userKey 用户key 必填
 @param location 城市或地区，可输入以下值：
 1. 城市ID：城市列表
 2. 经纬度格式：经度,纬度（经度在前纬度在后，英文,分隔，十进制格式，北纬东经为正，南纬西经为负
 3. 城市名称，支持中英文和汉语拼音
 4. 城市名称，上级城市 或 省 或 国家，英文,分隔，此方式可以在重名的情况下只获取想要的地区的天气数据，例如 西安,陕西
 5. IP
 6. 根据请求自动判断，根据用户的请求获取IP，通过 IP 定位并获取城市数据
 7. 可为空，系统自动获取当前设备所在经纬度，然后将获取到的经纬度作为location参数调用传location的接口
 @return SynopticNetworkCustomView 插件视图
 */
+(instancetype)initWithFrame:(CGRect)frame ViewType:(SynopticNetworkCustomViewType)type UserKey:(NSString *)userKey Location:(NSString *)location;

/**
 @param frame 视图frame
 @param type 浮窗样式枚举(视图会根据浮窗样式的宽高比进行布局，因此如果传入宽高不符合比例会自动计算出符合宽高比的最大视图尺寸，您可以通过contentViewAlignmen来设置内容显示的对齐方式)
 @param userKey 用户key 必填
 @param location 城市或地区，可输入以下值：
 1. 城市ID：城市列表
 2. 经纬度格式：经度,纬度（经度在前纬度在后，英文,分隔，十进制格式，北纬东经为正，南纬西经为负
 3. 城市名称，支持中英文和汉语拼音
 4. 城市名称，上级城市 或 省 或 国家，英文,分隔，此方式可以在重名的情况下只获取想要的地区的天气数据，例如 西安,陕西
 5. IP
 6. 根据请求自动判断，根据用户的请求获取IP，通过 IP 定位并获取城市数据
 7. 可为空，系统自动获取当前设备所在经纬度，然后将获取到的经纬度作为location参数调用传location的接口
 @return SynopticNetworkCustomView 插件视图
 */
-(instancetype)initWithFrame:(CGRect)frame ViewType:(SynopticNetworkCustomViewType)type UserKey:(NSString *)userKey Location:(NSString *)location;

@end
