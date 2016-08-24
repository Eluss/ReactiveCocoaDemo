//
//  FormViewModel.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import ReactiveCocoa

class FormViewModel {
    
    var firstNameViewModel: FormFieldViewModel
    var lastNameViewModel: FormFieldViewModel
    var emailViewModel: FormFieldViewModel
    var isSuperUserViewModel: FormSwitchFieldViewModel
    var userDataPresenter: UserDataPresenter

    var acceptTitle = "Save"
    var isSuperUserTitle = "Super user"
    
    private var disposables = CompositeDisposable()
    
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
        
        setupObservers()
    }
    
    private func setupObservers() {
    }
    
    func isValidEmail(testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    deinit {
        print("[DEINIT] ---> FormViewModel")
    }
    
}