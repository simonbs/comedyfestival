//
//  AppDelegate.swift
//  ComedyFestival
//
//  Created by Simon Støvring on 24/07/2017.
//  Copyright © 2017 SimonBS. All rights reserved.
//

import UIKit
import ComedyFestivalKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let appSession = createAppSession()
        let scheduleViewController = ScheduleViewController(appSession: appSession)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = NavigationController(rootViewController: scheduleViewController)
        window?.makeKeyAndVisible()
        return true
    }
    
    func createAppSession() -> AppSession {
        do {
            let config = try Config()
            let scraperClient = ScraperClient(baseURL: config.comedyFestivalAPIBaseURL)
            return AppSession(scraperClient: scraperClient)
        } catch {
            fatalError("Could not launch app. Make sure that you have copied ComedyFestival/Config.temp.plist to ComedyFestival/Config.plist and filled out missing values for the properties.\n\nUnderlying error:\n\(error)")
        }
    }
}

