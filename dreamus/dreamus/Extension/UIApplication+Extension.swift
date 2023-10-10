//
//  UIApplication+Extension.swift
//  dreamus
//
//  Created by USER on 2023/10/10.
//

import UIKit

extension UIApplication {
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow()?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    
    func keyWindow() -> UIWindow? {
        return (connectedScenes.first as? UIWindowScene)?.windows.filter { $0.isKeyWindow }.first
    }
}
