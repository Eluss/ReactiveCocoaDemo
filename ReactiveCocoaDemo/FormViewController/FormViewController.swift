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
import Rex
class FormViewController: UIViewController {
    
    private var viewModel: FormViewModel
    
    private var stackView: UIStackView!
    private var firstNameField: FormFieldView!
    private var lastNameField: FormFieldView!
    private var emailField: FormFieldView!
    private var fields = [UIView]()
    private var acceptButton: UIButton!
    private var acceptCocoaAction: CocoaAction!
    private var isSuperUserSwitch: FormSwitchFieldView!
    
    private var buttonHeightConstraint: NSLayoutConstraint?
    private var buttonWidthConstraint: NSLayoutConstraint?
    private var disposables = CompositeDisposable()
    
    init(viewModel: FormViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
        setupViewController()
    }
    
    private func setupViewController() {
        view.backgroundColor = UIColor.demoLightBackgroundColor()
        createComponents()
        addViewsToSuperview()
        applyConstraints()
        setupObservers()
    }
    
    private func setupObservers() {
        acceptCocoaAction = CocoaAction(viewModel.acceptFormAction, { _ in })
        disposables +=  viewModel.acceptFormAction.errors.observeOn(QueueScheduler.mainQueueScheduler).observeNext {[weak self] (error) in
            guard let weakSelf = self else { return }
            weakSelf.acceptButton.backgroundColor = UIColor.redColor()
        }
        disposables += viewModel.isFormValid.producer.skip(1).skipRepeats().startWithNext {[weak self] (isValid) in
            guard let weakSelf = self else { return }
            weakSelf.animateAcceptButton(isValid)
        }
        acceptButton.rex_pressed.value = acceptCocoaAction
    }
    
    private func animateAcceptButton(isEnabled: Bool) {
        let width: CGFloat = isEnabled ? 240 : 60
        let height: CGFloat = isEnabled ? 60 : 30
        buttonWidthConstraint?.constant = width
        buttonHeightConstraint?.constant = height
        UIView.animateWithDuration(0.35, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func createComponents() {
        stackView = createStackView()
        firstNameField = FormFieldView(viewModel: viewModel.firstNameViewModel)
        lastNameField = FormFieldView(viewModel: viewModel.lastNameViewModel)
        emailField = FormFieldView(viewModel: viewModel.emailViewModel)
        isSuperUserSwitch = FormSwitchFieldView(viewModel: viewModel.isSuperUserViewModel)
        
        acceptButton = createAcceptButton()


        fields = [firstNameField, lastNameField, emailField, isSuperUserSwitch]
    }
    

    
    private func createAcceptButton() -> UIButton {
        let button = UIButton()
        button.setTitle(viewModel.acceptTitle, forState: .Normal)
        button.setTitleColor(UIColor.demoTextColor(), forState: .Normal)
        button.setTitleColor(UIColor.grayColor(), forState: .Disabled)
        button.layer.cornerRadius = 6
        button.showsTouchWhenHighlighted = true
        button.backgroundColor = UIColor.demoBackgroundColor()
        return button
    }
    
    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .Center
        stackView.axis = .Vertical
        stackView.distribution = .EqualSpacing
        stackView.spacing = 20
        return stackView
    }
    
    private func addViewsToSuperview() {
        view.addSubview(stackView)
        fields.forEach { stackView.addArrangedSubview($0) }
        view.addSubview(acceptButton)
        
    }
    
    private func applyConstraints() {
        let insets = UIEdgeInsetsMake(20, 0, 0, 0)
        fields.forEach { (field) in
            field.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
            field.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
            field.autoSetDimension(.Height, toSize: 60)
        }
        
        stackView.autoPinEdgesToSuperviewEdgesWithInsets(insets, excludingEdge: .Bottom)
        stackView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: isSuperUserSwitch)
        
        
        acceptButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: stackView, withOffset: 40)
        buttonHeightConstraint = acceptButton.autoSetDimension(.Height, toSize: 30)
        buttonWidthConstraint = acceptButton.autoSetDimension(.Width, toSize: 60)
        acceptButton.autoAlignAxisToSuperviewAxis(.Vertical)
    }
    
    deinit {
        disposables.dispose()
        print("[DEINIT] ---> FormViewController")
    }
    
}
