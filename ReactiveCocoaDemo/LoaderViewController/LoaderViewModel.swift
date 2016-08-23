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
    
    var taskAAction: Action<Void, Void, NoError>!
    var taskBAction: Action<Void, Void, NoError>!
    var statusSignal: Signal<Status, NoError>
    private var statusSink: Observer<Status, NoError>
    
    init() {
        
        (statusSignal, statusSink) = Signal<Status, NoError>.pipe()
        
        taskAAction = Action<Void, Void, NoError>({[weak self] () -> SignalProducer<Void, NoError> in
            return SignalProducer<Void, NoError> { observer, disposable in
                guard let weakSelf = self else { return }
                weakSelf.statusSink.sendNext(.InProgress)
                let date = NSDate().dateByAddingTimeInterval(3)
                QueueScheduler().scheduleAfter(date, action: {
                        weakSelf.statusSink.sendNext(.Success)
                        observer.sendCompleted()
                })
            }
        })
        
        taskBAction = Action<Void, Void, NoError>({[weak self] () -> SignalProducer<Void, NoError> in
            return SignalProducer<Void, NoError> { observer, disposable in
                guard let weakSelf = self else { return }
                weakSelf.statusSink.sendNext(.InProgress)
                let date = NSDate().dateByAddingTimeInterval(3)
                QueueScheduler().scheduleAfter(date, action: {
                    weakSelf.statusSink.sendNext(.Failed)
                    observer.sendCompleted()
                })
            }
        })
    }
    
    deinit {
        print("[DEINIT] ---> LoaderViewModel")
    }
    
}