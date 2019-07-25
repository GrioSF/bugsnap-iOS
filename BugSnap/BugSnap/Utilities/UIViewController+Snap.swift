//
//  UIViewController+Snap.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/11/19.
//  Copyright © 2019 Grio. All rights reserved.
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
    
    /**
        Presents a loading view controller with a message. This view controller can later be updated with a new text.
        The view controller won't be dismissed until the calling view dismisses it explicitly. The view controller is presented over the current context,
        so it won't trigger the viewWillDisappear methods
        - Parameter message: The message to present while the loading operation takes place. It defaults to "Loading..."
        - Returns: An instance of the LoadingViewController created for preventing user input.
    */
    func presentLoading( message : String = "Loading...") -> LoadingViewController {
        let controller = LoadingViewController()
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        controller.message = message
        present(controller, animated: true, completion: nil)
        return controller
    }
    
    /**
        Present the connection errors as an alert. The errors are a series of strings coming from the server or the underlying infrastructure.
        The alert action is presented in this view controller and it has only a button for dismiss the message box.
        - Parameter errors: The errors found during the network interaction
        - Parameter title: A title for the alert message (the default is ""The following errors were found:")
        - Parameter button: The title for the only button in this alert message. The default value is "Ok"
        - Parameter retry: The block to be invoked if we want to retry the operation
        - Parameter completion: The handler when the alert is dismissed
     */
    func presentOperationErrors( errors : [String], title : String = "The following errors were found:", button : String = "Ok", retry : (()->Void)? = nil, completion : (()->Void)? = nil )  {
        
        var messageString = String()
        errors.forEach {
            messageString.append($0)
            messageString.append("\n")
        }
        let controller = UIAlertController(title: title, message: messageString, preferredStyle: .alert)
        
        if retry != nil {
            controller.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (_) in
                retry?()
            }))
        }
        
        controller.addAction(UIAlertAction(title: button, style: .default, handler: {
            (_) in
            completion?()
        }))
        
        present(controller, animated: true, completion: nil)
    }

}
