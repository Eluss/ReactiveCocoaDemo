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
import MBProgressHUD
import ReactiveSwift

class StatusIndicator {
    
    fileprivate var progressHud: MBProgressHUD?
    fileprivate var status: Signal<Status, NoError>
    fileprivate var rootView: UIView
    fileprivate var disposables = CompositeDisposable()
    
    
    init(rootView: UIView, status: Signal<Status, NoError>) {
        self.rootView = rootView
        self.status = status
        
        setupObservers()
    }
 
    fileprivate func setupObservers() {
        disposables += status.observe(on: QueueScheduler.main).observeValues {[weak self] (status) in
            guard let strongSelf = self else { return }
            switch status {
            case .inProgress:
                strongSelf.progressHud = MBProgressHUD.showAdded(to: strongSelf.rootView, animated: true)
                strongSelf.progressHud?.label.text = "In progress..."
                return
            case .success:
                strongSelf.progressHud?.mode = .customView
                strongSelf.progressHud?.label.text = "Success"
                strongSelf.progressHud?.hide(animated: true, afterDelay: 0.5)
                return
            case .failed:
                strongSelf.progressHud?.mode = .customView
                strongSelf.progressHud?.label.text = "Failed"
                strongSelf.progressHud?.hide(animated: true, afterDelay: 0.5)
                return
            }
        }
    }
    
    deinit {
        disposables.dispose()
        print("[DEINIT] ---> StatusIndicator")
    }
    
}
