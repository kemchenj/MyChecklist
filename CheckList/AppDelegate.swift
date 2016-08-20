//
//  AppDelegate.swift
//  CheckList
//
//  Created by kemchenj on 4/16/16.
//  Copyright © 2016 kemchenj. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataModel = DataModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        
        // Get The Controller in oreder to Save Data
        let navigationController = window!.rootViewController as! UINavigationController
        let controller = navigationController.viewControllers[0] as! AllListTableViewController

        controller.dataModel = dataModel
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveData()
    }


    func saveData() {
        dataModel.saveChecklists()
    }
}

