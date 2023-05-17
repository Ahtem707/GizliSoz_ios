//
//  AppDelegate.swift
//  GizliSoz
//
//  Created by Ahtem Sitjalilov on 05.11.2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIButton.swizzle()
        UIViewController.swizzleViewController()
        UINavigationController.swizzleNavigationController()
        
        AppStorage.appStart()
        AppStorage.userLoginCount += 1
        
        SoundPlayer.appStart()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = AppNavigationController()

        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}
