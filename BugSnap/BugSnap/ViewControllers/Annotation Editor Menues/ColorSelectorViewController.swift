//
//  ColorSelectorViewController.swift
//  BugSnap
//
//  Created by Héctor García Peña on 6/13/19.
//  Copyright © 2019 Héctor García Peña. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ColorSelectorCell"


/**
    A view controller for selecting colors. The colors are presented in a collection view
*/
public class ColorSelectorViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    /// The available colors for selecting
    var colors = [UIColor?]()
    
    /// The callback when selecting the color. The callback will be called when the color is selected in the popover
    var onColorSelected : ((UIColor?)->Void)? = nil
    
    // MARK: - View Life Cycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 40, height: 40)
            flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            flowLayout.minimumLineSpacing = 5.0
            flowLayout.minimumInteritemSpacing = 5.0
        }
        
        preferredContentSize = CGSize(width: 200.0, height: 250.0)
        setupColors()
        collectionView!.register(PathBasedCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear
    }
    
    // MARK: - Support
    
    private func setupColors() {
        
        colors.append(nil)
        colors.append(UIColor.black)
        colors.append(UIColor.darkText)
        colors.append(UIColor.darkGray)
        colors.append(UIColor.gray)
        colors.append(UIColor.lightGray)
        colors.append(UIColor.lightText)
        colors.append(UIColor.white)
        colors.append(UIColor.red)
        colors.append(UIColor.green)
        colors.append(UIColor.blue)
        colors.append(UIColor.orange)
        colors.append(UIColor.yellow)
        colors.append(UIColor.magenta)
        colors.append(UIColor.purple)
        colors.append(UIColor.brown)
        colors.append(UIColor.cyan)
        
        for i in 0...4 {
            for j in 0...4 {
                for k in 1...4 {
                    let red = CGFloat(i)/4.0
                    let green = CGFloat(j)/4.0
                    let blue = CGFloat(k)/4.0
                    let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
                    colors.append(color)
                }
            }
        }
    }


    // MARK: UICollectionViewDataSource

    override public func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PathBasedCollectionViewCell
        
        cell.setup(buttonType: ColorSelectorButton.self)
        if let shape = cell.shape {
            shape.pathFillColor = colors[indexPath.row]
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PathBasedCollectionViewCell
        
        if let shape = cell.shape {
            onColorSelected?(shape.pathFillColor)
            dismiss(animated: true, completion: nil)
        }
        
    }

}
