//
//  ScrolledViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/27/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    View controller containing a scroll view. The view controller has the content view exposed to allow subclasses to add their own UI elements.
    The scroll view is useful for forms with text fields for dealing with the keyboard occlusion in the fields. The content view can grow vertically.
*/
public class ScrolledViewController: UIViewController {

    // MARK: - UI Properties
    
    /// The scroll view containing all the controls
    var scrollView = UIScrollView()
    
    /// The content view for the UI elements
    var contentView = UIView()
    
    /// The field that should be visible
    var inputField : (UIView&UITextInput)? = nil
    
    /// The bottom constraint for the scroll view
    var bottomConstraint : NSLayoutConstraint? = nil
    
    /// The top constraint for the scroll view
    var topConstraint : NSLayoutConstraint? = nil
    
    /// The original edge insets for the scroll view
    var scrollInsets = UIEdgeInsets()
    
    /// The last rect known for the keyboard
    var lastKeyboardRect : CGRect? = nil
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupScroll()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardNotifications()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollInsets = scrollView.contentInset
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearKeyboardNotifications()
    }
    
    // MARK: - Setup
    
    private func setupScroll() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":scrollView]))
        topConstraint = scrollView.topAnchor.constraint(equalTo: view.topAnchor)
        bottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint?.isActive = true
        topConstraint?.isActive = true
        
        // Setup the content view constraints
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor.clear
        contentView.isUserInteractionEnabled = true
        scrollView.addSubview(contentView)
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":contentView]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":contentView]))
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor).isActive = true
    }
    
    // MARK: - Public method to manually scroll to the corresponding position within the scroll view
    
    /**
        Scrolls this view controller scroll view to a position where the text typed can be seen.
        The method depends on the capture of the last frame for the keyboard.
    */
    public func scrollToVisibleInput() {
        guard let frameEnd = lastKeyboardRect else { return }
        
        if let field = inputField,
            let window  = UIApplication.shared.keyWindow {
            let fieldFrame = window.convert(field.frame, from: field.superview!)
            var offset = fieldFrame.maxY + 10.0 - frameEnd.minY
            
            if let textView = field as? UITextView {

                let rect = textView.layoutManager.boundingRect(forGlyphRange: NSRange(location: 0, length: textView.text.count), in: textView.textContainer)
        
                // In text view we need to deal with the positioning within another scroll view
                offset = fieldFrame.minY + 10.0 + rect.height - textView.contentOffset.y - frameEnd.minY
            }
            
            let scrollViewAvailableHeight = scrollView.bounds.height - scrollInsets.top - scrollInsets.bottom
            let maxContentOffset = max(scrollView.contentSize.height - scrollViewAvailableHeight, 0)
            
            if offset < 0.0 && abs(offset) > scrollView.contentOffset.y {
                offset = -scrollView.contentOffset.y
            }
            let totalOffset = offset + scrollView.contentOffset.y
            
            // If we have an offset greater than maxContentOffset, we need to increase the content insets
            if totalOffset > maxContentOffset {
                UIView.animate(withDuration: 0.3) {
                    self.scrollView.contentInset = UIEdgeInsets(top: self.scrollInsets.top, left: self.scrollInsets.left, bottom: self.scrollInsets.bottom + (totalOffset - maxContentOffset), right: self.scrollInsets.right)
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: totalOffset), animated: false)
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.scrollView.contentInset = self.scrollInsets
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: totalOffset), animated: false)
                }
            }
        }
    }
    
    // MARK: - Setup Keyboard Notifications
    
    private func setupKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillAppear(notification:)),
                                               name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillDissappear(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    private func clearKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Keybaord Notifications
    
    @objc func onKeyboardWillAppear( notification : NSNotification ) {
        guard let userInfo = notification.userInfo,
              let frameEndValue = userInfo[UIWindow.keyboardFrameEndUserInfoKey] as? NSValue
            else {
                return
        }
        lastKeyboardRect = frameEndValue.cgRectValue
        scrollToVisibleInput()
    }

    
    @objc func onKeyboardWillDissappear( notification : NSNotification ) {
        if inputField == nil {
            lastKeyboardRect = nil
            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentInset = self.scrollInsets
            }
        }
    }
}
