//
//  Extensions.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 08/12/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func showInfo(withTitle: String = "Info", withMessage: String, action: (() -> Void)? = nil) {
        performUIUpdatesOnMain {
            let ac = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alertAction) in
                action?()
            }))
            self.present(ac, animated: true)
        }
    }
    
    
    //https://stackoverflow.com/questions/25945324/swift-open-link-in-safari
    func openLink(_ url: String) {
        guard let url = URL(string: url) else {
            showInfo(withMessage: "Link failed to load.")
            return
        }
        UIApplication.shared.open(url)
    }
    
}

extension Notification.Name {
    static let reload = Notification.Name("reload")
    static let startMapReload = Notification.Name("reloadStarted")
    static let reloadMapCompleted = Notification.Name("reloadCompleted")
}


