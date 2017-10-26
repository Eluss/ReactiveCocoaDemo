//
//  UserDataPresenter.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa

class UserDataPresenter {
    
    fileprivate var rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func presentUserData(_ user: User) -> SignalProducer<Void, NSError> {
        return SignalProducer<Void, NSError> { observer, disposable in
            let message = self.messageForUser(user)
            let controller = UIAlertController(title: "User", message: message, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
                observer.sendCompleted()
            }))
            controller.addAction(UIAlertAction(title: "Error", style: .destructive, handler: { _ in
                observer.send(error: NSError(domain: "Presenter error", code: 1, userInfo: nil))
            }))
            self.rootViewController.present(controller, animated: true, completion: nil)
        }
    }
    
    fileprivate func messageForUser(_ user: User) -> String {
        return "User data \n firstName: \(user.firstName) \n lastName: \(user.lastName) \n email: \(user.email) \n isSuperUser: \(user.isSuperUser)"
    }
}
