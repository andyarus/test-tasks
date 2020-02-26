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

//    window = UIWindow(frame: UIScreen.main.bounds)
//    let vc = ContactsViewController()
//    vc.viewModel = ContactsViewModel()
//    let nc = UINavigationController(rootViewController: vc)
//    window?.rootViewController = nc
//    window?.makeKeyAndVisible()
    
    
    
    // create the main navigation controller to be used for our app
    let nc = UINavigationController()
    
    // send that into our coordinator so that it can display view controllers
    coordinator = MainCoordinator(navigationController: nc)
    
    // tell the coordinator to take over control
    coordinator?.start()
    
    // create a basic UIWindow and activate it
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = nc
    window?.makeKeyAndVisible()
    
    return true
  }

}

