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

class MainFlowController {
    
    private var rootNavigationController: UINavigationController
    
    private var mainViewModel: MainViewModel!
    private var mainViewController: MainViewController!
    private var disposables = CompositeDisposable()
    
    init(rootNavigationController: UINavigationController) {
        self.rootNavigationController = rootNavigationController

        mainViewModel = MainViewModel()
        mainViewController = MainViewController(viewModel: mainViewModel)
        setupObservers()
    }
    
    private func setupObservers() {
        let disposable = mainViewModel.selectedScreen.observeNext {[unowned self] (screen) in
            self.presentScreen(screen)
        }
        disposables.addDisposable(disposable)
    }
    
    private func presentScreen(screen: Screen) {
        switch screen {
        case .Form:
            presentForm()
            return
        case .Loader:
            presentLoader()
            return
        default:
            return
        }
    }
    
    private func presentForm() {
        let presenter = UserDataPresenter(rootViewController: rootNavigationController)
        let viewModel = FormViewModel(userDataPresenter: presenter)
        let formViewController = FormViewController(viewModel: viewModel)
        viewModel.acceptFormAction.rex_completed.observeOn(QueueScheduler.mainQueueScheduler).observeNext { [unowned self] in
            self.dismissFormScreen()
        }
        
        viewModel.acceptFormAction.values.observeNext {(user) in
            print(user)
        }
        
        rootNavigationController.pushViewController(formViewController, animated: true)
    }
    
    private func dismissFormScreen() {
        rootNavigationController.popViewControllerAnimated(true)
    }

    
    private func presentLoader() {
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