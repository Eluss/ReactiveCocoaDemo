//
//  LoaderViewModel.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import enum Result.NoError
import ReactiveCocoa

enum Status {
    case InProgress
    case Success
    case Failed
}

class LoaderViewModel {
    
    var buttonATitle = "Task A"
    var buttonBTitle = "Task B"

    
    init() {
        
    }
    
    deinit {
        print("[DEINIT] ---> LoaderViewModel")
    }
    
}