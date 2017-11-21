//
//  FormViewModel.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import enum Result.NoError

class FormViewModel {
    
    var firstNameViewModel: FormFieldViewModel
    var lastNameViewModel: FormFieldViewModel
    var emailViewModel: FormFieldViewModel
    var isSuperUserViewModel: FormSwitchFieldViewModel
    var userDataPresenter: UserDataPresenter
    var isFormValid = MutableProperty<Bool>(false)
    var acceptFormAction: Action<Void, User, NSError>!
    var acceptTitle = "Save"
    var isSuperUserTitle = "Super user"
    
    fileprivate var disposables = CompositeDisposable()
    
    var user: User {
        let firstName = firstNameViewModel.text.value
        let lastName = lastNameViewModel.text.value
        let email = emailViewModel.text.value
        let isSuperUser = isSuperUserViewModel.isOn.value
        return User(firstName: firstName, lastName: lastName, email: email, isSuperUser: isSuperUser)
    }
    
    convenience init(userDataPresenter: UserDataPresenter) {
        let user = User()
        self.init(user: user, userDataPresenter: userDataPresenter)
    }
    
    init(user: User, userDataPresenter: UserDataPresenter) {
        self.userDataPresenter = userDataPresenter
        firstNameViewModel = FormFieldViewModel.firstNameField(user.firstName)
        lastNameViewModel = FormFieldViewModel.lastNameField(user.lastName)
        emailViewModel = FormFieldViewModel.emailField(user.email)
        isSuperUserViewModel = FormSwitchFieldViewModel(onTitle: "Super user", offTitle: "Default user", isOn: user.isSuperUser)
        
        acceptFormAction = Action<Void, User, NSError>(enabledIf: isFormValid, execute: {[unowned self] () -> SignalProducer<User, NSError> in
            return self.saveUser()
        })
        
        setupObservers()
    }
    
    fileprivate func saveUser() -> SignalProducer<User, NSError> {
        return SignalProducer<User, NSError> {[weak self] observer, disposable in
            guard let weakSelf = self else { return }
            let user = weakSelf.user
            let presenting = weakSelf.userDataPresenter.presentUserData(user)
            presenting.startWithSignal({ (signal, disposable) in
                
                signal.observeCompleted({
                    observer.send(value: user)
                    observer.sendCompleted()
                })
                
                signal.observeFailed({ (error) in
                    observer.send(error: error)
                })
            })
        }
    }
    
    fileprivate func setupObservers() {
        
        saveUser().startWithResult { (result) in
            switch result {
                case .success(let r)
            }
        }
        
        disposables += isFormValid <~ SignalProducer.combineLatest(
            firstNameViewModel.text.producer,
            lastNameViewModel.text.producer,
            emailViewModel.text.producer).map({[unowned self] (firstName, lastName, email) -> Bool in
                return self.isValidEmail(email) && !firstName.isEmpty && !lastName.isEmpty
            })
    }
    
    func isValidEmail(_ testStr: String) -> Bool {        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    deinit {
        print("[DEINIT] ---> FormViewModel")
    }
    
}

struct Idea {
    var content: String
    var quality: Quality
}

enum Quality {
    case great
    case average
    case worst
}
