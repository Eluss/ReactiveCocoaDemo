//
//  FormSwitchField.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift

import enum Result.NoError

class FormSwitchFieldViewModel {
    
    var onTitle: String
    var offTitle: String
    var isOn: MutableProperty<Bool>
    var switchAction: Action<Bool, String, NoError>!
    
    init(onTitle: String, offTitle: String, isOn: Bool) {
        self.onTitle = onTitle
        self.offTitle = offTitle
        self.isOn = MutableProperty<Bool>(isOn)
        
        switchAction = Action<Bool, String, NoError>(execute: {[weak self] (isOn) -> SignalProducer<String, NoError> in
            return SignalProducer<String, NoError> { observer, disposable in
                guard let strongSelf = self else { return }
                let text = isOn ? strongSelf.onTitle : strongSelf.offTitle
                observer.send(value: text)
                observer.sendCompleted()
            }
        })
        
        setupObservers()
    }
    
    fileprivate func setupObservers() {
    }
    
    deinit {
        print("[DEINIT] ---> FormSwitchFieldViewModel")
    }
    
}

class FormSwitchFieldView: UIView {
    
    fileprivate var viewModel: FormSwitchFieldViewModel!
    
    fileprivate var titleLabel: UILabel!
    fileprivate var switchControl: UISwitch!
    fileprivate var switchCocoaAction: CocoaAction<UISwitch>!
    fileprivate var disposables = CompositeDisposable()
    
    init(viewModel: FormSwitchFieldViewModel) {
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
        disposables += viewModel.isOn <~ switchControl.reactive.isOnValues
        switchCocoaAction = CocoaAction(viewModel.switchAction, { (control) -> Bool in
            return control.isOn
        })
        switchControl.addTarget(switchCocoaAction, action: CocoaAction<UISwitch>.selector, for: .valueChanged)
        disposables += titleLabel.reactive.text <~ viewModel.switchAction.values.map { $0 }
    }
    
    fileprivate func createComponents() {
        switchControl = createSwitchControl()
        titleLabel = createTitleLabel()
    }
    
    fileprivate func createSwitchControl() -> UISwitch {
        let switchControl = UISwitch()
        switchControl.isOn = viewModel.isOn.value
        return switchControl
    }
    
    fileprivate func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.demoTextColor()
        label.text = viewModel.isOn.value ? viewModel.onTitle : viewModel.offTitle
        return label
    }
    
    fileprivate func addViewsToSuperview() {
        addSubview(titleLabel)
        addSubview(switchControl)
    }
    
    fileprivate func applyConstraints() {
        switchControl.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        switchControl.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        titleLabel.autoPinEdge(.left, to: .right, of: switchControl, withOffset: 20)
        titleLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
    }
    
    deinit {
        disposables.dispose()
        print("[DEINIT] ---> FormSwitchFieldView")
    }
    
}
