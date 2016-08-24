//
//  MainViewModel.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError

class MainViewModel {
    var menuItems: [MenuItem]
    
    
    init() {
        menuItems = [MenuItem.form(), MenuItem.loader()]
    }
    
    func didChooseMenuItemAtIndex(index: Int) {
        let screen = menuItems[index].screen
    }
    
}