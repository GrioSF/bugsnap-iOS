//
//  FeedbackCardViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 8/20/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    View controller presented at the bottom of the screen letting the user know it can report an issue about the app.
*/
public class FeedbackCardViewController: UIViewController {
    
    // MARK: - Exposed Properties
    
    /// The attachment that was captured during the preview
    @objc public var snapshot : UIImage? = nil
    
    // MARK: - Constants
    
    /// The spacing in the horizontal axis
    private let horizontalMargin : CGFloat = 10.0
    
    // MARK: - Card UI
    
    /// The container for the UI elements
    private var card = UIView()
    
    /// The top constraint for the card
    private var cardTop : NSLayoutConstraint!
    
    /// The title label for the card
    private var titleLabel = UILabel()
    
    /// The subtitle label for the card
    private var subtitleLabel = UILabel()
    
    /// A separator between sections
    private var sectionSeparator = UIView()
    
    /// The separator
    
    // MARK:

    // MARK: - UIView Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareCardEntry()
    }
    
    // MARK: - Animate card entry
    
    private func prepareCardEntry() {
        cardTop.constant = view.bounds.height * 0.5
        view.setNeedsLayout()
        view.layoutIfNeeded()
        DispatchQueue.main.async {
            self.animateCardEntry()
        }
    }
    
    private func animateCardEntry() {
        card.transform = CGAffineTransform(translationX: 0.0, y: card.bounds.height)
        card.isHidden = false
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: [.beginFromCurrentState,.curveEaseInOut], animations: {
            self.card.transform = CGAffineTransform.identity
            self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        }, completion: nil)
    }
    
    // MARK: - Setup
    
    private func setup() {
        view.backgroundColor = UIColor.clear
        setupContainer()
        setupTitle()
        setupSubtitle()
        setupSeparator()
        setupReportButton()
        card.isHidden = true
    }
    
    private func setupContainer() {
        card.backgroundColor = UIColor.white
        card.cornerRadius = 10.0
        card.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(card)
        cardTop = card.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0.0)
        cardTop.isActive = true
        card.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        card.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        card.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10.0).isActive = true
    }
    
    private func setupTitle() {
        titleLabel.text = "Report a Problem"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 10.0).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: card.safeAreaLayoutGuide.leadingAnchor, constant: horizontalMargin).isActive = true
        titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: card.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalMargin).isActive = true
    }
    
    private func setupSubtitle() {
        subtitleLabel.text = "Your comments help us to improve \(UIApplication.shared.appName)."
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor.gray
        subtitleLabel.font = UIFont(name: "HelveticaNeue", size: 14.0)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(subtitleLabel)
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0).isActive = true
        subtitleLabel.centerXAnchor.constraint(equalTo: card.centerXAnchor).isActive = true
        subtitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: card.safeAreaLayoutGuide.leadingAnchor, constant: horizontalMargin).isActive = true
        subtitleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: card.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalMargin).isActive = true
    }
    
    private func setupSeparator() {
        sectionSeparator.backgroundColor = UIColor.lightGray
        sectionSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(sectionSeparator)
        sectionSeparator.leadingAnchor.constraint(equalTo: card.safeAreaLayoutGuide.leadingAnchor, constant:  horizontalMargin).isActive = true
        sectionSeparator.trailingAnchor.constraint(equalTo: card.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalMargin).isActive = true
        sectionSeparator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        sectionSeparator.centerYAnchor.constraint(equalTo: card.centerYAnchor).isActive = true
    }

    private func setupReportButton() {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsTouchWhenHighlighted = true
        
        card.addSubview(button)
        button.leadingAnchor.constraint(equalTo: card.safeAreaLayoutGuide.leadingAnchor, constant:  horizontalMargin).isActive = true
        button.trailingAnchor.constraint(equalTo: card.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalMargin).isActive = true
        button.topAnchor.constraint(equalTo: sectionSeparator.bottomAnchor, constant: 10.0).isActive = true
        
        // Setup the labels for the button
        let exclamation = UILabel()
        exclamation.text = "!"
        exclamation.textAlignment = .center
        exclamation.cornerRadius = 3.0
        exclamation.borderWidth = 1.0
        exclamation.borderColor = UIColor.black
        exclamation.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        exclamation.textColor = UIColor.black
        exclamation.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(exclamation)
        exclamation.leadingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
        exclamation.topAnchor.constraint(equalTo: button.topAnchor, constant: 10.0).isActive = true
        exclamation.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -10.0).isActive = true
        exclamation.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        exclamation.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        let message = UILabel()
        message.text = "Something is wrong"
        message.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        message.textColor = UIColor.black
        message.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(message)
        message.leadingAnchor.constraint(equalTo: exclamation.trailingAnchor, constant: 10.0).isActive = true
        message.centerYAnchor.constraint(equalTo: exclamation.centerYAnchor).isActive = true
        
        button.addTarget(self, action: #selector(onReport), for: .touchUpInside)
    }
    
    // MARK: - UICallback
    
    @objc func onReport() {
        let presentingController = presentingViewController
        let controller = FeedbackCaptureViewController()
        controller.snapshot = snapshot
        controller.modalPresentationStyle = .overCurrentContext
        dismiss(animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                presentingController?.present(controller, animated: true, completion: nil)
            })
        }
    }

}
