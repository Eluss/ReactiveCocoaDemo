//
//  MenuItemTableViewCell.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import UIKit

class MenuItemTableViewCell: UITableViewCell {
    
    static let reuseId = "MenuItemCell"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: "MenuItemCell")
        contentView.backgroundColor = UIColor.demoBackgroundColor()
        textLabel?.textColor = UIColor.demoTextColor()
        detailTextLabel?.textColor = UIColor.demoTextColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyModel(menuItem: MenuItem) {
        textLabel?.text = menuItem.title
        detailTextLabel?.text = menuItem.subtitle
    }
}