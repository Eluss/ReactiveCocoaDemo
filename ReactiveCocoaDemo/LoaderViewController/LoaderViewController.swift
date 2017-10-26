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
    
    fileprivate var viewModel: LoaderViewModel
    fileprivate var taskAButton: UIButton!
    fileprivate var taskBButton: UIButton!
    fileprivate var statusIndicator: StatusIndicator!
    
    fileprivate var taskACocoaAction: CocoaAction<UIButton>!
    fileprivate var taskBCocoaAction: CocoaAction<UIButton>!
    
    init(viewModel: LoaderViewModel) {
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
        taskACocoaAction = CocoaAction(viewModel.taskAAction) { _ in }
        taskBCocoaAction = CocoaAction(viewModel.taskBAction) { _ in }
        
        taskAButton.reactive.pressed = taskACocoaAction
        taskBButton.reactive.pressed = taskBCocoaAction
    }
    
    fileprivate func createComponents() {
        taskAButton = createButtonWithTitle(viewModel.buttonATitle)
        taskBButton = createButtonWithTitle(viewModel.buttonBTitle)        
        statusIndicator = StatusIndicator(rootView: view, status: viewModel.statusSignal)
    }
    
    fileprivate func createButtonWithTitle(_ title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.demoTextColor(), for: UIControlState())
        button.setTitleColor(UIColor.gray, for: .disabled)
        button.layer.cornerRadius = 6
        button.showsTouchWhenHighlighted = true
        button.backgroundColor = UIColor.demoBackgroundColor()
        return button
    }
    
    fileprivate func addViewsToSuperview() {
        view.addSubview(taskAButton)
        view.addSubview(taskBButton)
    }
    
    fileprivate func applyConstraints() {
        
        taskAButton.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
        taskAButton.autoAlignAxis(toSuperviewAxis: .vertical)
        taskAButton.autoSetDimensions(to: CGSize(width: 240, height: 60))
        
        taskBButton.autoPinEdge(.top, to: .bottom, of: taskAButton, withOffset: 20)
        taskBButton.autoAlignAxis(toSuperviewAxis: .vertical)
        taskBButton.autoSetDimensions(to: CGSize(width: 240, height: 60))
        
    }
    
    deinit {
        print("[DEINIT] ---> LoaderViewController")
    }
}
