//
//  MainFlowController.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift

class MainFlowController {
    
    fileprivate var rootNavigationController: UINavigationController
    
    fileprivate var mainViewModel: MainViewModel!
    fileprivate var mainViewController: MainViewController!
    fileprivate var disposables = CompositeDisposable()
    
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController
        
        mainViewModel = MainViewModel()
        mainViewController = MainViewController(viewModel: mainViewModel)
        setupObservers()
    }
    
    fileprivate func setupObservers() {
        let disposable = mainViewModel.selectedScreen.observeResult {[unowned self] (result) in
            if case let .success(screen) = result {
                self.presentScreen(screen)
            }
            
        }
        disposables.add(disposable)
    }
    
    fileprivate func presentScreen(_ screen: Screen) {
        switch screen {
        case .form:
            presentForm()
            return
        case .loader:
            presentLoader()
            return
        default:
            return
        }
    }
    
    fileprivate func presentForm() {
        let presenter = UserDataPresenter(rootViewController: rootNavigationController)
        let viewModel = FormViewModel(userDataPresenter: presenter)
        let formViewController = FormViewController(viewModel: viewModel)
        viewModel.acceptFormAction.completed.observe(on: QueueScheduler.main).observeResult { (result) in
            if case .success(_) = result {
                self.dismissFormScreen()
            }
        }
        
        rootNavigationController.pushViewController(formViewController, animated: true)
    }
    
    fileprivate func dismissFormScreen() {
        rootNavigationController.popViewController(animated: true)
    }
    
    
    fileprivate func presentLoader() {
        let viewModel = LoaderViewModel()
        let controller = LoaderViewController(viewModel: viewModel)
        rootNavigationController.pushViewController(controller, animated: true)
    }
    
    
    
    func startFlow() {
        rootNavigationController.pushViewController(mainViewController, animated: true)
    }
    
    deinit {
        disposables.dispose()
    }
}
