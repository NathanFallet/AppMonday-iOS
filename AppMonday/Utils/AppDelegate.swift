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
        // TabBarController
        let tabBarController = window?.rootViewController as! UITabBarController
        
        // Projects tab
        let projects_splitViewController = tabBarController.viewControllers?[0] as! ProjectsSplitViewController
        let projects_leftNavController = projects_splitViewController.viewControllers.first as! UINavigationController
        let projects_masterViewController = projects_leftNavController.topViewController as! ProjectsTableViewController
        let projects_rightNavController = projects_splitViewController.viewControllers.last as! UINavigationController
        let projects_detailViewController = projects_rightNavController.topViewController as! ProjectDetailsViewController
        projects_masterViewController.delegate = projects_detailViewController
        
        // Competitions tab
        let competitions_splitViewController = tabBarController.viewControllers?[1] as! CompetitionsSplitViewController
        let competitions_leftNavController = competitions_splitViewController.viewControllers.first as! UINavigationController
        let competitions_masterViewController = competitions_leftNavController.topViewController as! CompetitionsTableViewController
        let competitions_rightNavController = competitions_splitViewController.viewControllers.last as! UINavigationController
        let competitions_detailViewController = competitions_rightNavController.topViewController as! CompetitionDetailsViewController
        competitions_masterViewController.delegate = competitions_detailViewController
        
        // Tips tab
        let tips_splitViewController = tabBarController.viewControllers?[2] as! TipsSplitViewController
        let tips_leftNavController = tips_splitViewController.viewControllers.first as! UINavigationController
        let tips_masterViewController = tips_leftNavController.topViewController as! TipsTableViewController
        let tips_rightNavController = tips_splitViewController.viewControllers.last as! UINavigationController
        let tips_detailViewController = tips_rightNavController.topViewController as! TipDetailsViewController
        tips_masterViewController.delegate = tips_detailViewController
        
        // Notifications
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

