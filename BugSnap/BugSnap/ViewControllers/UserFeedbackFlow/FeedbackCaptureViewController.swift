//
//  FeedbackCaptureViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 8/22/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit
import AVFoundation

/**
    View controller to show a briefing about the issue to be reported.
    Notice this view controller sends the data to the system for feedback and does the attachment of the screenshot.
*/
public class FeedbackCaptureViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    // MARK: - UI Elements
    
    /// The attachment that was captured during the preview
    @objc public var snapshot : UIImage? = nil
    
    /// The URL for the video attachment that was captrued during the preview
    @objc public var videoURL : URL? = nil
    
    // MARK: - Constants
    
    /// The spacing in the horizontal axis
    private let horizontalMargin : CGFloat = 10.0
    
    // MARK: - Card UI
    
    /// The container for the UI elements
    private var card = UIView()
    
    /// The title label for the card
    private var titleLabel = UILabel()
    
    /// The summary field
    private var summaryField = UITextField()
    
    /// The description field
    private var descriptionField = UITextView()
    
    /// The placeholder for the textview
    private var placeholder = UILabel()
    
    /// The attachment disclosure
    private var attachmentDisclosure = UILabel()
    
    /// The attachment title
    private var snapshotButton = UIImageView()
    
    /// The send button
    private var sendButton = UIButton(type: .custom)
    
    /// Whether is this the first time we show the screen
    private var isFirstTime = true
    
    /// The issue creator
    private var issueCreator : JIRAIssueCreator? = nil
    
    /// The video player layer for playing back the video
    private var videoPlayerLayer : AVPlayerLayer? = nil
    
    // MARK: - Deinitialization
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - View LifeCycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateCardEntry()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update the bounds for the video player layer
        videoPlayerLayer?.bounds = snapshotButton.bounds
    }
    
    // MARK: - Animate card
    
    private func animateCardEntry() {
        guard isFirstTime else {
            return
        }
        isFirstTime = false
        card.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        card.isHidden = false
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: [.beginFromCurrentState,.curveEaseInOut], animations: {
            self.card.transform = CGAffineTransform.identity
            self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        }, completion: { (_) in
            // Update the bounds for the video player layer
            self.videoPlayerLayer?.bounds = self.snapshotButton.bounds
        })
    }
    
    private func animateCardDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.beginFromCurrentState,.curveEaseInOut], animations: {
            self.card.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        }) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Setup
    
    private func setup() {
        view.backgroundColor = UIColor.clear
        setupContainer()
        setupTitle()
        setupButtons()
        setupSeparator()
        setupSummaryField()
        setupAttachment()
        setupDescriptionField()
        card.isHidden = true
    }
    
    private func setupContainer() {
        card.backgroundColor = UIColor.white
        card.cornerRadius = 10.0
        card.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(card)
        card.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5.0).isActive = true
        card.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        card.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        card.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
    }
    
    private func setupTitle() {
        titleLabel.text = "What happened?"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 10.0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: horizontalMargin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -horizontalMargin).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }
    
    private func setupButtons() {
        let backButton = ChevronLeftButton()
        backButton.pathFillColor = UIColor(red: 55, green: 123, blue: 246)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(backButton)
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: horizontalMargin).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        backButton.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor( UIColor(red: 55, green: 123, blue: 246), for: .normal)
        sendButton.setTitleColor(UIColor.lightGray.withAlphaComponent(0.6), for: .disabled)
        sendButton.addTarget(self, action: #selector(onSend), for: .primaryActionTriggered)
        sendButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14.0)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.isEnabled = false
        
        card.addSubview(sendButton)
        sendButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 40.0).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -horizontalMargin).isActive = true
    }
    
    private func setupSeparator() {
        let sectionSeparator = UIView()
        sectionSeparator.backgroundColor = UIColor.lightGray
        sectionSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(sectionSeparator)
        sectionSeparator.leadingAnchor.constraint(equalTo: card.leadingAnchor).isActive = true
        sectionSeparator.trailingAnchor.constraint(equalTo: card.trailingAnchor).isActive = true
        sectionSeparator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        sectionSeparator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0).isActive = true
    }
    
    private func setupSummaryField() {
        summaryField.textAlignment = .left
        summaryField.font = UIFont(name: "HelveticaNeue", size: 16.0)
        summaryField.textColor = UIColor.black
        summaryField.translatesAutoresizingMaskIntoConstraints = false
        summaryField.delegate = self
        summaryField.placeholder = "Add an explanation"
        summaryField.returnKeyType = .continue
        
        card.addSubview(summaryField)
        summaryField.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: horizontalMargin).isActive = true
        summaryField.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -horizontalMargin).isActive = true
        summaryField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0).isActive = true
        summaryField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }
    
    private func setupDescriptionField() {
        descriptionField.textAlignment = .left
        descriptionField.font = UIFont(name: "HelveticaNeue", size: 12.0)
        descriptionField.textColor = UIColor.black
        descriptionField.translatesAutoresizingMaskIntoConstraints = false
        descriptionField.delegate = self
        descriptionField.cornerRadius = 8.0
        descriptionField.borderWidth = 1.0
        descriptionField.borderColor = UIColor.lightGray
        
        
        placeholder.text = "In a few words, describe the situation in more detail."
        placeholder.font = UIFont(name: "HelveticaNeue", size: 12.0)
        placeholder.textColor = UIColor.gray
        placeholder.textAlignment = .left
        placeholder.numberOfLines = 0
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.lineBreakMode = .byWordWrapping
        descriptionField.addSubview(placeholder)
        
        placeholder.leadingAnchor.constraint(equalTo: descriptionField.leadingAnchor, constant: 5.0).isActive = true
        placeholder.topAnchor.constraint(equalTo: descriptionField.topAnchor, constant: 8.0).isActive = true
        placeholder.widthAnchor.constraint(equalTo: descriptionField.widthAnchor, multiplier: 0.7, constant: 0.0).isActive = true
        
        card.addSubview(descriptionField)
        descriptionField.leadingAnchor.constraint(equalTo: snapshotButton.trailingAnchor, constant: 40.0).isActive = true
        descriptionField.trailingAnchor.constraint(equalTo: attachmentDisclosure.trailingAnchor).isActive = true
        descriptionField.topAnchor.constraint(equalTo: snapshotButton.topAnchor).isActive = true
        descriptionField.bottomAnchor.constraint(equalTo: snapshotButton.bottomAnchor).isActive = true
    }
    
    private func setupAttachment() {
        
        let attachmentTitle = UILabel()
        attachmentTitle.text = "Attachments"
        attachmentTitle.textAlignment = .left
        attachmentTitle.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        attachmentTitle.textColor = UIColor.black
        attachmentTitle.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(attachmentTitle)
        attachmentTitle.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: horizontalMargin).isActive = true
        attachmentTitle.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -horizontalMargin).isActive = true
        attachmentTitle.topAnchor.constraint(equalTo: summaryField.bottomAnchor, constant: 10.0).isActive = true
        attachmentTitle.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        snapshotButton.cornerRadius = 5.0
        snapshotButton.borderColor = UIColor.lightGray
        snapshotButton.borderWidth = 1.0
        snapshotButton.contentMode = .scaleAspectFill
        snapshotButton.clipsToBounds = true
        snapshotButton.translatesAutoresizingMaskIntoConstraints = false
        snapshotButton.isUserInteractionEnabled = true
        setupCaptureThumbnail()
        
        card.addSubview(snapshotButton)
        let aspect = UIScreen.main.bounds.height / UIScreen.main.bounds.width
        snapshotButton.widthAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.2).isActive = true
        snapshotButton.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: horizontalMargin).isActive = true
        snapshotButton.topAnchor.constraint(equalTo: attachmentTitle.bottomAnchor, constant: 5.0).isActive = true
        snapshotButton.heightAnchor.constraint(equalTo: snapshotButton.widthAnchor, multiplier: aspect).isActive = true
        
        attachmentDisclosure.text = "Information about your device and this app will be included automatically in this report."
        attachmentDisclosure.numberOfLines = 0
        attachmentDisclosure.font = UIFont(name: "HelveticaNeue", size: 12.0)
        attachmentDisclosure.textColor = UIColor.lightGray
        attachmentDisclosure.textAlignment = .left
        attachmentDisclosure.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(attachmentDisclosure)
        attachmentDisclosure.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: horizontalMargin).isActive = true
        attachmentDisclosure.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -horizontalMargin).isActive = true
        attachmentDisclosure.topAnchor.constraint(equalTo: snapshotButton.bottomAnchor, constant: 10.0).isActive = true
        attachmentDisclosure.bottomAnchor.constraint(lessThanOrEqualTo: card.bottomAnchor, constant: -10.0).isActive = true
    }
    
    private func setupCaptureThumbnail() {
        
        guard let url = videoURL else {
            setupSnapshot(image: snapshot! )
            return
        }
        setupVideo(url: url)
    }
    
    private func setupSnapshot( image : UIImage ) {
        snapshotButton.image = image
        let tap = UITapGestureRecognizer(target: self, action: #selector(onSnapshot))
        snapshotButton.addGestureRecognizer(tap)
    }
    
    private func setupVideo( url : URL ) {
        let videoPlayer = AVPlayer(url: url)
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        snapshotButton.layer.addSublayer(videoPlayerLayer!)
        videoPlayerLayer?.bounds = snapshotButton.bounds
        videoPlayerLayer?.videoGravity = .resizeAspectFill
        videoPlayerLayer?.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onToggleVideoPlayBack))
        snapshotButton.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(onVideoStopped(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    // MARK: - UICallback
    
    @objc func onSnapshot() {
        let snapController = MarkupEditorViewController()
        snapController.screenSnapshot = snapshot
        let navigationController = IrisTransitioningNavigationController(rootViewController: snapController)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            navigationController.modalPresentationStyle = .formSheet
        }
        snapController.shouldDisplayShare = false
        snapController.view.backgroundColor = UIColor.black
        snapController.onEditionFinished = {
            [weak self] (newImage) in
            self?.snapshot = newImage
            self?.snapshotButton.image = newImage
            self?.dismiss(animated: true, completion: nil)
        }
        present(navigationController, animated: true, completion: nil)
                
    }
    
    @objc func onToggleVideoPlayBack() {
        
        if videoPlayerLayer?.player?.rate ?? 0 > 0.0 {
            videoPlayerLayer?.player?.pause()
        } else {
            videoPlayerLayer?.player?.play()
        }
    }
    
    @objc func onBack() {
        animateCardDismiss()
    }
    
    @objc func onSend() {
        view.endEditing(true)
        issueCreator = JIRAIssueCreator()
        issueCreator?.viewController = self
        issueCreator?.createIssue(text: summaryField.text ?? "", description: descriptionField.text ?? "", snapshot: snapshot!)
    }
    
    // MARK: - UITextViewDelegate
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let mutableString = NSMutableString(string: textField.text ?? "")
        mutableString.replaceCharacters(in: range, with: string)
        sendButton.isEnabled = placeholder.isHidden && (summaryField.text?.count ?? 0) > 0
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionField.becomeFirstResponder()
        return true
    }
    
    // MARK: - UITextViewDelegate
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let mutableString = NSMutableString(string: textView.text)
        mutableString.replaceCharacters(in: range, with: text)
        placeholder.isHidden = mutableString.length > 0
        sendButton.isEnabled = placeholder.isHidden && (summaryField.text?.count ?? 0) > 0
        return true
    }
    
    // MARK: - Notifications
    
    @objc func onVideoStopped( notification : Notification ) {
        let scale = CMTimeScale(100.0)
        videoPlayerLayer?.player?.seek(to: CMTime(seconds: 0.0, preferredTimescale: scale), completionHandler: { (_) in })
    }
}
