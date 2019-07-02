//
//  ToolbarSelectableButton.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/26/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

public class ToolbarSelectableButton: PathBasedButton {
    
    /// Sets the path fill color depending on the current selection state
    public override var isSelected: Bool {
        didSet {
            pathFillColor = isSelected ? UIColor.white : UIColor(red: 148, green: 148, blue: 148)
        }
    }
}
