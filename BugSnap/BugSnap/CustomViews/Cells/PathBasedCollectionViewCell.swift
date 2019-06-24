//
//  PathBasedCollectionViewCell.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/14/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Implementation of a custom collection view cell that contains an instance of a PathBasedButton.
    The shape in the path based button allows to setup certain graphic properties that will be displayed and selected accordingly
*/
public class PathBasedCollectionViewCell: UICollectionViewCell {
    
    
    // MARK: - Exposed properties
    
    /// The shape used for displaying the button
    var shape : PathBasedButton? = nil
    
    // MARK: - Convenience Methods
    
    /**
        Initializes this collection view cell with the button type given in the argument
        This method initia
    */
    func setup( buttonType : PathBasedButton.Type ) {
        
        shape?.removeFromSuperview()
        
        /// Initialize the button
        shape = buttonType.init()
        shape!.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(shape!)
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[shape]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["shape":shape!]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[shape]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["shape":shape!]))
        shape?.isUserInteractionEnabled = false
    }
    
}
