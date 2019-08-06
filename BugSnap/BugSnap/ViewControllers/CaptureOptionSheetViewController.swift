//
//  CaptureOptionSheetViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 8/5/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Implementation of an option sheet presenting different options and a cancel option.
*/
class CaptureOptionSheetViewController: UIViewController {
    
    
    enum OptionSelected {
        case screenshot
        case screenrecording
        case cancel
        case none
    }

    /// The corner radius for the options
    private let cornerRadiusUI : CGFloat = 8.0
    
    /// The option selected
    private var optionSelected : OptionSelected = .none
    
    /// The handler when the option has been selected
    var optionSelectionHandler : ((OptionSelected)->Void)? = nil
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Call the handler and then clear the option selected
        if optionSelected != .none {
            optionSelectionHandler?(optionSelected)
            optionSelected = .none
        }
    }
    
    
    // MARK: - Options creation
    
    private func setup() {
        let options = setupOptions()
        options.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(options)
        options.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        options.heightAnchor.constraint(equalToConstant: 120.0).isActive = true
        options.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let cancelButton = UIButton()
        cancelButton.backgroundColor = UIColor.white
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        cancelButton.setTitleColor(UIColor(red: 49, green: 113, blue: 246), for: .normal)
        cancelButton.cornerRadius = cornerRadiusUI
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(onCancel), for: .primaryActionTriggered)
        
        view.addSubview(cancelButton)
        cancelButton.centerXAnchor.constraint(equalTo: options.centerXAnchor).isActive = true
        cancelButton.widthAnchor.constraint(equalTo: options.widthAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0).isActive = true
        options.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10.0).isActive = true
        
    }
    
    private func setupOptions() -> UIView {
        let optionsContainer = UIView()
        optionsContainer.cornerRadius = cornerRadiusUI
        optionsContainer.backgroundColor = UIColor.clear
        
        let screenshotButton = setupOption(label: "Screenshot", icon : ScreenshotButton())
        screenshotButton.addTarget(self, action: #selector(onScreenshot), for: .touchUpInside)
        optionsContainer.addSubview(screenshotButton)
        screenshotButton.heightAnchor.constraint(equalTo: optionsContainer.heightAnchor, multiplier: 0.5, constant: -1.0).isActive = true
        screenshotButton.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor).isActive = true
        screenshotButton.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor).isActive = true
        screenshotButton.topAnchor.constraint(equalTo: optionsContainer.topAnchor).isActive = true
        
        
        let recordingButton = setupOption(label: "Screen Recording", icon: ScreenRecordingButton())
        recordingButton.addTarget(self, action: #selector(onScreenRecording), for: .touchUpInside)
        optionsContainer.addSubview(recordingButton)
        recordingButton.heightAnchor.constraint(equalTo: optionsContainer.heightAnchor, multiplier: 0.5, constant: -1.0).isActive = true
        recordingButton.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor).isActive = true
        recordingButton.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor).isActive = true
        recordingButton.bottomAnchor.constraint(equalTo: optionsContainer.bottomAnchor).isActive = true
        
        return optionsContainer
    }
    
    private func setupOption( label text : String, icon : PathBasedButton ) -> UIControl {
        let sheetOption = UIControl()
        sheetOption.backgroundColor = UIColor.white
        sheetOption.translatesAutoresizingMaskIntoConstraints = false
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.pathFillColor = UIColor(red: 49, green: 113, blue: 246)
        sheetOption.addSubview(icon)
        icon.centerYAnchor.constraint(equalTo: sheetOption.centerYAnchor).isActive = true
        icon.leadingAnchor.constraint(equalTo: sheetOption.leadingAnchor, constant: 30.0).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        sheetOption.addSubview(label)
        label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 20.0).isActive = true
        label.centerYAnchor.constraint(equalTo: sheetOption.centerYAnchor).isActive = true
        
        return sheetOption
    }
    
    // MARK: - UICallback
    
    @objc func onCancel() {
        optionSelected = .cancel
        dismissAnimated()
    }
    
    @objc func onScreenshot() {
        optionSelected = .screenshot
        dismissAnimated()
    }
    
    @objc func onScreenRecording() {
        optionSelected = .screenrecording
        dismissAnimated()
    }
    
    // MARK: - Support animation
    
    private func dismissAnimated() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        }) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
    }
}
