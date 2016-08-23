//
//  UserDataPresenter.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import UIKit

import ReactiveCocoa

class UserDataPresenter {
    
    private var rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func presentUserData(user: User) -> SignalProducer<Void, NSError> {
        return SignalProducer<Void, NSError> { observer, disposable in
            let message = self.messageForUser(user)
            let controller = UIAlertController(title: "User", message: message, preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: { (action) in
                observer.sendCompleted()
            }))
            controller.addAction(UIAlertAction(title: "Error", style: .Destructive, handler: { _ in
                observer.sendFailed(NSError(domain: "Presenter error", code: 1, userInfo: nil))
            }))
            self.rootViewController.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    private func messageForUser(user: User) -> String {
        return "User data \n firstName: \(user.firstName) \n lastName: \(user.lastName) \n email: \(user.email) \n isSuperUser: \(user.isSuperUser)"
    }
}