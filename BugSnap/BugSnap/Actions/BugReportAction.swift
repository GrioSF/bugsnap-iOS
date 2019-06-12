//
//  BugReportAction.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/11/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

class BugReportAction: NSObject, BugSnapAction {

    // MARK: - BugSnapAction
    
    /// The bug repor requires to capture a screen shot
    var requiresSnapshot: Bool { return true }
    
    /// Since we're presenting a view controller we require to be executed in the main thread
    var executeInMainThread: Bool { return true }
    
    /**
        The presentation for the bug report
    */
    func perform(snapshot: UIImage?) {
        
    }
}
