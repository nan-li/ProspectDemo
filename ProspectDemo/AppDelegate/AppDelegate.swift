//
//  AppDelegate.swift
//  ProspectDemo
//
//  Created by iMac on 27/08/22.
//

import UIKit
import OneSignalFramework

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        OneSignal.initialize("cf532c5e-5be2-4b00-ab6d-3d3d72ca9124", withLaunchOptions: launchOptions)
        
        OneSignal.Notifications.requestPermission({ accepted in
            print("User accepted notifications: \(accepted)")
            //
            var ts = ""
            if let existingTs = UserDefaults.standard.string(forKey: LOGIN_ID) {
                ts = existingTs
            } else if let tsVal = Date().toMillis() {
                ts = "\(tsVal)"
                UserDefaults.standard.set(ts, forKey: LOGIN_ID)
                UserDefaults.standard.synchronize()
            }
            
            let externalId = ts
            OneSignal.login(externalId)
        }, fallbackToSettings: true)
        
//        self.requestPushNotificationPermissions()
        return true
    }
}

// MARK: - PushNotifications
extension AppDelegate{
    func requestPushNotificationPermissions() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(granted, error) in
            if (error == nil) {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        })
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .badge, .sound])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DeviceToken: \(deviceToken)")
    }
    
    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                    print("Permission granted: \(granted)")
                    guard granted else { return }
                }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }
}
