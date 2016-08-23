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
import Rex
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
        
        switchAction = Action<Bool, String, NoError>({[weak self] (isOn) -> SignalProducer<String, NoError> in
            return SignalProducer<String, NoError> { observer, disposable in
                guard let weakSelf = self else { return }
                let text = isOn ? weakSelf.onTitle : weakSelf.offTitle
                observer.sendNext(text)
                observer.sendCompleted()
            }
        })
        
        setupObservers()
    }
    
    private func setupObservers() {
    }
    
    deinit {
        print("[DEINIT] ---> FormSwitchFieldViewModel")
    }
    
}

class FormSwitchFieldView: UIView {
    
    private var viewModel: FormSwitchFieldViewModel!
    
    private var titleLabel: UILabel!
    private var switchControl: UISwitch!
    private var switchCocoaAction: CocoaAction!
    private var disposables = CompositeDisposable()
    
    init(viewModel: FormSwitchFieldViewModel) {
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
        disposables += viewModel.isOn <~ switchControl.rex_on
        switchCocoaAction = CocoaAction(viewModel.switchAction, { (control) -> Bool in
            let control = control as! UISwitch
            return control.on
        })
        switchControl.addTarget(switchCocoaAction, action: CocoaAction.selector, forControlEvents: .ValueChanged)
        disposables += titleLabel.rex_text <~ viewModel.switchAction.values.map { $0 }
    }
    
    private func createComponents() {
        switchControl = createSwitchControl()
        titleLabel = createTitleLabel()
    }
    
    private func createSwitchControl() -> UISwitch {
        let switchControl = UISwitch()
        switchControl.on = viewModel.isOn.value
        return switchControl
    }
    
    private func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.demoTextColor()
        label.text = viewModel.isOn.value ? viewModel.onTitle : viewModel.offTitle
        return label
    }
    
    private func addViewsToSuperview() {
        addSubview(titleLabel)
        addSubview(switchControl)
    }
    
    private func applyConstraints() {
        switchControl.autoPinEdgeToSuperviewEdge(.Left, withInset: 20)
        switchControl.autoAlignAxisToSuperviewAxis(.Horizontal)
        
        titleLabel.autoPinEdge(.Left, toEdge: .Right, ofView: switchControl, withOffset: 20)
        titleLabel.autoAlignAxisToSuperviewAxis(.Horizontal)
    }
    
    deinit {
        disposables.dispose()
        print("[DEINIT] ---> FormSwitchFieldView")
    }
    
}