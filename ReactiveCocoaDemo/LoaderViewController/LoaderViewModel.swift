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
import ReactiveSwift

enum Status {
    case inProgress
    case success
    case failed
}

class LoaderViewModel {
    
    var buttonATitle = "Task A"
    var buttonBTitle = "Task B"
    
    var taskAAction: Action<Void, Void, NoError>!
    var taskBAction: Action<Void, Void, NoError>!
    var statusSignal: Signal<Status, NoError>
    fileprivate var statusSink: Signal<Status, NoError>.Observer
    
    init() {
        
        (statusSignal, statusSink) = Signal<Status, NoError>.pipe()
        
        taskAAction = Action<Void, Void, NoError>(execute: {[weak self] () -> SignalProducer<Void, NoError> in
            return SignalProducer<Void, NoError> { observer, disposable in
                guard let strongSelf = self else { return }
                strongSelf.statusSink.send(value: .inProgress)
                let date = Date().addingTimeInterval(3)
                QueueScheduler().schedule(after: date, action: {
                    strongSelf.statusSink.send(value: .success)
                    observer.sendCompleted()
                })
            }
        })
        
        taskBAction = Action<Void, Void, NoError>(execute: {[weak self] () -> SignalProducer<Void, NoError> in
            return SignalProducer<Void, NoError> { observer, disposable in
                guard let strongSelf = self else { return }
                strongSelf.statusSink.send(value: .inProgress)
                let date = Date().addingTimeInterval(3)
                QueueScheduler().schedule(after: date, action: {
                    strongSelf.statusSink.send(value: .failed)
                    observer.sendCompleted()
                })
            }
        })
    }
    
    deinit {
        print("[DEINIT] ---> LoaderViewModel")
    }
    
}
