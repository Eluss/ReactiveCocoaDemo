//
//  FormField.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift

class FormFieldViewModel {
    
    var title: String
    var text: MutableProperty<String>
    var isTitleHidden = MutableProperty<Bool>(false)
    
    init(title: String, text: MutableProperty<String>) {
        self.title = title
        self.text = text
        setupObservers()
    }
    
    fileprivate func setupObservers() {
        isTitleHidden <~ text.producer.map { $0.isEmpty }
    }
    
    static func firstNameField(_ text: String) -> FormFieldViewModel {
        return FormFieldViewModel(title: "First Name", text: MutableProperty<String>(text))
    }
    
    static func lastNameField(_ text: String) -> FormFieldViewModel {
        return FormFieldViewModel(title: "Last Name", text: MutableProperty<String>(text))
    }
    
    static func emailField(_ text: String) -> FormFieldViewModel {
        return FormFieldViewModel(title: "Email", text: MutableProperty<String>(text))
    }
    
    deinit {
        print("[DEINIT] ---> FormFieldViewModel")
    }

}
