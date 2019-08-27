//
//  SearchIssueViewController.swift
//  BugSnap Demo App
//
//  Created by Héctor García Peña on 8/13/19.
//  Copyright © 2019 Grio. All rights reserved.
//

import UIKit
import BugSnap

/**
    Example for searching an issue
*/
class SearchIssueViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {

    // MARK: - IB UI Elements
    
    /// the table for the displaying the issues
    @IBOutlet weak var tableView : UITableView!
    
    /// The text field for autocompleting the issues
    @IBOutlet weak var searchField : UITextField!
    
    
    // MARK: - Data elements
    
    private var issuesFound = [JIRA.IssuePicker]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issuesFound.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let issue = issuesFound[indexPath.row]
        cell.textLabel?.text = "\(issue.key ?? "<Empty Key>") - \(issue.summary ?? "<Empty Summary>")"
        return cell
    }
    
    // MARK: - UITextFielDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let mutableString = NSMutableString(string: textField.text ?? "")
        mutableString.replaceCharacters(in: range, with: string)
        
        
        if mutableString.length > 2 {
            JIRARestAPI.sharedInstance.searchIssue(in: "11935", with: String(mutableString)) {
                [weak self] (issues, errors) in
                
                if errors != nil {
                    self?.presentOperationErrors(errors: errors!)
                } else if issues != nil {
                    self?.issuesFound.removeAll()
                    self?.issuesFound.append(contentsOf: issues!)
                    self?.tableView.reloadData()
                }
                
            }
        } else {
            issuesFound.removeAll()
            tableView.reloadData()
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
