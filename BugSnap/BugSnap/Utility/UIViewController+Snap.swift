//
//  UIViewController+Snap.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/11/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import Foundation

/**
    Extension to find the top most view controller that is able to present the UI for the snapshot
*/
public extension UIViewController {
    
    /**
        Returns top most presented view controller that is able to present a view controller.
     
        This property starts with the root view controller and then figures out whether is presenting a view controller,
        and then recursively goes deeper in the hierarchy to find the view controller that is not presenting any view controller.
    */
    static var topMostViewController : UIViewController? {
        get {
            guard let mainWindow = UIApplication.shared.windows.first else { return nil }
            
            var controller : UIViewController? = mainWindow.rootViewController
            
            while controller?.presentedViewController != nil {
                controller = controller?.presentedViewController
            }
            
            return controller
        }
    }
}
