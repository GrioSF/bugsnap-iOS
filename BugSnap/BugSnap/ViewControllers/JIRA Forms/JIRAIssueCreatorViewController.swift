//
//  JIRAIssueCreatorViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/18/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Main screen to capture the data about an issue that will be submitted to JIRA.
    Basically this view controller is the top container of multiple controls that will allow to select different information about the issue, in this sense this is a composite instead of relying all the information on this view controller.
 
    TODO: This screen is incomplete but is a good idea to implement dynamic fields creation.
*/
public class JIRAIssueCreatorViewController: UIViewController {
    
    // MARK: - Exposed properties
    
    /// Exposed property to set the snapshot
    var snapshot : UIImage? = nil {
        didSet {
            snapshotView.image = snapshot
        }
    }
    
    /// Handler when this view controller has finished all the changes
    var onDone : (()->Void)? = nil
    
    // MARK: - Internal Controls
    
    /// The annotated snapshot
    fileprivate var snapshotView = UIImageView()
    
    /// The scrollview containing all the controls
    fileprivate var scrollView = UIScrollView()
    
    /// The content view for the scroll view
    fileprivate var contentView = UIView()
    
    /// The projects selector
    fileprivate var projectSelector = AutocompleteTextFieldViewController()
    
    /// The fields controllers
    fileprivate var fieldsControllers = [UIViewController]()
    
    /// The last view controller for fields
    fileprivate var lastLayoutField : UIViewController {
        return fieldsControllers.last ?? projectSelector
    }
    
    /// The fields for creating the issue
    fileprivate var issueFields = [JIRA.IssueField]()
    
    // MARK: - View Life Cycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
        setup()
    }
    
    // MARK: - Setup
    
    /**
        Setup all the components of this view controller.
        This method calls in turn to the methods to setup the scroll view, the image view and the child view controllers
    */
    private func setup() {
        setupScrollView()
        setupImageView()
        setupProjectSelector()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":scrollView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":scrollView]))
        
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
    
    private func setupImageView() {
        snapshotView.translatesAutoresizingMaskIntoConstraints = false
        snapshotView.clipsToBounds = true
        snapshotView.contentMode = .scaleAspectFill
        contentView.addSubview(snapshotView)
        
        snapshotView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.4, constant: 0.0).isActive = true
        snapshotView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        snapshotView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        snapshotView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    private func setupProjectSelector() {
        
        // Setup the handler for the project select
        projectSelector.fieldPlaceholder = "Type the Project Name"
        projectSelector.objectLoaderHandler = JIRARestAPI.sharedInstance.allProjects
        projectSelector.onObjectSelected = {
            [weak self] (project) in
            self?.onProjectSelected(object: project)
        }
        
        projectSelector.view.translatesAutoresizingMaskIntoConstraints = false
        projectSelector.willMove(toParent: self)
        contentView.addSubview(projectSelector.view)
        projectSelector.view.topAnchor.constraint(equalTo: snapshotView.bottomAnchor).isActive = true
        projectSelector.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        projectSelector.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        projectSelector.view.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        addChild(projectSelector)
        projectSelector.didMove(toParent: self)
    }
    
    // MARK: - Data Handling
    
    private func onProjectSelected( object : JIRA.Object? ) {
        guard let project = object as? JIRA.Project  else { return }
        
        let controller = UIAlertController(title: "Wait a sec...", message: "Loading JIRA's project configuration", preferredStyle: .alert)
        present(controller, animated: true, completion: nil)
        
        JIRARestAPI.sharedInstance.fetchCreateIssueMetadata(project: project) { [weak self] (issueTypes) in
            controller.dismiss(animated: true, completion: {
                self?.buildIssueTypeSelector(issueTypes: issueTypes)
            })
        }
    }
    
    // MARK: - Build selection of issue type
    
    private func buildIssueTypeSelector( issueTypes : [JIRA.Project.IssueType]? ) {
        guard let types = issueTypes else { return }
        
        let controller = UIAlertController(title: "Issue Type", message: "Select the issue type", preferredStyle: .alert)
        
        types.forEach {
            let type = $0
            let option = UIAlertAction(title: type.name, style: .default, handler: { [weak self] (_) in
                self?.issueTypeSelected(issueType: type )
                self?.projectSelector.isLocked = true
            })
            controller.addAction(option)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancel)
        present(controller, animated: true, completion: nil)
    }
    
    private func issueTypeSelected( issueType : JIRA.Project.IssueType ) {
        let controller = UIAlertController(title: "Assembling", message: "Assembling the issue fields", preferredStyle: .alert)
        present(controller, animated: true, completion:  nil)
        assemble(issueType: issueType) {
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    private func addDoneButton() {
        navigationItem.setRightBarButtonItems([UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onDone(barItem:)))], animated: false)
    }
    
    // MARK: - UIAssembling

    private func assemble( issueType : JIRA.Project.IssueType, completion: @escaping ()->Void ) {
        
        guard let fields = issueType.fields else {
            DispatchQueue.main.async {
                completion()
            }
            return
        }
        
        
        
        fields.forEach {
            guard let schema = $0.schema,
                  let type = schema.fieldType,
                !schema.isCustom else {
                    return
            }
            
            // A capture field
            if type == "string" {
                addText(field: $0)
            // A field with only one value (provided by the schema)
            } else if $0.allowedValues?.count ?? 0 == 1 {
                addReadOnly(field: $0)
            } else if $0.allowedValues?.count ?? 0 > 1 {
                addPrompt(field: $0)
            // A field that can autocomplete while writing
            } else if $0.autocompleteURL != nil {
                addAutocomplete(field: $0)
            }
        }
        
        // Setup the scroll view
        lastLayoutField.view.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor).isActive = true
        DispatchQueue.main.async {
            completion()
        }
    }
    
    private func sortFields( fields : [JIRA.IssueField]) {
        issueFields.removeAll()
        /*
        issueFields = fields.sorted(by: { (a, b) -> Bool in
            if a.isReadOnly && b.isReadOnly {
                return a.name ?? "" < b.name ?? ""
            } else if a.isReadOnly {
                return true
            } else if b.isReadOnly {
                return false
            } else {
                if a.isSelection && b.isSelection {
                    
                }
            }
            
        })
 */
    }
    
    private func addText( field : JIRA.IssueField ) {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.backgroundColor = UIColor.white
        textView.cornerRadius = 20.0
        textView.borderColor = UIColor.lightGray
        textView.borderWidth = 0.5
        let controller = UIViewController()
        controller.view.addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor, constant: 10.0).isActive = true
        textView.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor, constant: -10.0).isActive = true
        textView.topAnchor.constraint(equalTo: controller.view.topAnchor, constant: 10.0).isActive = true
        textView.bottomAnchor.constraint(equalTo: controller.view.bottomAnchor, constant: -10.0).isActive = true
        
        addFieldChildController(controller: controller, height: 150.0)
    }
    
    private func addReadOnly( field : JIRA.IssueField) {
        let label = UILabel()
        label.text = field.allowedValues?.first?.name
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
        let controller = UIViewController()
        controller.view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor, constant: 10.0).isActive = true
        label.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor, constant: -10.0).isActive = true
        label.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor).isActive = true
        
        addFieldChildController(controller: controller, height: 50.0)
    }
    
    private func addPrompt( field : JIRA.IssueField ) {
        let label = UILabel()
        label.text = field.defaultValue?.name
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
        let controller = UIViewController()
        controller.view.addSubview(label)
        label.leadingAnchor.constraint(equalTo: controller.view.leadingAnchor, constant: 10.0).isActive = true
        label.trailingAnchor.constraint(equalTo: controller.view.trailingAnchor, constant: -10.0).isActive = true
        label.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor).isActive = true
        
        addFieldChildController(controller: controller, height: 50.0)
    }
    
    private func addAutocomplete( field : JIRA.IssueField ) {
        
        let autocomplete = AutocompleteTextFieldViewController()
        autocomplete.willMove(toParent: self)
        autocomplete.fieldPlaceholder = "Type the \(field.name ?? "")"
        autocomplete.autocompleteURL = field.autocompleteURL
        
        if let fieldType = field.schema?.fieldType,
            fieldType == "user" {
            autocomplete.autocompleteType = JIRA.User.self
        }
        
        autocomplete.onObjectSelected = {
            (object) in
            field.value = JIRA.IssueField.Value.fromObject(source: object)
        }
        addFieldChildController(controller: autocomplete, height: 100.0)
    }
    
    private func addFieldChildController( controller : UIViewController, height : CGFloat = 100.0 ) {
        let lastController = lastLayoutField
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(controller.view)
        controller.view.topAnchor.constraint(equalTo: lastController.view.bottomAnchor).isActive = true
        controller.view.heightAnchor.constraint(equalToConstant: height).isActive = true
        controller.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        controller.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        addChild(controller)
        fieldsControllers.append(controller)
        controller.didMove(toParent: self)
    }
    
    // MARK: - UICallback
    
    /**
        Called from the Done button in the navigation bar
    */
    @objc func onDone( barItem : Any?) {
        onDone?()
    }
    

}
