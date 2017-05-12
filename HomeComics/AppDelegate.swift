//
//  AppDelegate.swift
//  HomeComics
//
//  Created by Jean Sarda on 15/03/2017.
//  Copyright © 2017 Jean Sarda. All rights reserved.
//

import UIKit
import Chameleon

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
 
        let defaults = UserDefaults.standard
        self.setupUserDefaults(defaults)
        self.initTheme(defaults)
        return true
    }
    
    func initTheme(_ defaults: UserDefaults) {
        let primaryHex = defaults.string(forKey: "primaryColor")
        let primaryColor = UIColor(hexString: primaryHex)
        let secondaryHex = defaults.string(forKey: "secondaryColor")
        if secondaryHex != "none" {
            let secondaryColor = UIColor(hexString: secondaryHex)
            Chameleon.setGlobalThemeUsingPrimaryColor(primaryColor, withSecondaryColor: secondaryColor, andContentStyle: .contrast)
        } else {
            Chameleon.setGlobalThemeUsingPrimaryColor(primaryColor, with: .contrast)
        }
        UIButton.appearance(whenContainedInInstancesOf: [UITableView.self]).backgroundColor = UIColor.clear
    }
    
    private func setupUserDefaults(_ defaults: UserDefaults) {
        if defaults.object(forKey: "ramCache") == nil {
            defaults.set(128, forKey: "ramCache")
        }
        if defaults.object(forKey: "diskCache") == nil {
            defaults.set(512, forKey: "diskCache")
        }
        if defaults.object(forKey: "coverCache") == nil {
            defaults.set(128, forKey: "coverCache")
        }
        if defaults.object(forKey: "downloadPriority") == nil {
            defaults.set(true, forKey: "downloadPriority") // true:fifo, false:lifo
        }
        if defaults.object(forKey: "serverBaseURL") == nil {
            defaults.set("http://127.0.0.1:1337/", forKey: "serverBaseURL")
        }
        if defaults.object(forKey: "cdnBaseURL") == nil {
            defaults.set("http://127.0.0.1:8080/", forKey: "cdnBaseURL")
        }
        if defaults.object(forKey: "primaryColor") == nil {
            defaults.set(UIColor.flatBlueColorDark().hexValue(), forKey: "primaryColor")
        }
        if defaults.object(forKey: "secondaryColor") == nil {
            defaults.set("none", forKey: "secondaryColor")
        }
        if defaults.integer(forKey: "booksPerRow") == 0 {
            defaults.set(3, forKey: "booksPerRow")
        }
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

