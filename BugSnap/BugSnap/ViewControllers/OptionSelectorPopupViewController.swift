//
//  OptionSelectorPopupViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 8/8/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/**
    Extension of Mirror to get the value of some property
*/
extension Mirror {
    
    /**
        Gets the value for some property given the name searching in its supermirror if available
        - Parameter name: The name of the property to search for
    */
    func valueForProperty( name : String ) -> Any? {
        let propertiesWithName = children.filter { ($0.label ?? "") == name }
        guard propertiesWithName.count > 0 else {
            return superclassMirror?.valueForProperty(name: name)
        }
        return propertiesWithName.first!.value
    }
}

/**
    A custom cell with transparent background and custom font
*/
fileprivate class OptionTableViewCell : UITableViewCell {
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = UIColor.clear
        backgroundView = UIView()
        backgroundView?.backgroundColor = backgroundColor
        textLabel?.font = UIFont(name: "HelveticaNeue", size: 16.0)
        textLabel?.textAlignment = .center
        textLabel?.textColor = UIColor.darkGray
    }
    
    // MARK: - Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = ""
    }
}

/**
    View Controller to display some options in a table (like a menu)
*/
public class OptionSelectorPopupViewController<optionType: NSObject>: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - UI Properties
    
    /// The identifier for the cell
    private let optionsCellIdentifier = "cell"
    
    /// The container for the options
    private var containerView : UIVisualEffectView!
    
    /// The table for displaying the actual options
    private var tableView : UITableView!
    
    // MARK: - Exposed properties
    
    /// The actual options to be displayed in the table view
    var options : [optionType]!
    
    /// The name of the property that describes the option (and will be displayed)
    var propertyName : String!
    
    /// The handler when an option is selected
    var selectionHandler : ((optionType)->Void)? = nil
    
    
    // MARK: - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        
        // setup this view
        view.cornerRadius = 5.0
        view.backgroundColor = UIColor.clear
        
        // Add the background for the table view
        containerView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":containerView!]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":containerView!]))
        
        // Add the table view to the blur view
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = UIView()
        tableView.backgroundView?.backgroundColor = UIColor.clear
        tableView.rowHeight = 50.0
        tableView.separatorColor = UIColor.lightGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OptionTableViewCell.self, forCellReuseIdentifier: optionsCellIdentifier)
        
        containerView.contentView.addSubview(tableView)
        containerView.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":tableView!]))
        containerView.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view":tableView!]))
    }
    
    // MARK: - UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: optionsCellIdentifier, for: indexPath)
        let object = options[indexPath.row]
        cell.textLabel?.text = ( Mirror(reflecting: object).valueForProperty(name: propertyName!) as? String ) ?? "Not Found"
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = options[indexPath.row]
        let handler = selectionHandler
        DispatchQueue.main.async {
            handler?(option)
        }
    }
    
}
