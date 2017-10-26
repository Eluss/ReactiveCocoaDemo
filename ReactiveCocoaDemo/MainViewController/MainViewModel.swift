//
//  MainViewModel.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import enum Result.NoError

class MainViewModel {
    
    var selectedScreen: Signal<Screen, NoError>
    var menuItems: [MenuItem]
    
    fileprivate var selectedScreenObserver: Signal<Screen, NoError>.Observer
    
    init() {
        menuItems = [MenuItem.form(), MenuItem.loader()]
        (selectedScreen, selectedScreenObserver) = Signal<Screen, NoError>.pipe()
    }
    
    func didChooseMenuItemAtIndex(_ index: Int) {
        let screen = menuItems[index].screen
        selectedScreenObserver.send(value: screen)
    }
    
}
