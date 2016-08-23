//
//  LoaderViewController.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import PureLayout

class LoaderViewController: UIViewController {
    
    private var viewModel: LoaderViewModel
    private var taskAButton: UIButton!
    private var taskBButton: UIButton!
    private var statusIndicator: StatusIndicator!
    
    private var taskACocoaAction: CocoaAction!
    private var taskBCocoaAction: CocoaAction!
    
    init(viewModel: LoaderViewModel) {
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
        taskACocoaAction = CocoaAction(viewModel.taskAAction) { _ in }
        taskBCocoaAction = CocoaAction(viewModel.taskBAction) { _ in }
        
        taskAButton.rex_pressed.value = taskACocoaAction
        taskBButton.rex_pressed.value = taskBCocoaAction
    }
    
    private func createComponents() {
        taskAButton = createButtonWithTitle(viewModel.buttonATitle)
        taskBButton = createButtonWithTitle(viewModel.buttonBTitle)
        statusIndicator = StatusIndicator(rootView: view, status: viewModel.statusSignal)
    }
    
    private func createButtonWithTitle(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(UIColor.demoTextColor(), forState: .Normal)
        button.setTitleColor(UIColor.grayColor(), forState: .Disabled)
        button.layer.cornerRadius = 6
        button.showsTouchWhenHighlighted = true
        button.backgroundColor = UIColor.demoBackgroundColor()
        return button
    }
    
    private func addViewsToSuperview() {
        view.addSubview(taskAButton)
        view.addSubview(taskBButton)
    }
    
    private func applyConstraints() {
        
        taskAButton.autoPinEdgeToSuperviewEdge(.Top, withInset: 20)
        taskAButton.autoAlignAxisToSuperviewAxis(.Vertical)
        taskAButton.autoSetDimensionsToSize(CGSizeMake(240, 60))
        
        taskBButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: taskAButton, withOffset: 20)
        taskBButton.autoAlignAxisToSuperviewAxis(.Vertical)
        taskBButton.autoSetDimensionsToSize(CGSizeMake(240, 60))
        
    }
    
    deinit {
        print("[DEINIT] ---> LoaderViewController")
    }
}