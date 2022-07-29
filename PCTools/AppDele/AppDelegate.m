//
//  AppDelegate.m
//  PCTools
//
//  Created by apple on 2019/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "PCGuideController.h"
#import <MangoFix/MangoFix.h>

@interface AppDelegate ()
@end

@implementation AppDelegate

-(UIWindow*)window{
    if(!_window){
        _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor whiteColor];
    }
    return _window;
}
-(void)setupTabbarVC{
    NSString *currentStr =[[NSUserDefaults standardUserDefaults] objectForKey:@"isLaunched"];
    if([currentStr isEqualToString:@"YES"]){
        [self startApp];
    }else{
        PCGuideController *guideVC = [[PCGuideController alloc]init];
        self.window.rootViewController = guideVC;
        [self.window makeKeyAndVisible];
    }
}
-(void)startApp{
    PCBaseTabBarController*baseTabbar = [[PCBaseTabBarController alloc]init];
    _baseNav = [[PCBaseNavigationController alloc]initWithRootViewController:baseTabbar];
    self.window.rootViewController = _baseNav;
    [self.window makeKeyAndVisible];
    _baseTabBar = baseTabbar;
}
- (BOOL)encryptPlainScirptToDocument{
    NSError *outErr = nil;
    BOOL writeResult = NO;
    
    //NSURL *scriptUrl = [[NSBundle mainBundle] URLForResource:@"demo" withExtension:@"mg"];
    NSString *scriptStr = [NSString stringWithFormat:@"%@/down/ios/xiaozhshou/%@/demo.mg",PCBaseUrl,PCApp_Version];
    NSURL *scriptUrl = [NSURL URLWithString:scriptStr];
    NSString *planScriptString = [NSString stringWithContentsOfURL:scriptUrl encoding:NSUTF8StringEncoding error:&outErr];
    if (outErr) goto err;
    
    {
        NSURL *publicKeyUrl = [[NSBundle mainBundle] URLForResource:@"public_key.txt" withExtension:nil];
        NSString *publicKey = [NSString stringWithContentsOfURL:publicKeyUrl encoding:NSUTF8StringEncoding error:&outErr];
        if (outErr) goto err;
        NSString *encryptedScriptString = [MFRSA encryptString:planScriptString publicKey:publicKey];
        
        NSString * encryptedPath= [(NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"encrypted_demo.mg"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:encryptedPath]) {
            [fileManager createFileAtPath:encryptedPath contents:nil attributes:nil];
        }
        writeResult = [encryptedScriptString writeToFile:encryptedPath atomically:YES encoding:NSUTF8StringEncoding error:&outErr];
    }
err:
    if (outErr) NSLog(@"%@",outErr);
    return writeResult;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    /*
    BOOL writeResult = [self encryptPlainScirptToDocument];
    if (!writeResult) {
        return NO;
    }
    NSURL *privateKeyUrl = [[NSBundle mainBundle] URLForResource:@"private_key.txt" withExtension:nil];
    NSString *privateKey = [NSString stringWithContentsOfURL:privateKeyUrl encoding:NSUTF8StringEncoding error:nil];
    
    MFContext *context = [[MFContext alloc] initWithRASPrivateKey:privateKey];
    
    NSString * encryptedPath= [(NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"encrypted_demo.mg"];
    NSURL *scriptUrl = [NSURL fileURLWithPath:encryptedPath];
    [context evalMangoScriptWithURL:scriptUrl];
    */
    [self setupTabbarVC];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
