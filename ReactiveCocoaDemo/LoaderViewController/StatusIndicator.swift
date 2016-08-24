//
//  StatusIndicator.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import ReactiveCocoa
import enum Result.NoError

class StatusIndicator {
    
    private var status: Signal<Status, NoError>
    private var rootView: UIView
    private var disposables = CompositeDisposable()
    
    
    init(rootView: UIView, status: Signal<Status, NoError>) {
        self.rootView = rootView
        self.status = status
        
        setupObservers()
    }
 
    private func setupObservers() {

//            switch status {
//            case .InProgress:
//                progressHud = MBProgressHUD.showHUDAddedTo(rootView, animated: true)
//                progressHud?.label.text = "In progress..."
//                return
//            case .Success:
//                progressHud?.mode = .CustomView
//                progressHud?.label.text = "Success"
//                progressHud?.hideAnimated(true, afterDelay: 0.5)
//                return
//            case .Failed:
//                progressHud?.mode = .CustomView
//                progressHud?.label.text = "Failed"
//                progressHud?.hideAnimated(true, afterDelay: 0.5)
//                return
//            }
//        }
    }
    
    deinit {
        disposables.dispose()
        print("[DEINIT] ---> StatusIndicator")
    }
    
}