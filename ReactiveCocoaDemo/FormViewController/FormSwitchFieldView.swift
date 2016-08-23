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
    
    init(onTitle: String, offTitle: String, isOn: Bool) {
        self.onTitle = onTitle
        self.offTitle = offTitle
        self.isOn = MutableProperty<Bool>(isOn)
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