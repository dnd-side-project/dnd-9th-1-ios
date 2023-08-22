//
//  AppDelegate.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/04.
//

import UIKit

import FirebaseCore
import FirebaseMessaging
import KakaoSDKAuth
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        registerNotification()
        
        if let kakaoKey = ProcessInfo.processInfo.environment["KAKAO_NATIVE_KEY"] {
            RxKakaoSDK.initSDK(appKey: kakaoKey)
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .systemBackground
        coordinator = AppCoordinator(window: window!)
        coordinator?.start()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.rx.handleOpenUrl(url: url)
        }
        
        return false
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func registerNotification() {
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        UIApplication.shared.registerForRemoteNotifications()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                KeychainManager.shared.rx
                    .saveItem(token, itemClass: .password, key: KeychainKeyList.fcmToken.rawValue)
                    .subscribe(onNext: {
                        print($0)
                    })
                    .dispose()
            }
        }
    }
}
