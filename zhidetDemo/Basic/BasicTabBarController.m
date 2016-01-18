

#import "BasicTabBarController.h"
#import "BasicNavController.h"
#import "FirstViewController.h"
#import "ServiceViewController.h"
#import "MyViewController.h"
#import "MoreViewController.h"
#import "JoinViewController.h"


@interface BasicTabBarController ()<UITabBarDelegate>

@end

@implementation BasicTabBarController
/**
 *  初始设置每一个Item的属性
 */
+ (void)initialize
{
    // 获取所有的tabBarItem外观标识
    // UITabBarItem *item = [UITabBarItem appearance];
    // self -> CZTabBarController
    // 获取当前这个类下面的所有tabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    att[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.5 green:0.8 blue:0.5 alpha:1];
    
    [item setTitleTextAttributes:att forState:UIControlStateSelected];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAllChildViewController];
    for (UINavigationController *nvc in self.tabBarController.viewControllers) {
        for (UIViewController * vc in nvc.childViewControllers) {
            [vc viewDidLoad];
        }
    }

    //设置选中之后的颜色
//    self.tabBar.tintColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 添加所有的子控制器
- (void)setUpAllChildViewController
{
    // 首页
    FirstViewController *first = [[FirstViewController alloc] init];
    [self setUpOneChildViewController:first image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[[UIImage imageNamed:@"tabbar_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] title:@"找平台"];
   
    ServiceViewController *news = [[ServiceViewController alloc] init];
    [self setUpOneChildViewController:news image:[UIImage imageNamed:@"tabbar_service"] selectedImage:[[UIImage imageNamed:@"tabbar_service_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] title:@"客服"];

 
    MyViewController *my = [[MyViewController alloc] init];
    [self setUpOneChildViewController:my image:[UIImage imageNamed:@"tabbar_my"] selectedImage:[[UIImage imageNamed:@"tabbar_my_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] title:@"用户中心"];
    
    MoreViewController *sever = [[MoreViewController alloc] init];
    [self setUpOneChildViewController:sever image:[UIImage imageNamed:@"tabbar_more"] selectedImage:[[UIImage imageNamed:@"tabbar_more_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] title:@"更多"];
   
}

#pragma mark - 添加一个子控制器
- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    vc.title = title;
    vc.tabBarItem.image = image;
    
    vc.tabBarItem.selectedImage = selectedImage;
    BasicNavController *nvc = [[BasicNavController alloc] initWithRootViewController:vc];
    [self addChildViewController:nvc];
}

//- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image  title:(NSString *)title
//{
//    vc.title = title;
//    vc.tabBarItem.image = image;
//
//    BasicNavController *nvc = [[BasicNavController alloc] initWithRootViewController:vc];
//    [self addChildViewController:nvc];
//}



@end
