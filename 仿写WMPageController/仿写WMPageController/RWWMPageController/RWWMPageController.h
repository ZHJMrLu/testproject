//
//  WMPageController.h
//  仿写WMPageController
//
//  Created by bus365-04 on 2019/8/30.
//  Copyright © 2019 MrLu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWWMMenuView.h"
#import "RWWMScrollView.h"
NS_ASSUME_NONNULL_BEGIN

@class RWWMPageController;

typedef NS_ENUM(NSInteger, RWWMPageControllerCachePolicy) {
    RWWMPageControllerCachePolicyDisabled   = -1,  // Disable Cache
    RWWMPageControllerCachePolicyNoLimit    = 0,   // No limit
    RWWMPageControllerCachePolicyLowMemory  = 1,   // Low Memory but may block when scroll
    RWWMPageControllerCachePolicyBalanced   = 3,   // Balanced ↑ and ↓
    RWWMPageControllerCachePolicyHigh       = 5    // High
};
typedef NS_ENUM(NSInteger, RWWMPageControllerPreloadPolicy) {
    RWWMPageControllerPreloadPolicyNever     = 0, // Never pre-load controller.
    RWWMPageControllerPreloadPolicyNeighbour = 1, // Pre-load the controller next to the current.
    RWWMPageControllerPreloadPolicyNear      = 2  // Pre-load 2 controllers near the current.
};
@protocol RWWMPageControllerDataSource <NSObject>
@required
/**
 子控制器的数量

 @param pageController pageController
 @return 数量
 */
-(NSInteger)numberOfChildControllerInPageController:(RWWMPageController *)pageController;
@required
/**
 指定位置的子控制器

 @param pageController pageController
 @param index 位置
 @return 子控制器
 */
-(__kindof UIViewController *)pageController:(RWWMPageController *)pageController viewControllerAtIndex:(NSInteger)index;
@required

/**
 指定位置菜单标题

 @param pageController pageController
 @param index 位置
 @return 菜单标题名称
 */
-(NSString *)pageController:(RWWMPageController *)pageController titleAtIndex:(NSInteger)index;

@required

/**
 设置子控制器的大小

 @param pageController pageController
 @param scrollView 容器滚动视图
 @return 大小
 */
-(CGRect)pageController:(RWWMPageController *)pageController frameForContentView:(RWWMScrollView *)scrollView;

/**
 设置菜单栏的大小

 @param pageController pageController
 @param menuView 菜单视图
 @return 大小
 */
-(CGRect)pageController:(RWWMPageController *)pageController frameForMenuView:(RWWMMenuView *)menuView;
@end

@protocol RWWMPageControllerDelegate <NSObject>

/**
 已经添加的子控制器以及子控制器的信息

 @param pageController pageController
 @param viewController 子控制器
 @param info 子控制器的信息
 */
-(void)pageController:(RWWMPageController *)pageController didEnterViewController:(UIViewController *)viewController controllerInfo:(NSDictionary *)info;

/**
 即将添加的子控制器以及子控制器的信息
 
 @param pageController pageController
 @param viewController 子控制器
 @param info 子控制器的信息
 */
-(void)pageController:(RWWMPageController *)pageController willEnterViewController:(UIViewController *)viewController controllerInfo:(NSDictionary *)info;

@end
@interface RWWMPageController : UIViewController<UIScrollViewDelegate,RWWMPageControllerDelegate,RWWMPageControllerDataSource>
/** 数据代理 */
@property(nonatomic,weak)id<RWWMPageControllerDataSource> dataSource;
/** 代理 */
@property(nonatomic,weak)id<RWWMPageControllerDelegate> delegate;
/** 菜单视图 */
@property(nonatomic,weak)RWWMMenuView * menuView;
/** 容器视图 */
@property(nonatomic,weak)RWWMScrollView * scrollView;
/** 控制器数组 */
@property(nonatomic,strong)NSArray<Class> * viewControllerClasses;
/** 标题数组 */
@property(nonatomic,strong)NSArray<NSString *> * titles;
/** 当前显示的控制器 */
@property(nonatomic,strong,readonly)UIViewController * currentViewController;
/** 选中位置 从0开始 */
@property(nonatomic,assign)int  selectIndex;
/** 点击菜单的按钮视图滑动是否有动画 */
@property(nonatomic,assign)BOOL  pageAnimatable;
/** 是否自动通过字符串计算菜单中单个按钮的宽度 default NO */
@property(nonatomic,assign)BOOL  autoCalculatesItemWidth;
/** 子控制器是否可以滚动 default YES */
@property(nonatomic,assign)BOOL  scrollEnable;
/** 选中标题的尺寸 */
@property(nonatomic,assign)CGFloat  titleSizeSelected;
/** 非选中状态下标题的尺寸 */
@property(nonatomic,assign)CGFloat  titleSizeNormal;
/** 选中标题的颜色 */
@property(nonatomic,strong)UIColor * titleColorSelected;
/** 非选中状态下标题的a颜色 */
@property(nonatomic,strong)UIColor * titleColorNormal;
/** 标题字体的名字 */
@property(nonatomic,copy)NSString * titleFontName;
/** 菜单中每个标题的宽度 所有的宽度一致 */
@property(nonatomic,assign)CGFloat menuItemWidth;
/** 自定义设置菜单中每个标题的宽度 */
@property(nonatomic,strong)NSArray<NSNumber *> * itemsWidths;
/** 菜单视图显示风格 */
//@property(nonatomic,assign)RWWMMenuViewStyle  menuStyle;
/** 菜单子视图布局模式 */
//@property(nonatomic,assign)RWWMMenuViewLayoutMode  menuViewLayoutMode;
/** 进度条颜色 默认风格时该属性无效 */
@property(nonatomic,strong)UIColor * progressColor;
/** 自定义进度条在标题下的宽度 */
@property(nonatomic,strong)NSArray<NSNumber *> * progressViewWidths;
/** 设置进度条的长度一致 */
@property(nonatomic,assign)CGFloat  progressWidth;
/** 是否需要调皮效果 如果需要，则progressWidth需要设置一个较小的值 */
@property(nonatomic,assign)BOOL progressViewIsNaughty;
/** 在子控制器创建或者子控制器展示完成后是否发送通知 默认NO */
@property(nonatomic,assign)BOOL postNotification;
/** 缓存机制 */
@property(nonatomic,assign)RWWMPageControllerCachePolicy  cachePolicy;
/** 预加载机制 在滚动结束时预加载几页 0 1 2  */
@property(nonatomic,assign)RWWMPageControllerPreloadPolicy preloadPolicy;
/** 是否保留滑动的弹簧效果 */
@property(nonatomic,assign)BOOL bounces;
/** 是否作为NavigationBar的titleView显示 default NO */
@property(nonatomic,assign)BOOL showOnNavigationBar;
/** 代码设置 contentView 的 contentOffset 之前，请设置 startDragging = YES */
@property(nonatomic,assign)BOOL  startDragging;
/** 下划进度条的高度 */
@property(nonatomic,assign)CGFloat  progressHeight;
/** 自定义菜单视图中各个标题的间距 间距为标题数 + 1 默认0 */
@property(nonatomic,strong)NSArray<NSNumber *> * itemsMargins;
/** 设置菜单视图中各个标题的间距 各个间距一致 */
@property(nonatomic,assign)CGFloat  itemMargin;
/** 进度条与菜单视图底部的间距 */
@property(nonatomic,assign) CGFloat progressViewBottomSpace;
/** 进度条的圆角值 */
@property(nonatomic,assign)CGFloat  progressViewCornerRadius;
/** 菜单视图左右间距 */
@property(nonatomic,assign)CGFloat  menuViewContentMargin;

/**
 初始化方法 设置子控制器和标题

 @param classes 子控制器数组
 @param titles 标题数组
 @return pageController
 */
-(instancetype)initWithViewControllerClasses:(NSArray<Class> *)classes titles:(NSArray<NSString *> *)titles;

/**
 刷新数据
 */
-(void)reloadData;

/**
 刷新布局
 */
-(void)forceLayoutSubViews;

/**
 更新指定位置的标题

 @param title 标题名称
 @param index 位置
 */
-(void)updateTitle:(NSString *)title atIndex:(NSInteger)index;

/**
 更新指定位置的标题和宽度

 @param title 标题名称
 @param width 标题宽度
 @param index 位置
 */
-(void)updateTitle:(NSString *)title width:(CGFloat)width atIndex:(NSInteger)index;

/**
 更新指定位置的标题的富文本

 @param title 富文本内容
 @param index 位置
 */
-(void)updateAttributeTitle:(NSAttributedString *)title atIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
