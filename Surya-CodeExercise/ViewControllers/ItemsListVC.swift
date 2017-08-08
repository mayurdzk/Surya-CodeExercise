//
//  ItemsListVC.swift
//  Surya-CodeExercise
//
//  Created by Mayur on 05/08/17.
//  Copyright © 2017 Mayur. All rights reserved.
//

import UIKit

class ItemsListVC: UIViewController {
    @IBOutlet weak var itemsTableView: UITableView!

    fileprivate var itemsDataSource = [ItemViewModel]() {
        didSet {
            setTableViewCellSeperator()
            itemsTableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        itemsTableView.rowHeight = UITableViewAutomaticDimension
        itemsTableView.estimatedRowHeight = 100
        itemsTableView.allowsSelection = false
        setItemsDataSource()
        setTableViewCellSeperator()
        NetworkingManager().fetchAllItems { [weak self] (result) in
            self?.setItemsDataSource()
        }
    }
    
    /// Call this method to set the itemsDataSource property with all available items stored in the disk
    func setItemsDataSource() {
        ModelManager().itemsAsViewModels { [weak self] (itemsAsViewModels) in
            self?.itemsDataSource = itemsAsViewModels
        }
    }
    
    
    /// Sets the cell seperator style for the itemsTableView based on the data source
    func setTableViewCellSeperator() {
        if itemsDataSource.count > 0 {
            itemsTableView.separatorStyle = .singleLine
        } else {
            itemsTableView.separatorStyle = .none
        }
    }
}

//MARK: -
//MARK: TableView Delegate and DataSource conformance
extension ItemsListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let itemCell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.reuseIdentifier, for: indexPath) as? ItemTableViewCell else {
            crashDebug(with: "An Item Cell could not be dequeued")
            return UITableViewCell()
        }
        let item = itemsDataSource[indexPath.row]
        itemCell.configured(from: item)
        return itemCell
    }
}

//MARK: -
//MARK: StoryboardInstantiable conformance
extension ItemsListVC: StoryboardInstantiable {
    static let codeExerciseStoryboard: CodeExerciseStoryboards = .main
    static let sceneIdentifier: String = "ItemsListVC"
}
