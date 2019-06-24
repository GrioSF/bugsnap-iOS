//
//  PathBasedTableViewCell.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/14/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

class PathBasedTableViewCell: UITableViewCell {

    // MARK: - Exposed properties
    
    /// The shape used for displaying the button
    var shape : PathBasedButton? = nil
    
    /// The padding for the content
    var padding : CGFloat = 0
    
    // MARK: - Convenience Methods
    
    /**
     Initializes this collection view cell with the button type given in the argument
     This method initia
     */
    func setup( buttonType : PathBasedButton.Type ) {
        
        shape?.removeFromSuperview()
        
        backgroundColor = UIColor.clear
        backgroundView = UIView()
        backgroundView?.backgroundColor = UIColor.clear
        
        /// Initialize the button
        shape = buttonType.init()
        shape!.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(shape!)
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[shape]-(padding)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: ["padding":NSNumber(floatLiteral: Double(padding))], views: ["shape":shape!]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(padding)-[shape]-(padding)-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: ["padding":NSNumber(floatLiteral: Double(padding))], views: ["shape":shape!]))
        shape!.isUserInteractionEnabled = false
    }
}
