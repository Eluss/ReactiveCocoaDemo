//
//  MenuItem.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation

enum Screen {
    case form
    case loader
    case networkRequest
    case uiManipulation
}

struct MenuItem {
    
    var title: String
    var subtitle: String
    var screen: Screen
    
    static func form() -> MenuItem {
        return MenuItem(title: "Form", subtitle: "Form with validation", screen: .form)
    }
    
    static func loader() -> MenuItem {
        return MenuItem(title: "Loader", subtitle: "Loader etc", screen: .loader)
    }
}
