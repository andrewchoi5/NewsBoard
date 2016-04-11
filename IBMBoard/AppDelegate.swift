//
//  AppDelegate.swift
//  IBMBoard
//
//  Created by Zamiul Haque on 2016-02-18.
//  Copyright © 2016 Zamiul Haque. All rights reserved.
//

import UIKit
import WebKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        UITabBar.appearance().barTintColor = UIColor(red: 36.0 / 255.0, green: 40.0 / 255.0, blue: 46.0 / 255.0, alpha: 1.0)
        UIToolbar.appearance().backgroundColor = UIColor(red: 36.0 / 255.0, green: 40.0 / 255.0, blue: 46.0 / 255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor(red: 36.0 / 255.0, green: 40.0 / 255.0, blue: 46.0 / 255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [
        
            NSForegroundColorAttributeName: UIColor.whiteColor()
        
        ]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(UINavigationBar.appearance().titleTextAttributes, forState: .Normal)
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()

        // Credentials
        let APIKey = "llyespecietwersimartayth"
        let APIPassword = "26acdf29a791400f22b4e3e7df556d52eda31f82"
        let APIHost = "b66668a3-bd4d-4e32-88cc-eb1e0bff350b-bluemix.cloudant.com"

        let APIRealm = "Cloudant Private Database"
        
        // Network Layer Specifics
        let APIPort = 443
        let APIProtocol = NSURLProtectionSpaceHTTPS
        let APIAuthenticationMethod = NSURLAuthenticationMethodHTTPBasic
        
        // Add key to local storage
        NSURLCredentialStorage.sharedCredentialStorage().setCredential(NSURLCredential(user: APIKey, password: APIPassword, persistence: .ForSession), forProtectionSpace: NSURLProtectionSpace(host: APIHost, port: APIPort, protocol: APIProtocol, realm: APIRealm, authenticationMethod: APIAuthenticationMethod))
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

