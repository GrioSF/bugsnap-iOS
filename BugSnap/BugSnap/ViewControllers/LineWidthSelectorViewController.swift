//
//  LineWidthSelectorViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/14/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PathSelectorTableViewCell"

public class LineWidthSelectorViewController: UITableViewController {
    
    // MARK: - Properties
    
    /// The available colors for selecting
    var widths : [CGFloat] = [ 0.5, 1.0 , 1.5, 2.0 , 3.0, 4.0, 5.0, 8.0, 10.0, 20.0 , 30.0 ]
    
    /// The callback when selecting the color. The callback will be called when the color is selected in the popover
    var onLineWidthSelected : ((CGFloat)->Void)? = nil

    // MARK : - View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear
        tableView.backgroundView = UIView()
        tableView.backgroundView?.backgroundColor = UIColor.clear
        tableView.register(PathBasedTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.allowsSelection = true
        tableView.delegate = self
        preferredContentSize = CGSize(width: 100.0, height: 250.0)
    }

    // MARK: - Table view data source

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return widths.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! PathBasedTableViewCell
        cell.setup(buttonType: LineWidthButton.self)
        if let shape = cell.shape {
            shape.pathLineWidth = widths[indexPath.row]
        }
        return cell
    }
    
    // MARK: - Table View Delegate
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? PathBasedTableViewCell,
           let shape = cell.shape {
            dismiss(animated: true, completion: nil)
            onLineWidthSelected?(shape.pathLineWidth)
        }
    }

}
