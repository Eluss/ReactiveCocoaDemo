//
//  AppDelegate.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainNavigationController: UINavigationController!
    var mainFlowController: MainFlowController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        mainNavigationController = UINavigationController()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = mainNavigationController
        window?.makeKeyAndVisible()
        
        mainFlowController = MainFlowController(rootNavigationController: mainNavigationController)
        mainFlowController.startFlow()
        
        return true
    }

}

