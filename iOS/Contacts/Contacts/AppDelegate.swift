//
//  AppDelegate.swift
//  Contacts
//
//  Created by Andrei Coder on 17.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var coordinator: MainCoordinator?
  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    /// Create the main navigation controller to be used for our app
    let nc = UINavigationController()
    
    /// Send that into our coordinator so that it can display view controllers
    coordinator = MainCoordinator(navigationController: nc)
    
    /// Tell the coordinator to take over control
    coordinator?.start()
    
    /// Create a basic UIWindow and activate it
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = nc
    window?.makeKeyAndVisible()
    
    return true
  }

}

