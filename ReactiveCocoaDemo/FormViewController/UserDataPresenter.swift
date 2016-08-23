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
    
    private func messageForUser(user: User) -> String {
        return "User data \n firstName: \(user.firstName) \n lastName: \(user.lastName) \n email: \(user.email) \n isSuperUser: \(user.isSuperUser)"
    }
}