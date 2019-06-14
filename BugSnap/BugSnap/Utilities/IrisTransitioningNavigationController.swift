//
//  IrisTransitioningNavigationController.swift
//  My Math Helper
//
//  Created by Héctor García Peña on 6/6/19.
//  © 2019 Grio All rights reserved.
//

import UIKit

class IrisAnimationTransitioning : NSObject, UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Properties
    
    /// The duration for the transitions
    var animationDuration : TimeInterval = 0.5
    
    /// The operaton while transitioning view controllers
    var operation : UINavigationController.Operation = .none
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let fromView = (operation == .push ? transitionContext.view(forKey: .from) : transitionContext.view(forKey: .to))!
        let toView = (operation == .push ? transitionContext.view(forKey: .to) : transitionContext.view(forKey: .from ))!
        
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
        
        container.addSubview(fromView)
        container.addSubview(toView)
        
        if operation == .push {
            toView.irisOpen(duration: animationDuration) { (finished) in
                transitionContext.completeTransition(finished)
            }
        } else {
            toView.irisClose(duration: animationDuration) { (finished) in
                transitionContext.completeTransition(finished)
            }
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.operation = operation
        return self
    }
}

/**
    This view controller implements animated transitions as an iris open/close
*/
class IrisTransitioningNavigationController: UINavigationController  {

    ///  The transitioning delegate
    let transitioning = IrisAnimationTransitioning()
   
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = transitioning
    }
    
    
}
