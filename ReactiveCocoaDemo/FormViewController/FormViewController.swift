//
//  FormViewController.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import UIKit
import PureLayout
import ReactiveCocoa
import ReactiveSwift

class FormViewController: UIViewController {
    
    fileprivate var viewModel: FormViewModel
    
    fileprivate var stackView: UIStackView!
    fileprivate var firstNameField: FormFieldView!
    fileprivate var lastNameField: FormFieldView!
    fileprivate var emailField: FormFieldView!
    fileprivate var fields = [UIView]()
    fileprivate var acceptButton: UIButton!
    fileprivate var acceptCocoaAction: CocoaAction<UIButton>!
    fileprivate var isSuperUserSwitch: FormSwitchFieldView!
    
    fileprivate var buttonHeightConstraint: NSLayoutConstraint?
    fileprivate var buttonWidthConstraint: NSLayoutConstraint?
    fileprivate var disposables = CompositeDisposable()
    
    init(viewModel: FormViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge()
        setupViewController()
    }
    
    fileprivate func setupViewController() {
        view.backgroundColor = UIColor.demoLightBackgroundColor()
        createComponents()
        addViewsToSuperview()
        applyConstraints()
        setupObservers()
    }
    
    fileprivate func setupObservers() {
        acceptCocoaAction = CocoaAction(viewModel.acceptFormAction, { _ in })
        disposables += 
            viewModel.acceptFormAction.errors.observe(on: QueueScheduler.main).observeValues {[weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.acceptButton.backgroundColor = .red
        }
        
        disposables += viewModel.isFormValid.producer.skip(first: 1).skipRepeats().startWithValues {[weak self] (isValid) in
            guard let strongSelf = self else { return }
            strongSelf.animateAcceptButton(isValid)
        }
        acceptButton.reactive.pressed = acceptCocoaAction        
    }
    
    fileprivate func animateAcceptButton(_ isEnabled: Bool) {
        let width: CGFloat = isEnabled ? 240 : 60
        let height: CGFloat = isEnabled ? 60 : 30
        buttonWidthConstraint?.constant = width
        buttonHeightConstraint?.constant = height
        UIView.animate(withDuration: 0.35, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func createComponents() {
        stackView = createStackView()
        firstNameField = FormFieldView(viewModel: viewModel.firstNameViewModel)
        lastNameField = FormFieldView(viewModel: viewModel.lastNameViewModel)
        emailField = FormFieldView(viewModel: viewModel.emailViewModel)
        isSuperUserSwitch = FormSwitchFieldView(viewModel: viewModel.isSuperUserViewModel)
        
        acceptButton = createAcceptButton()


        fields = [firstNameField, lastNameField, emailField, isSuperUserSwitch]
    }
    

    
    fileprivate func createAcceptButton() -> UIButton {
        let button = UIButton()
        button.setTitle(viewModel.acceptTitle, for: UIControlState())
        button.setTitleColor(UIColor.demoTextColor(), for: UIControlState())
        button.setTitleColor(UIColor.gray, for: .disabled)
        button.layer.cornerRadius = 6
        button.showsTouchWhenHighlighted = true
        button.backgroundColor = UIColor.demoBackgroundColor()
        return button
    }
    
    fileprivate func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }
    
    fileprivate func addViewsToSuperview() {
        view.addSubview(stackView)
        fields.forEach { stackView.addArrangedSubview($0) }
        view.addSubview(acceptButton)
        
    }
    
    fileprivate func applyConstraints() {
        let insets = UIEdgeInsetsMake(20, 0, 0, 0)
        fields.forEach { (field) in
            field.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            field.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
            field.autoSetDimension(.height, toSize: 60)
        }
        
        stackView.autoPinEdgesToSuperviewEdges(with: insets, excludingEdge: .bottom)
        stackView.autoPinEdge(.bottom, to: .bottom, of: isSuperUserSwitch)
        
        
        acceptButton.autoPinEdge(.top, to: .bottom, of: stackView, withOffset: 40)
        buttonHeightConstraint = acceptButton.autoSetDimension(.height, toSize: 30)
        buttonWidthConstraint = acceptButton.autoSetDimension(.width, toSize: 60)
        acceptButton.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
    deinit {
        disposables.dispose()
        print("[DEINIT] ---> FormViewController")
    }
    
}
