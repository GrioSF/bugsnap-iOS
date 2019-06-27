//
//  ShapeEditorScrollView.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/26/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Implementation of a UIScrollView in order to verify whether it should allow the ShapesView to process touches
*/
public class ShapeEditorScrollView: UIScrollView {

    public override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        
        if let shapes = view as? ShapesView {
            return shapes.touchesShouldBegin(touches, with: event)
        }
        return false
    }

}
