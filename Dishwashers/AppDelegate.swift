//  Copyright © 2019 Software101. All rights reserved.

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        customizeAppearance()
        return true
    }

    // MARK: - App Theme Customization

    private func customizeAppearance() {
        window?.tintColor = UIColor.uiTint
        UISearchBar.appearance().barTintColor = UIColor.uiTint
        UINavigationBar.appearance().barTintColor = UIColor.uiTint
        UINavigationBar.appearance().tintColor = UIColor.textDefault
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.textDefault]
    }
}
