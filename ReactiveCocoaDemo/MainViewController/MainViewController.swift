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

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate let CellReuseId = "Cell"
    
    fileprivate var viewModel: MainViewModel
    fileprivate var tableView: UITableView!
    
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
    
    fileprivate func setupViewController() {
        createComponents()
        addViewsToSuperview()
        applyConstraints()
        setupObservers()
    }
    
    fileprivate func setupObservers() {
        
    }
    
    fileprivate func createComponents() {
        tableView = createTableView()
    }
    
    fileprivate func createTableView() -> UITableView {
        let tableView = UITableView()
        tableView.register(MenuItemTableViewCell.self, forCellReuseIdentifier: MenuItemTableViewCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.demoBackgroundColor()
        return tableView
    }
    
    fileprivate func addViewsToSuperview() {
        view.addSubview(tableView)
    }
    
    fileprivate func applyConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemTableViewCell.reuseId) as! MenuItemTableViewCell
        let menuItem = viewModel.menuItems[indexPath.row]
        cell.applyModel(menuItem)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didChooseMenuItemAtIndex(indexPath.row)
    }
}
