//
//  AppDelegate.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/04.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        let nav = UINavigationController()
        nav.viewControllers = [MainViewController()]
        window?.rootViewController = nav
        
        return true
    }
}
