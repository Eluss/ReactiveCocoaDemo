//
//  MainViewController.swift
//  ReactiveCocoaDemo
//
//  Created by Eliasz Sawicki on 23/08/16.
//  Copyright © 2016 Eliasz Sawicki. All rights reserved.
//

import Foundation
import UIKit
import PureLayout
import Rex

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let CellReuseId = "Cell"
    
    private var viewModel: MainViewModel
    private var tableView: UITableView!
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    private func setupViewController() {
        createComponents()
        addViewsToSuperview()
        applyConstraints()
        setupObservers()
    }
    
    private func setupObservers() {
        
    }
    
    private func createComponents() {
        tableView = createTableView()
    }
    
    private func createTableView() -> UITableView {
        let tableView = UITableView()
        tableView.registerClass(MenuItemTableViewCell.self, forCellReuseIdentifier: MenuItemTableViewCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.demoBackgroundColor()
        return tableView
    }
    
    private func addViewsToSuperview() {
        view.addSubview(tableView)
    }
    
    private func applyConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MenuItemTableViewCell.reuseId) as! MenuItemTableViewCell
        let menuItem = viewModel.menuItems[indexPath.row]
        cell.applyModel(menuItem)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        viewModel.didChooseMenuItemAtIndex(indexPath.row)
    }
}