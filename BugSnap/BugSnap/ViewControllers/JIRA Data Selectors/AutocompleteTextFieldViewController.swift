//
//  AutocompleteTextFieldViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/21/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    View controller that presents up to three options while the user is typing, allowing
    to select an option like auto complete. When the user selects the option, the text field sets its text to the name
    of the field and then calls a delegate method (through a closure) with the value selected.
    When the user resigns the first responder if there's only one field it sets the selected value to that one data.
*/
class AutocompleteTextFieldViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Controls
    
    /// The capture field for the project name
    fileprivate var objectName = PaddedTextField()
    
    /// The accessory view for the projectName
    fileprivate var accessoryView = UIStackView()
    
    // MARK: - Data Properties
    
    /// The project instances
    fileprivate var objects : [JIRA.Object]? = nil
    
    /// the filtered projects
    fileprivate var filteredObjects : [JIRA.Object]? = nil
    
    /// Whether this field is locked
    var isLocked : Bool = false {
        didSet {
            objectName.isUserInteractionEnabled = !isLocked
        }
    }
    
    /// The selected project
    var selectedObject : JIRA.Object? = nil
    
    // MARK: - Exposed properties
    
    /// The placeholder for the field
    var fieldPlaceholder : String? =  nil {
        didSet {
            if let placeholder = fieldPlaceholder {
                objectName.attributedPlaceholder =  NSAttributedString(string: placeholder, attributes: [ NSAttributedString.Key.foregroundColor : UIColor.white ])
            }
        }
    }
    
    /// Handler when the project is selected
    var onObjectSelected : ((JIRA.Object?)->Void)? = nil
    
    /// Handler for loading the data. It requires a closure that has a closure with an optional array of JIRA.Object
    var objectLoaderHandler : ((@escaping ([JIRA.Object]?)->Void)->Void)? = nil
    
    /// An URL for autocompleting data with JIRA
    var autocompleteURL : URL? = nil
    
    /// The type for the autocomplete
    var autocompleteType : JIRA.Object.Type = JIRA.Object.self
    
    // MARK: - View Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        objectLoaderHandler?({
            [weak self] (objects) in
            self?.objects = objects
            self?.filteredObjects = objects
        })
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        accessoryView.axis = .horizontal
        accessoryView.alignment = .fill
        accessoryView.distribution = .fillEqually
        accessoryView.isHidden = true
        accessoryView.bounds = CGRect(x: 0, y: 0, width: 300.0, height: 60.0)
        accessoryView.backgroundColor = UIColor(red: 208, green: 210, blue: 217)
        
        // Setup the project name capture field
        objectName.delegate = self
        objectName.font = UIFont.preferredFont(forTextStyle: .body)
        objectName.textColor = UIColor.black
        objectName.backgroundColor = UIColor(red: 238, green: 238, blue: 238)
        objectName.placeholderInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        objectName.textInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 5)
        objectName.translatesAutoresizingMaskIntoConstraints = false
        objectName.inputAccessoryView = accessoryView
        objectName.autocorrectionType = .no
        objectName.autocapitalizationType = .words
        
        view.addSubview(objectName)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[field]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["field":objectName]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[field]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["field":objectName]))
    }
    
    // MARK: - UITextFieldDelegate
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let mutable = NSMutableString(string: textField.text ?? "")
        mutable.replaceCharacters(in: range, with: string)
        
        let filterString = mutable.copy() as? String ?? ""
        
        if autocompleteURL == nil {
            filter(with: filterString)
        } else {
            autocomplete(with: filterString)
        }
        
        
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if filteredObjects?.count == 1 {
            selectObject(object: filteredObjects?.first)
        }
        return true
    }
    
    // MARK: - Autocomplete support
    
    private func autocomplete( with typed : String ) {
        
        guard let url = autocompleteURL,
              typed.count > 2,
              let builtURL = URL(string: "\(url.absoluteString)\(typed)") else {
                accessoryView.isHidden = true
                return
        }
        
        // Assemble the url with the text typed
        JIRARestAPI.sharedInstance.autocomplete(type : autocompleteType, with: builtURL) { [weak self] (suggestions) in
            self?.filteredObjects = suggestions
            self?.updateSuggestions(suggestions: suggestions)
        }
    }
    
    // MARK: - Filtering support
    
    private func filter( with typed : String ) {
        filteredObjects = objects?.filter {
            return ($0.name?.lowercased() ?? "").contains(typed.lowercased())
        }
        updateSuggestions(suggestions: filteredObjects)
    }
    
    private func updateSuggestions( suggestions : [JIRA.Object]? ) {
        guard let objects = suggestions,
            objects.count > 0 else {
            accessoryView.isHidden = true
            return
        }
            
        let subviews = accessoryView.arrangedSubviews
        let maxLabels = min(2,objects.count-1)
        subviews.forEach { $0.removeFromSuperview()}
        accessoryView.isHidden = false
        
        for i in 0...maxLabels {
            let label = UILabel()
            label.text = objects[i].name ?? ""
            label.font = UIFont.preferredFont(forTextStyle: .body)
            label.backgroundColor = UIColor(red: 208, green: 210, blue: 217)
            label.textColor = UIColor.darkText
            label.isUserInteractionEnabled = true
            label.textAlignment = .center
            label.sizeToFit()
            label.tag = i
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(onSuggestion(gesture:)))
            gesture.numberOfTapsRequired = 1
            label.addGestureRecognizer(gesture)
            
            if i >= 0 && i < maxLabels {
                let separator = UIView()
                separator.backgroundColor = UIColor.gray
                separator.translatesAutoresizingMaskIntoConstraints = false
                label.addSubview(separator)
                separator.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
                separator.topAnchor.constraint(equalTo: label.topAnchor, constant: 5.0).isActive = true
                separator.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: -5.0).isActive = true
                separator.trailingAnchor.constraint(equalTo: label.trailingAnchor).isActive = true
            }
            
            accessoryView.addArrangedSubview(label)
        }
        
        accessoryView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 60.0)
        accessoryView.setNeedsLayout()
    }
    
    private func selectObject( object : JIRA.Object? ) {
        selectedObject = object
        if object != nil {
            objectName.textColor = UIColor.black
            if objectName.isFirstResponder {
                objectName.resignFirstResponder()
                objectName.text = object!.name
            }
        }
        /*
        JIRARestAPI.sharedInstance.fetchCreateIssueMetadata(project: project!) {
            (_) in
        }*/
        onObjectSelected?(selectedObject)
    }
    
    // MARK: - UICallback
    
    @objc func onSuggestion( gesture : UITapGestureRecognizer ) {
        guard let target = gesture.view as? UILabel,
            target.tag >= 0 && target.tag < (filteredObjects?.count ?? 0) else { return }
        selectObject(object: filteredObjects?[target.tag])
    }

}
