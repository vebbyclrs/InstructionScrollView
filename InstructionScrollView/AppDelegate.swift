//
//  AppDelegate.swift
//  InstructionScrollView
//
//  Created by Vebby Clarissa on 29/11/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.self.window = UIWindow(frame: UIScreen.main.bounds)
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()

        return true
    }

    


}

