//
//  FormField.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import ReactiveCocoa

class FormFieldViewModel {
    
    var title: String
    var text: MutableProperty<String>
    var isTitleHidden = MutableProperty<Bool>(false)
    
    init(title: String, text: MutableProperty<String>) {
        self.title = title
        self.text = text
        setupObservers()
    }
    
    private func setupObservers() {
    }
    
    static func firstNameField(text: String) -> FormFieldViewModel {
        return FormFieldViewModel(title: "First Name", text: MutableProperty<String>(text))
    }
    
    static func lastNameField(text: String) -> FormFieldViewModel {
        return FormFieldViewModel(title: "Last Name", text: MutableProperty<String>(text))
    }
    
    static func emailField(text: String) -> FormFieldViewModel {
        return FormFieldViewModel(title: "Email", text: MutableProperty<String>(text))
    }
    
    deinit {
        print("[DEINIT] ---> FormFieldViewModel")
    }

}