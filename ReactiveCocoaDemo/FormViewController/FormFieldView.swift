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
import Rex

class FormFieldView: UIView {
    
    private var viewModel: FormFieldViewModel!
    
    private var titleLabel: UILabel!
    private var textField: UITextField!
    
    private var disposables = CompositeDisposable()
    
    init(viewModel: FormFieldViewModel) {
        self.viewModel = viewModel
        super.init(frame: CGRectZero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setupVisuals()
        createComponents()
        addViewsToSuperview()
        applyConstraints()
        setupObservers()
    }
    
    private func setupVisuals() {
        backgroundColor = UIColor.demoBackgroundColor()
        layer.cornerRadius = 6
    }
    
    private func setupObservers() {
        disposables += viewModel.isTitleHidden.producer.startWithNext {[weak self] (isTitleHidden) in
            guard let weakSelf = self else { return }
            UIView.animateWithDuration(0.4, animations: {
                weakSelf.titleLabel.alpha = isTitleHidden ? 0 : 1
            })
        }
        disposables += viewModel.text <~ textField.rex_text.producer.map {
            $0!
        }
    }
    
    private func createComponents() {
        textField = createTextField()
        titleLabel = createTitleLabel()
    }
    
    private func createTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = viewModel.title
        textField.text = viewModel.text.value
        textField.textColor = UIColor.demoTextColor()
        return textField
    }
    
    private func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.demoTextColor()
        label.text = viewModel.title
        return label
    }
    
    private func addViewsToSuperview() {
        addSubview(titleLabel)
        addSubview(textField)
    }
    
    private func applyConstraints() {
        titleLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 10)
        titleLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: 20)
        
        textField.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
        textField.autoPinEdgeToSuperviewEdge(.Left, withInset: 20)
        textField.autoPinEdgeToSuperviewEdge(.Right, withInset: 20)
        textField.autoPinEdge(.Top, toEdge: .Bottom, ofView: titleLabel, withOffset: 5)
    }
    
    deinit {
        disposables.dispose()
        print("[DEINIT] ---> FormFieldView")
    }
    
}