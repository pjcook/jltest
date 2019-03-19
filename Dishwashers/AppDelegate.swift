//
//  AppDelegate.swift
//  Dishwashers
//
//  Created by PJ COOK on 15/03/2019.
//  Copyright © 2019 Software101. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        customizeAppearance()
        return true
    }
    
    // MARK:- App Theme Customization
    private func customizeAppearance() {
        window?.tintColor = UIColor.uiTint
        UISearchBar.appearance().barTintColor = UIColor.uiTint
        UINavigationBar.appearance().barTintColor = UIColor.uiTint
        UINavigationBar.appearance().tintColor = UIColor.textDefault
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.textDefault]
    }
}

