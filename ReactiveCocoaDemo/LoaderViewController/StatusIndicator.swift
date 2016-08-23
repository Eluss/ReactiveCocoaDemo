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

class StatusIndicator {
    
    private var progressHud: MBProgressHUD?
    private var status: Signal<Status, NoError>
    private var rootView: UIView
    private var disposables = CompositeDisposable()
    
    
    init(rootView: UIView, status: Signal<Status, NoError>) {
        self.rootView = rootView
        self.status = status
        
        setupObservers()
    }
 
    private func setupObservers() {
        disposables += status.observeOn(QueueScheduler.mainQueueScheduler).observeNext {[weak self] (status) in
            guard let weakSelf = self else { return }
            switch status {
            case .InProgress:
                weakSelf.progressHud = MBProgressHUD.showHUDAddedTo(weakSelf.rootView, animated: true)
                weakSelf.progressHud?.label.text = "In progress..."
                return
            case .Success:
                weakSelf.progressHud?.mode = .CustomView
                weakSelf.progressHud?.label.text = "Success"
                weakSelf.progressHud?.hideAnimated(true, afterDelay: 0.5)
                return
            case .Failed:
                weakSelf.progressHud?.mode = .CustomView
                weakSelf.progressHud?.label.text = "Failed"
                weakSelf.progressHud?.hideAnimated(true, afterDelay: 0.5)
                return
            }
        }
    }
    
    deinit {
        disposables.dispose()
        print("[DEINIT] ---> StatusIndicator")
    }
    
}