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
            let shouldBeingInShapesView = shapes.touchesShouldBegin(touches, with: event)
            let textViews = shapes.subviews.filter {
                if let textView = $0 as? UITextView {
                    return textView.isFirstResponder
                }
                return false
            }
            if let textView = textViews.first as? UITextView {
                textView.resignFirstResponder()
            }
            return shouldBeingInShapesView
        } else if let textView = view as? UITextView {
            return textView.isFirstResponder
        }
        return false
    }

}
