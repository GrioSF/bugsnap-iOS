//
//  ShapeToolViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/17/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

/// The reuse identifier for the cell containing a shape button
private let reuseIdentifier = "PathSelectorTableViewCell"

class ShapeToolViewController: UITableViewController {

    // MARK: - Properties
    
    /// The available colors for selecting
    var tools : [ToolButton.Type] = [ TextTool.self, RectangleTool.self, OvalTool.self, LineTool.self, ForwardArrowTool.self, BackwardArrowTool.self ]
    
    /// The callback when selecting the color. The callback will be called when the color is selected in the popover
    var onToolSelected : ((ShapeToolType)->Void)? = nil
    
    /// The current graphic properties
    var graphicProperties : GraphicProperties!
    
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
        tableView.rowHeight = 50.0
        preferredContentSize = CGSize(width: 50.0, height: 170.0)
    }
    
    // MARK: - Table view data source
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tools.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! PathBasedTableViewCell
        cell.padding = 5.0
        cell.setup(buttonType: tools[indexPath.row])
        cell.shape?.pathFillColor = graphicProperties.fillColor
        cell.shape?.pathStrokeColor = graphicProperties.strokeColor
        return cell
    }
    
    // MARK: - Table View Delegate
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? PathBasedTableViewCell,
            let shape = cell.shape as? ToolButton {
            dismiss(animated: true, completion: nil)
            onToolSelected?(shape.toolType)
        }
    }

}
