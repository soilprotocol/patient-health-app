//
//  UIViewController+Extensions.swift
//  TAK
//
//  Created by Elliott Brunet on 02.06.19.
//  Copyright © 2019 Elliott Brunet. All rights reserved.
//

import UIKit

// MARK: Init from Storyboard Helpers
public extension UIViewController {

    class func tak_instantiateFromStoryboard() -> Self? {
        return tak_instantiateFromStoryboardForType(self)
    }
    
    fileprivate class func tak_instantiateFromStoryboardForType<T: UIViewController>(_ type: T.Type) -> T? {
        let className = String(describing: type)
        let bundle = Bundle(for: type)
        
        let storyboad = UIStoryboard(name: className, bundle: bundle)
        return storyboad.instantiateInitialViewController() as? T
    }

}

// MARK: - Navigation Bar Helpers
public extension UIViewController {
    
    var tak_navigationBarTopLayoutGuide: UILayoutSupport {
        get {
            if let parentViewController = parent as? UINavigationController {
                return parentViewController.tak_navigationBarTopLayoutGuide
            } else {
                return view.safeAreaLayoutGuide.topAnchor as! UILayoutSupport;
            }
        }
    }

    var tak_navigationBarBottomLayoutGuide: UILayoutSupport {
        get {
            if let parentViewController = parent as? UINavigationController {
                return parentViewController.tak_navigationBarBottomLayoutGuide
            } else {
                return view.safeAreaLayoutGuide.bottomAnchor as! UILayoutSupport
            }
        }
    }
    
}

