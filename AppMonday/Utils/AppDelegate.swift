//
//  AppDelegate.swift
//  AppMonday
//
//  Created by Nathan FALLET on 17/12/2018.
//  Copyright © 2018 Nathan FALLET. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let tabBarController = window?.rootViewController as! UITabBarController
        let splitViewController = tabBarController.viewControllers?.first as! UISplitViewController
        let leftNavController = splitViewController.viewControllers.first as! UINavigationController
        let masterViewController = leftNavController.topViewController as! TableViewController
        let rightNavController = splitViewController.viewControllers.last as! UINavigationController
        let detailViewController = rightNavController.topViewController as! AppDetailsViewController
        
        masterViewController.delegate = detailViewController
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Notifications permission granted.")
                UNUserNotificationCenter.current().delegate = self
                
                UNUserNotificationCenter.current().getPendingNotificationRequests() { (requests) in
                    if requests.count == 0 {
                    
                        let content = UNMutableNotificationContent()
                        content.title = "We are Monday!"
                        content.body = "Don't forget to check AppMonday"
                        content.sound = UNNotificationSound.default
                        
                        var dateInfo = DateComponents()
                        dateInfo.hour = 12
                        dateInfo.minute = 0
                        dateInfo.weekday = 2
                        dateInfo.timeZone = TimeZone(identifier: "Europe/Paris")
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
                        
                        let request = UNNotificationRequest(identifier: "AppMondayWeekly", content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request) { (error : Error?) in
                            if let theError = error {
                                print(theError.localizedDescription)
                            }
                        }
                        
                        print("Notification scheduled!")
                    }
                }
            } else {
                print("Notifications permission denied because: \(String(describing: error?.localizedDescription)).")
            }
            
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

