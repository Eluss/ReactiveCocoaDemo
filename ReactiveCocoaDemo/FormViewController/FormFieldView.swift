//
//  FormFieldView.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift

class FormFieldView: UIView {
    
    fileprivate var viewModel: FormFieldViewModel!
    
    fileprivate var titleLabel: UILabel!
    fileprivate var textField: UITextField!
    
    fileprivate var disposables = CompositeDisposable()
    
    init(viewModel: FormFieldViewModel) {
        self.viewModel = viewModel
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {
        setupVisuals()
        createComponents()
        addViewsToSuperview()
        applyConstraints()
        setupObservers()
    }
    
    fileprivate func setupVisuals() {
        backgroundColor = UIColor.demoBackgroundColor()
        layer.cornerRadius = 6
    }
    
    fileprivate func setupObservers() {
        disposables += viewModel.isTitleHidden.producer.startWithValues {[weak self] (isTitleHidden) in
            guard let strongSelf = self else { return }
            UIView.animate(withDuration: 0.4, animations: {
                strongSelf.titleLabel.alpha = isTitleHidden ? 0 : 1
            })
        }
        disposables += viewModel.text <~ textField.reactive.continuousTextValues.map {$0!}
    }
    
    fileprivate func createComponents() {
        textField = createTextField()
        titleLabel = createTitleLabel()
    }
    
    fileprivate func createTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = viewModel.title
        textField.text = viewModel.text.value
        textField.textColor = UIColor.demoTextColor()
        return textField
    }
    
    fileprivate func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.demoTextColor()
        label.text = viewModel.title
        return label
    }
    
    fileprivate func addViewsToSuperview() {
        addSubview(titleLabel)
        addSubview(textField)
    }
    
    fileprivate func applyConstraints() {
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        titleLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        
        textField.autoPinEdge(toSuperviewEdge: .bottom, withInset: 10)
        textField.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        textField.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        textField.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 5)
    }
    
    deinit {
        disposables.dispose()
        print("[DEINIT] ---> FormFieldView")
    }
    
}
